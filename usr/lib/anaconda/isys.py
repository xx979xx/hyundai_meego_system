#
# isys.py - installer utility functions and glue for C module
#
# Copyright (C) 2001, 2002, 2003, 2004, 2005, 2006, 2007  Red Hat, Inc.
# All rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Author(s): Matt Wilson <msw@redhat.com>
#            Erik Troan <ewt@redhat.com>
#            Jeremy Katz <katzj@redhat.com>
#

import _isys
import string
import os
import os.path
import socket
import stat
import posix
import sys
import iutil
import warnings
import resource
import re
import struct
import block
#import udev
import rhpl
import dbus

import logging
log = logging.getLogger("anaconda")
import warnings

CONN_SERVICE = "org.moblin.connman"
CONN_ERROR_IFACE = CONN_SERVICE + ".Error"
CONN_AGENT_IFACE = CONN_SERVICE + ".Agent"
CONN_MANAGER_IFACE = CONN_SERVICE + ".Manager"
CONN_MANAGER_PATH = "/"
CONN_PROFILE_IFACE = CONN_SERVICE + ".Profile"
CONN_DEVICE_IFACE = CONN_SERVICE + ".Device"
CONN_NETWORK_IFACE = CONN_SERVICE + ".Network"
CONN_CONNECTION_IFACE = CONN_SERVICE + ".Connection"

NM_SERVICE = "org.freedesktop.NetworkManager"
NM_MANAGER_PATH = "/org/freedesktop/NetworkManager"
NM_MANAGER_IFACE = "org.freedesktop.NetworkManager"
NM_ACTIVE_CONNECTION_IFACE = "org.freedesktop.NetworkManager.Connection.Active"
NM_CONNECTION_IFACE = "org.freedesktop.NetworkManagerSettings.Connection"
NM_DEVICE_IFACE = "org.freedesktop.NetworkManager.Device"

NM_STATE_UNKNOWN = 0
NM_STATE_ASLEEP = 1
NM_STATE_CONNECTING = 2
NM_STATE_CONNECTED = 3
NM_STATE_DISCONNECTED = 4

DBUS_PROPS_IFACE = "org.freedesktop.DBus.Properties"

mountCount = {}

MIN_RAM = _isys.MIN_RAM
MIN_GUI_RAM = _isys.MIN_GUI_RAM
EARLY_SWAP_RAM = _isys.EARLY_SWAP_RAM

## Get the amount of free space available under a directory path.
# @param path The directory path to check.
# @return The amount of free space available, in 
def pathSpaceAvailable(path):
    return _isys.devSpaceFree(path)

## Set up an already existing device node to be used as a loopback device.
# @param device The full path to a device node to set up as a loopback device.
# @param file The file to mount as loopback on device.
# @param readOnly Should this loopback device be used read-only?
def losetup(device, file, readOnly = 0):
    # FIXME: implement this as a storage.devices.Device subclass
    if readOnly:
	mode = os.O_RDONLY
    else:
	mode = os.O_RDWR
    targ = os.open(file, mode)
    loop = os.open(device, mode)
    try:
        _isys.losetup(loop, targ, file)
    finally:
        os.close(loop)
        os.close(targ)

def lochangefd(device, file):
    # FIXME: implement this as a storage.devices.Device subclass
    loop = os.open(device, os.O_RDONLY)
    targ = os.open(file, os.O_RDONLY)
    try:
        _isys.lochangefd(loop, targ)
    finally:
        os.close(loop)
        os.close(targ)

## Disable a previously setup loopback device.
# @param device The full path to an existing loopback device node.
def unlosetup(device):
    # FIXME: implement this as a storage.devices.Device subclass
    loop = os.open(device, os.O_RDONLY)
    try:
        _isys.unlosetup(loop)
    finally:
        os.close(loop)

## Mount a filesystem, similar to the mount system call.
# @param device The device to mount.  If bindMount is True, this should be an
#               already mounted directory.  Otherwise, it should be a device
#               name.
# @param location The path to mount device on.
# @param fstype The filesystem type on device.  This can be disk filesystems
#               such as vfat or ext3, or pseudo filesystems such as proc or
#               selinuxfs.
# @param readOnly Should this filesystem be mounted readonly?
# @param bindMount Is this a bind mount?  (see the mount(8) man page)
# @param remount Are we mounting an already mounted filesystem?
# @return The return value from the mount system call.
def mount(device, location, fstype = "ext2", readOnly = False,
          bindMount = False, remount = False, options = "defaults"):
    flags = None
    location = os.path.normpath(location)
    opts = string.split(options)

    # We don't need to create device nodes for devices that start with '/'
    # (like '/usbdevfs') and also some special fake devices like 'proc'.
    # First try to make a device node and if that fails, assume we can
    # mount without making a device node.  If that still fails, the caller
    # will have to deal with the exception.
    # We note whether or not we created a node so we can clean up later.

    if mountCount.has_key(location) and mountCount[location] > 0:
	mountCount[location] = mountCount[location] + 1
	return

    if readOnly or bindMount or remount:
        if readOnly:
            opts.append("ro")
        if bindMount:
            opts.append("bind")
        if remount:
            opts.append("remount")

    flags = ",".join(opts)

    log.debug("isys.py:mount()- going to mount %s on %s as %s with options %s" %(device, location, fstype, flags))
    rc = _isys.mount(fstype, device, location, flags)

    if not rc:
	mountCount[location] = 1

    return rc

## Unmount a filesystem, similar to the umount system call.
# @param what The directory to be unmounted.  This does not need to be the
#             absolute path.
# @param removeDir Should the mount point be removed after being unmounted?
# @return The return value from the umount system call.
def umount(what, removeDir = True):
    what = os.path.normpath(what)

    if not os.path.isdir(what):
	raise ValueError, "isys.umount() can only umount by mount point"

    if mountCount.has_key(what) and mountCount[what] > 1:
	mountCount[what] = mountCount[what] - 1
	return

    log.debug("isys.py:umount()- going to unmount %s, removeDir = %s" % (what, removeDir))
    rc = _isys.umount(what)

    if removeDir and os.path.isdir(what):
        try:
            os.rmdir(what)
        except:
            pass

    if not rc and mountCount.has_key(what):
	del mountCount[what]

    return rc

## Get the SMP status of the system.
# @return True if this is an SMP system, False otherwise.
def smpAvailable():
    return _isys.smpavailable()

htavailable = _isys.htavailable

## Disable swap.
# @param path The full path of the swap device to disable.
def swapoff (path):
    return _isys.swapoff (path)

## Enable swap.
# @param path The full path of the swap device to enable.
def swapon (path):
    return _isys.swapon (path)

## Load a keyboard layout for text mode installs.
# @param keymap The keyboard layout to load.  This must be one of the values
#               from rhpl.KeyboardModels.
def loadKeymap(keymap):
    return _isys.loadKeymap (keymap)

def getDasdPorts():
    return _isys.getDasdPorts()

def isUsableDasd(device):
    return _isys.isUsableDasd(device)

def isLdlDasd(device):
    return _isys.isLdlDasd(device)

# read /proc/dasd/devices and get a mapping between devs and the dasdnum
def getDasdDevPort():
    ret = {}
    f = open("/proc/dasd/devices", "r")
    lines = f.readlines()
    f.close()

    for line in lines:
        index = line.index("(")
        dasdnum = line[:index]

        start = line[index:].find("dasd")
        end = line[index + start:].find(":")
        dev = line[index + start:end + start + index].strip()

        ret[dev] = dasdnum

    return ret

# get active/ready state of a dasd device
# returns 0 if we're fine, 1 if not
def getDasdState(dev):
    devs = getDasdDevPort()
    if not devs.has_key(dev):
        log.warning("don't have %s in /dev/dasd/devices!" %(dev,))
        return 0

    f = open("/proc/dasd/devices", "r")
    lines = f.readlines()
    f.close()

    for line in lines:
        if not line.startswith(devs[dev]):
            continue
        # 2.6 seems to return basic
        if line.find(" basic") != -1:
            return 1
        # ... and newer 2.6 returns unformatted.  consistency!
        if line.find(" unformatted") != -1:
            return 1

    return 0

def doProbeBiosDisks():
    if not iutil.isX86():
        return None
    return _isys.biosDiskProbe()

def doGetBiosDisk(mbrSig):
    return _isys.getbiosdisk(mbrSig)

handleSegv = _isys.handleSegv


def compareDrives(first, second):
    from storage.devicelibs.dm import dm_node_from_name

    biosdisks = {}
    for d in range(80, 80 + 15):
        disk = doGetBiosDisk("%d" %(d,))
        #print("biosdisk of %s is %s" %(d, disk))
        if disk is not None:
            biosdisks[disk] = d

    # convert /dev/mapper/foo -> /dev/dm-#, as that is what is in biosdisks
    if os.access("/dev/mapper/%s" % first, os.F_OK):
        first = dm_node_from_name(first)
    if os.access("/dev/mapper/%s" % second, os.F_OK):
        second = dm_node_from_name(second)

    if biosdisks.has_key(first) and biosdisks.has_key(second):
        one = biosdisks[first]
        two = biosdisks[second]
        if (one < two):
            return -1
        elif (one > two):
            return 1

    # if one is in the BIOS and the other not prefer the one in the BIOS
    if biosdisks.has_key(first):
        return -1
    if biosdisks.has_key(second):
        return 1

    if first.startswith("hd"):
        type1 = 0
    elif first.startswith("sd"):
        type1 = 1
    elif (first.startswith("vd") or first.startswith("xvd")):
        type1 = -1
    else:
        type1 = 2

    if second.startswith("hd"):
        type2 = 0
    elif second.startswith("sd"):
	type2 = 1
    elif (second.startswith("vd") or second.startswith("xvd")):
        type2 = -1
    else:
	type2 = 2

    if (type1 < type2):
	return -1
    elif (type1 > type2):
	return 1
    else:
	len1 = len(first)
	len2 = len(second)

	if (len1 < len2):
	    return -1
	elif (len1 > len2):
	    return 1
	else:
	    if (first < second):
		return -1
	    elif (first > second):
		return 1

    return 0

def resetResolv():
    return _isys.resetresolv()

def readFSUuid(device):
    if not os.path.exists(device):
        device = "/dev/%s" % device

    label = _isys.getblkid(device, "UUID")
    return label

def readFSLabel(device):
    if not os.path.exists(device):
        device = "/dev/%s" % device

    label = _isys.getblkid(device, "LABEL")
    return label

def readFSType(device):
    if not os.path.exists(device):
        device = "/dev/%s" % device

    fstype = _isys.getblkid(device, "TYPE")
    if fstype is None:
        # FIXME: libblkid doesn't show physical volumes as having a filesystem
        # so let's sniff for that.(#409321)
        try:
            fd = os.open(device, os.O_RDONLY)
            buf = os.read(fd, 2048)
        except:
            return fstype
        finally:
            try:
                os.close(fd)
            except:
                pass

        if buf.startswith("HM"):
            return "physical volume (LVM)"
        for sec in range(0, 4):
            off = (sec * 512) + 24
            if len(buf) < off:
                continue
            if buf[off:].startswith("LVM2"):
                return "physical volume (LVM)"
    elif fstype == "lvm2pv":
        return "physical volume (LVM)"
    return fstype

def ext2IsDirty(device):
    label = _isys.e2dirty(device)
    return label

def ext2HasJournal(device):
    hasjournal = _isys.e2hasjournal(device);
    return hasjournal

def driveUsesModule(device, modules):
    """Returns true if a drive is using a prticular module.  Only works
       for SCSI devices right now."""

    if not isinstance(modules, ().__class__) and not \
            isinstance(modules, [].__class__):
        modules = [modules]

    if device[:2] == "hd":
        return False
    rc = False
    if os.access("/tmp/scsidisks", os.R_OK):
        sdlist=open("/tmp/scsidisks", "r")
        sdlines = sdlist.readlines()
        sdlist.close()
        for l in sdlines:
            try:
                # each line has format of:  <device>  <module>
                (sddev, sdmod) = string.split(l)

                if sddev == device:
                    if sdmod in modules:
                        rc = True
                        break
            except:
                    pass
    return rc

def vtActivate (num):
    if iutil.isS390():
        return
    _isys.vtActivate (num)

def isPseudoTTY (fd):
    return _isys.isPseudoTTY (fd)

## Flush filesystem buffers.
def sync ():
    return _isys.sync ()

## Determine if a file is an ISO image or not.
# @param file The full path to a file to check.
# @return True if ISO image, False otherwise.
def isIsoImage(file):
    return _isys.isisoimage(file)

# Return number of network devices
def getNetworkDeviceCount():
    bus = dbus.SystemBus()
    nm = bus.get_object(NM_SERVICE, NM_MANAGER_PATH)
    devlist = nm.get_dbus_method("GetDevices")()
    return len(devlist)

# Get a D-Bus interface for the specified device's (e.g., eth0) properties.
# If dev=None, return a hash of the form 'hash[dev] = props_iface' that
# contains all device properties for all interfaces that NetworkManager knows
# about.
def getDeviceProperties(dev=None):
    bus = dbus.SystemBus()
    conn_mgr = dbus.Interface(bus.get_object(CONN_SERVICE, CONN_MANAGER_PATH), CONN_MANAGER_IFACE)
    conn_mgr_props = conn_mgr.GetProperties()

    all = {}

    for path in conn_mgr_props["Devices"]:
        device = dbus.Interface(bus.get_object(CONN_SERVICE, path), CONN_DEVICE_IFACE)
        device_props = device.GetProperties()
        device_full_name = device_props["Name"]

        device_split_names = string.splitfields(device_full_name, ' ')
        if len(device_split_names) == 2:
            device_name = device_split_names[1].replace('(', '').replace(')', '')
        else:
            continue

        if dev is None:
            all[device_name] = device
        elif device_name == dev:
            return device

    if dev is None:
        return all
    else:
        return None

# Return true if method is currently 'dhcp' for the specified device.
def isDeviceDHCP(dev=None):
    if dev is None:
        return False

    # Moblin Fixme: Need to fix connman
    # The current connman only supports 'dhcp', no 'static' supported
    # Need to replace the following code when connman gets ready
    return True

    bus = dbus.SystemBus()
    nm = bus.get_object(NM_SERVICE, NM_MANAGER_PATH)
    nm_props_iface = dbus.Interface(nm, DBUS_PROPS_IFACE)
    active_connections = nm_props_iface.Get(NM_MANAGER_IFACE, "ActiveConnections")

    for path in active_connections:
        active = bus.get_object(NM_SERVICE, path)
        active_props_iface = dbus.Interface(active, DBUS_PROPS_IFACE)

        active_service_name = active_props_iface.Get(NM_ACTIVE_CONNECTION_IFACE, "ServiceName")
        active_path = active_props_iface.Get(NM_ACTIVE_CONNECTION_IFACE, "Connection")
        active_devices = active_props_iface.Get(NM_ACTIVE_CONNECTION_IFACE, "Devices")

        device = bus.get_object(NM_SERVICE, active_devices[0])
        device_props_iface = dbus.Interface(device, DBUS_PROPS_IFACE)
        iface = device_props_iface.Get(NM_DEVICE_IFACE, "Interface")

        if iface != dev:
            continue

        connection = bus.get_object(active_service_name, active_path)
        connection_iface = dbus.Interface(connection, NM_CONNECTION_IFACE)
        settings = connection_iface.GetSettings()

        ip4_setting = settings.get('ipv4')
        if not ip4_setting or not ip4_setting['method'] or ip4_setting['method'] == 'auto':
            return True

    return False

# Get the MAC address for a network device.
def getMacAddress(dev):
    if dev == '' or dev is None:
        return False

    device_props_iface = getDeviceProperties(dev=dev)
    if device_props_iface is None:
        return None

    device_macaddr = None
    try:
        device_macaddr = device_props_iface.Get(NM_MANAGER_IFACE, "HwAddress").upper()
    except dbus.exceptions.DBusException as e:
        if e.get_dbus_name() != 'org.freedesktop.DBus.Error.InvalidArgs':
            raise
    return device_macaddr

# Get a description string for a network device (e.g., eth0)
def getNetDevDesc(dev):
    from baseudev import udev_get_device
    desc = "Network Interface"

    if dev == '' or dev is None:
        return desc

    bus = dbus.SystemBus()
    nm = bus.get_object(NM_SERVICE, NM_MANAGER_PATH)
    devlist = nm.get_dbus_method("GetDevices")()

    for path in devlist:
        device = bus.get_object(NM_SERVICE, path)
        device_iface = dbus.Interface(device, DBUS_PROPS_IFACE)
        device_props = device_iface.get_dbus_method("GetAll")(NM_DEVICE_IFACE)

        if dev == device_props['Interface']:
            # This is the sysfs path (for now).
            udev_path = device_props['Udi']
            dev = udev_get_device(udev_path[4:])

            if dev is None:
                log.debug("weird, we have a None dev with path %s" % path)
            elif dev.has_key("ID_VENDOR_ENC") and dev.has_key("ID_MODEL_ENC"):
                desc = "%s %s" % (dev["ID_VENDOR_ENC"], dev["ID_MODEL_ENC"])
            elif dev.has_key("ID_VENDOR_FROM_DATABASE") and dev.has_key("ID_MODEL_FROM_DATABASE"):
                desc = "%s %s" % (dev["ID_VENDOR_FROM_DATABASE"], dev["ID_MODEL_FROM_DATABASE"])

            return desc

    return desc

# Determine if a network device is a wireless device.
def isWireless(dev):
    if dev == '' or dev is None:
        return False

    device_props_iface = getDeviceProperties(dev=dev)
    if device_props_iface is None:
        return None

    device_type = int(device_props_iface.Get(NM_MANAGER_IFACE, "DeviceType"))

    # from include/NetworkManager.h in the NM source code
    #    0 == NM_DEVICE_TYPE_UNKNOWN
    #    1 == NM_DEVICE_TYPE_ETHERNET
    #    2 == NM_DEVICE_TYPE_WIFI
    #    3 == NM_DEVICE_TYPE_GSM
    #    4 == NM_DEVICE_TYPE_CDMA
    if device_type == 2:
        return True
    else:
        return False

# Get the IP address for a network device.
def getIPAddress(dev):
    if dev == '' or dev is None:
       return None

    device_props_iface = getDeviceProperties(dev=dev)
    if device_props_iface is None:
        return None

    # XXX: add support for IPv6 addresses when NM can do that
    device_ip4addr = device_props_iface.Get(NM_MANAGER_IFACE, "Ip4Address")

    try:
        tmp = struct.pack('I', device_ip4addr)
        address = socket.inet_ntop(socket.AF_INET, tmp)
    except ValueError, e:
        return None

    return address

## Get the correct context for a file from loaded policy.
# @param fn The filename to query.
def matchPathContext(fn):
    return _isys.matchPathContext(fn)

## Set the SELinux file context of a file
# @param fn The filename to fix.
# @param con The context to use.
# @param instroot An optional root filesystem to look under for fn.
def setFileContext(fn, con, instroot = '/'):
    if con is not None and os.access("%s/%s" % (instroot, fn), os.F_OK):
        return (_isys.setFileContext(fn, con, instroot) != 0)
    return False

## Restore the SELinux file context of a file to its default.
# @param fn The filename to fix.
# @param instroot An optional root filesystem to look under for fn.
def resetFileContext(fn, instroot = '/'):
    con = matchPathContext(fn)
    if con:
        if setFileContext(fn, con, instroot):
            return con
    return None

def prefix2netmask(prefix):
    return _isys.prefix2netmask(prefix)

def netmask2prefix (netmask):
    prefix = 0

    while prefix < 33:
        if (prefix2netmask(prefix) == netmask):
            return prefix

        prefix += 1

    return prefix

isPAE = None
def isPaeAvailable():
    global isPAE
    if isPAE is not None:
        return isPAE

    isPAE = False
    if not iutil.isX86():
        return isPAE

    f = open("/proc/cpuinfo", "r")
    lines = f.readlines()
    f.close()

    for line in lines:
        if line.startswith("flags") and line.find("pae") != -1:
            isPAE = True
            break

    return isPAE

def getLinkStatus(dev):
    return _isys.getLinkStatus(dev)

def getAnacondaVersion():
    return _isys.getAnacondaVersion()

#auditDaemon = _isys.auditdaemon

handleSegv = _isys.handleSegv

printObject = _isys.printObject
bind_textdomain_codeset = _isys.bind_textdomain_codeset
isVioConsole = _isys.isVioConsole
