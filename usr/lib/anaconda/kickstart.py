#
# kickstart.py: kickstart install support
#
# Copyright (C) 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007
# Red Hat, Inc.  All rights reserved.
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

from storage.deviceaction import *
from storage.devices import LUKSDevice
from storage.devicelibs.lvm import getPossiblePhysicalExtents
from storage.formats import getFormat
from storage.partitioning import clearPartitions

from errors import *
import iutil
import isys
import os
import tempfile
from flags import flags
from constants import *
import sys
import string
import urlgrabber
import warnings
import network
import upgrade
import pykickstart.commands as commands
from storage.devices import *
#from scdate.core import zonetab
#import zonetab
from pykickstart.base import KickstartCommand, BaseData
from pykickstart.constants import *
from pykickstart.errors import *
from pykickstart.parser import *
from pykickstart.version import *

import gettext
_ = lambda x: gettext.ldgettext("anaconda", x)

import logging
log = logging.getLogger("anaconda")
from anaconda_log import logger, logLevelMap

class AnacondaKSScript(Script):
    def run(self, chroot, serial, intf = None):
        import tempfile
        import os.path

        if self.inChroot:
            scriptRoot = chroot
        else:
            scriptRoot = "/"

        (fd, path) = tempfile.mkstemp("", "ks-script-", scriptRoot + "/tmp")

        os.write(fd, self.script)
        os.close(fd)
        os.chmod(path, 0700)

        # Always log stdout/stderr from scripts.  Using --logfile just lets you
        # pick where it goes.  The script will also be logged to program.log
        # because of execWithRedirect, and to anaconda.log if the script fails.
        if self.logfile:
            if self.inChroot:
                messages = "%s/%s" % (scriptRoot, self.logfile)
            else:
                messages = self.logfile

            d = os.path.basename(messages)
            if not os.exists(d):
                os.makedirs(d)
        else:
            messages = "%s.log" % path

        if intf:
            intf.suspend()
        rc = iutil.execWithRedirect(self.interp, ["/tmp/%s" % os.path.basename(path)],
                                    stdin = messages, stdout = messages, stderr = messages,
                                    root = scriptRoot)
        if intf:
            intf.resume()

        # Always log an error.  Only fail if we have a handle on the
        # windowing system and the kickstart file included --erroronfail.
        if rc != 0:
            log.error("Error code %s running the kickstart script at line %s" % (rc, self.lineno))

            try:
                f = open(messages, "r")
                err = f.readlines()
                f.close()
                for l in err:
                    log.error("\t%s" % l)
            except:
                err = None

            if self.errorOnFail:
                if intf != None:
                    msg = _("There was an error running the kickstart "
                            "script at line %(lineno)s. You may examine the "
                            "output in %(msgs)s. This is a fatal error and "
                            "installation will be aborted. Press the "
                            "OK button to exit the installer.") \
                          % {'lineno': self.lineno, 'msgs': messages}

                    if err:
                        intf.detailedMessageWindow(_("Scriptlet Failure"), msg, err)
                    else:
                        intf.messageWindow(_("Scriptlet Failure"), msg)

                sys.exit(0)

        if serial or self.logfile is not None:
            os.chmod("%s" % messages, 0600)

class AnacondaKSPackages(Packages):
    def __init__(self):
        Packages.__init__(self)

        # Has the %packages section been seen at all?
        self.seen = False


def getEscrowCertificate(anaconda, url):
    if not url:
        return None

    if url in anaconda.id.escrowCertificates:
        return anaconda.id.escrowCertificates[url]

    needs_net = not url.startswith("/") and not url.startswith("file:")
    if needs_net and not network.hasActiveNetDev():
        if not anaconda.intf.enableNetwork(anaconda):
            anaconda.intf.messageWindow(_("No Network Available"),
                                        _("Encryption key escrow requires "
                                          "networking, but there was an error "
                                          "enabling the network on your "
                                          "system."), type="custom",
                                        custom_icon="error",
                                        custom_buttons=[_("_Exit installer")])
            sys.exit(1)

    log.info("escrow: downloading %s" % (url,))
    f = urlgrabber.urlopen(url)
    try:
        anaconda.id.escrowCertificates[url] = f.read()
    finally:
        f.close()
    return anaconda.id.escrowCertificates[url]

def deviceMatches(spec):
    matches = udev_resolve_glob(spec)
    dev = udev_resolve_devspec(spec)

    # udev_resolve_devspec returns None if there's no match, but we don't
    # want that ending up in the list.
    if dev and dev not in matches:
        matches.append(dev)

    return matches

###
### SUBCLASSES OF PYKICKSTART COMMAND HANDLERS
###

class Authconfig(commands.authconfig.FC3_Authconfig):
    def execute(self, anaconda):
        anaconda.id.auth = self.authconfig

class AutoPart(commands.autopart.F12_AutoPart):
    def execute(self, anaconda):
        # sets up default autopartitioning.  use clearpart separately
        # if you want it
        anaconda.id.instClass.setDefaultPartitioning(anaconda.id.storage, anaconda.platform)
        anaconda.id.storage.doAutoPart = True

        if self.encrypted:
            anaconda.id.storage.encryptedAutoPart = True
            anaconda.id.storage.encryptionPassphrase = self.passphrase
            anaconda.id.storage.autoPartEscrowCert = \
                getEscrowCertificate(anaconda, self.escrowcert)
            anaconda.id.storage.autoPartAddBackupPassphrase = \
                self.backuppassphrase

        self.handler.skipSteps.extend(["partition", "zfcpconfig", "parttype"])

class AutoStep(commands.autostep.FC3_AutoStep):
    def execute(self, anaconda):
        flags.autostep = 1
        flags.autoscreenshot = self.autoscreenshot

class Bootloader(commands.bootloader.F12_Bootloader):
    def execute(self, anaconda):
        if self.location == "none":
            location = None
        elif self.location == "partition":
            location = "boot"
        else:
            location = self.location

        if self.upgrade and not anaconda.id.getUpgrade():
            raise KickstartValueError, formatErrorMsg(self.lineno, msg="Selected upgrade mode for bootloader but not doing an upgrade")

        if self.upgrade:
            anaconda.id.bootloader.kickstart = 1
            anaconda.id.bootloader.doUpgradeOnly = 1

        if location is None:
            self.handler.permanentSkipSteps.extend(["bootloadersetup", "instbootloader"])
        else:
            self.handler.showSteps.append("bootloader")

            if self.appendLine:
                anaconda.id.bootloader.args.append(self.appendLine)

            if self.password:
                anaconda.id.bootloader.setPassword(self.password, isCrypted = 0)

            if self.md5pass:
                anaconda.id.bootloader.setPassword(self.md5pass)

            if location != None:
                anaconda.id.bootloader.defaultDevice = location
            else:
                anaconda.id.bootloader.defaultDevice = -1

            if self.timeout:
                anaconda.id.bootloader.timeout = self.timeout

            # Throw out drives specified that don't exist.
            if self.driveorder and len(self.driveorder) > 0:
                new = []
                for drive in self.driveorder:
                    if drive in anaconda.id.bootloader.drivelist:
                        new.append(drive)
                    else:
                        log.warning("requested drive %s in boot drive order "
                                    "doesn't exist" %(drive,))

                anaconda.id.bootloader.updateDriveList(new)

        self.handler.permanentSkipSteps.extend(["upgbootloader", "bootloader"])

class ClearPart(commands.clearpart.FC3_ClearPart):
    def parse(self, args):
        retval = commands.clearpart.FC3_ClearPart.parse(self, args)

        if self.type is None:
            self.type = CLEARPART_TYPE_NONE

        # Do any glob expansion now, since we need to have the real list of
        # disks available before the execute methods run.
        drives = []
        for spec in self.drives:
            matched = deviceMatches(spec)
            if matched:
                drives.extend(matched)
            else:
                raise KickstartValueError, formatErrorMsg(self.lineno, msg="Specified nonexistent disk %s in clearpart command" % spec)

        self.drives = drives

        return retval

    def execute(self, anaconda):
        anaconda.id.storage.clearPartType = self.type
        anaconda.id.storage.clearPartDisks = self.drives
        if self.initAll:
            anaconda.id.storage.reinitializeDisks = self.initAll

        clearPartitions(anaconda.id.storage)

class FcoeData(commands.fcoe.F13_FcoeData):
    def execute(self, anaconda):
        if self.nic not in self.anaconda.id.network.available():
            raise KickstartValueError, formatErrorMsg(self.lineno, msg="Specified nonexistent nic %s in fcoe command" % self.nic)
        anaconda.id.fcoe.addSan(nic=self.nic, dcb=self.dcb)

class Firewall(commands.firewall.F10_Firewall):
    def execute(self, anaconda):
        anaconda.id.firewall.enabled = self.enabled
        anaconda.id.firewall.trustdevs = self.trusts

        for port in self.ports:
            anaconda.id.firewall.portlist.append (port)

        for svc in self.services:
            anaconda.id.firewall.servicelist.append (svc)

class Firstboot(commands.firstboot.FC3_Firstboot):
    def execute(self, anaconda):
        anaconda.id.firstboot = self.firstboot

class IgnoreDisk(commands.ignoredisk.F8_IgnoreDisk):
    def parse(self, args):
        retval = commands.clearpart.F8_IgnoreDisk.parse(self, args)

        # See comment in ClearPart.parse
        drives = []
        for spec in self.ignoredisk:
            matched = deviceMatches(spec)
            if matched:
                drives.extend(matched)
            else:
                raise KickstartValueError, formatErrorMsg(self.lineno, msg="Specified nonexistent disk %s in ignoredisk command" % spec)

        self.ignoredisk = drives

        drives = []
        for spec in self.onlyuse:
            matched = deviceMatches(spec)
            if matched:
                drives.extend(matched)
            else:
                raise KickstartValueError, formatErrorMsg(self.lineno, msg="Specified nonexistent disk %s in ignoredisk command" % spec)

        self.onlyuse = drives

        return retval

    def execute(self, anaconda):
        anaconda.id.storage.ignoredDisks = self.ignoredisk
        anaconda.id.storage.exclusiveDisks = self.onlyuse

class IscsiData(commands.iscsi.F10_IscsiData):
    def execute(self, anaconda):
        kwargs = {
            'ipaddr': self.ipaddr,
            'port': self.port,
            }

        if self.user and self.password:
            kwargs.update({
                'user': self.user,
                'pw': self.password
                })

        if self.user_in and self.password_in:
            kwargs.update({
                'user_in': self.user_in,
                'pw_in': self.password_in
                })

        if anaconda.id.iscsi.addTarget(**kwargs):
            log.info("added iscsi target: %s" %(self.ipaddr,))

class IscsiName(commands.iscsiname.FC6_IscsiName):
    def execute(self, anaconda):
        anaconda.id.iscsi.initiator = self.iscsiname

class Keyboard(commands.keyboard.FC3_Keyboard):
    def execute(self, anaconda):
        anaconda.id.keyboard.set(self.keyboard)
        anaconda.id.keyboard.beenset = 1
        self.handler.skipSteps.append("keyboard")

class Lang(commands.lang.FC3_Lang):
    def execute(self, anaconda):
        anaconda.id.instLanguage.instLang = self.lang
        anaconda.id.instLanguage.systemLang = self.lang
        self.handler.skipSteps.append("language")

class LogVolData(commands.logvol.F12_LogVolData):
    def execute(self, anaconda):
        storage = anaconda.id.storage
        devicetree = storage.devicetree

        storage.doAutoPart = False

        if self.mountpoint == "swap":
            type = "swap"
            self.mountpoint = ""
            if self.recommended:
                (self.size, self.maxSizeMB) = iutil.swapSuggestion()
                self.grow = True
        else:
            if self.fstype != "":
                type = self.fstype
            else:
                type = storage.defaultFSType

        # Sanity check mountpoint
        if self.mountpoint != "" and self.mountpoint[0] != '/':
            raise KickstartValueError, formatErrorMsg(self.lineno, msg="The mount point \"%s\" is not valid." % (self.mountpoint,))

        # Check that the VG this LV is a member of has already been specified.
        vg = devicetree.getDeviceByName(self.vgname)
        if not vg:
            raise KickstartValueError, formatErrorMsg(self.lineno, msg="No volume group exists with the name \"%s\".  Specify volume groups before logical volumes." % self.vgname)

        # If this specifies an existing request that we should not format,
        # quit here after setting up enough information to mount it later.
        if not self.format:
            if not self.name:
                raise KickstartValueError, formatErrorMsg(self.lineno, msg="--noformat used without --name")

            dev = devicetree.getDeviceByName("%s-%s" % (vg.name, self.name))
            if not dev:
                raise KickstartValueError, formatErrorMsg(self.lineno, msg="No preexisting logical volume with the name \"%s\" was found." % self.name)

            dev.format.mountpoint = self.mountpoint
            dev.format.mountopts = self.fsopts
            self.handler.skipSteps.extend(["partition", "zfcpconfig", "parttype"])
            return

        # Make sure this LV name is not already used in the requested VG.
        if not self.preexist:
            tmp = devicetree.getDeviceByName("%s-%s" % (vg.name, self.name))
            if tmp:
                raise KickstartValueError, formatErrorMsg(self.lineno, msg="Logical volume name already used in volume group %s" % vg.name)

            # Size specification checks
            if not self.percent:
                if not self.size:
                    raise KickstartValueError, formatErrorMsg(self.lineno, msg="Size required")
                elif not self.grow and self.size*1024 < vg.peSize:
                    raise KickstartValueError, formatErrorMsg(self.lineno, msg="Logical volume size must be larger than the volume group physical extent size.")
            elif self.percent <= 0 or self.percent > 100:
                raise KickstartValueError, formatErrorMsg(self.lineno, msg="Percentage must be between 0 and 100")

        # Now get a format to hold a lot of these extra values.
        format = getFormat(type,
                           mountpoint=self.mountpoint,
                           mountopts=self.fsopts)
        if not format:
            raise KickstartValueError, formatErrorMsg(self.lineno, msg="The \"%s\" filesystem type is not supported." % type)

        # If we were given a pre-existing LV to create a filesystem on, we need
        # to verify it and its VG exists and then schedule a new format action
        # to take place there.  Also, we only support a subset of all the
        # options on pre-existing LVs.
        if self.preexist:
            device = devicetree.getDeviceByName("%s-%s" % (vg.name, self.name))
            if not device:
                raise KickstartValueError, formatErrorMsg(self.lineno, msg="Specified nonexistent LV %s in logvol command" % self.name)

            devicetree.registerAction(ActionCreateFormat(device, format))
        else:
            # If a previous device has claimed this mount point, delete the
            # old one.
            try:
                if self.mountpoint:
                    device = storage.mountpoints[self.mountpoint]
                    storage.destroyDevice(device)
            except KeyError:
                pass

            request = storage.newLV(format=format,
                                    name=self.name,
                                    vg=vg,
                                    size=self.size,
                                    grow=self.grow,
                                    maxsize=self.maxSizeMB,
                                    percent=self.percent)

            # FIXME: no way to specify an fsprofile right now
            # if lvd.fsprofile:
            #     request.format.fsprofile = lvd.fsprofile

            storage.createDevice(request)

        if self.encrypted:
            if self.passphrase and not storage.encryptionPassphrase:
                storage.encryptionPassphrase = self.passphrase

            cert = getEscrowCertificate(anaconda, self.escrowcert)
            if self.preexist:
                luksformat = format
                device.format = getFormat("luks", passphrase=self.passphrase, device=device.path,
                                          escrow_cert=cert,
                                          add_backup_passphrase=self.backuppassphrase)
                luksdev = LUKSDevice("luks%d" % storage.nextID,
                                     format=luksformat,
                                     parents=device)
            else:
                luksformat = request.format
                request.format = getFormat("luks", passphrase=self.passphrase,
                                           escrow_cert=cert,
                                           add_backup_passphrase=self.backuppassphrase)
                luksdev = LUKSDevice("luks%d" % storage.nextID,
                                     format=luksformat,
                                     parents=request)
            storage.createDevice(luksdev)

        self.handler.skipSteps.extend(["partition", "zfcpconfig", "parttype"])

class Logging(commands.logging.FC6_Logging):
    def execute(self, anaconda):
        log.setHandlersLevel(logLevelMap[self.level])

        if self.host != "" and self.port != "":
            logger.addSysLogHandler(log, self.host, port=int(self.port))
        elif self.host != "":
            logger.addSysLogHandler(log, self.host)

class NetworkData(commands.network.F8_NetworkData):
    def execute(self, anaconda):
        if self.bootProto:
            devices = anaconda.id.network.netdevices
            if (devices and self.bootProto):
                if not self.device:
                    list = devices.keys ()
                    list.sort()
                    device = list[0]
                else:
                    device = self.device

                try:
                    dev = devices[device]
                except KeyError:
                    raise KickstartValueError, formatErrorMsg(self.lineno, msg="The provided network interface %s does not exist" % device)

                dev.set (("bootproto", self.bootProto))
                dev.set (("dhcpclass", self.dhcpclass))

                if self.onboot:
                    dev.set (("onboot", "yes"))
                else:
                    dev.set (("onboot", "no"))

                if self.bootProto == "static":
                    if (self.ip):
                        dev.set (("ipaddr", self.ip))
                    if (self.netmask):
                        dev.set (("netmask", self.netmask))

                if self.ethtool:
                    dev.set (("ethtool_opts", self.ethtool))

                if isys.isWireless(device):
                    if self.essid:
                        dev.set(("essid", self.essid))
                    if self.wepkey:
                        dev.set(("wepkey", self.wepkey))

        if self.hostname != "":
            anaconda.id.network.setHostname(self.hostname)
            anaconda.id.network.overrideDHCPhostname = True

        if self.nameserver != "":
            anaconda.id.network.setDNS(self.nameserver, device)

        if self.gateway != "":
            anaconda.id.network.setGateway(self.gateway, device)

        needs_net = (anaconda.methodstr and
                     (anaconda.methodstr.startswith("http:") or
                      anaconda.methodstr.startswith("ftp:") or
                      anaconda.methodstr.startswith("nfs:")))
        if needs_net and not network.hasActiveNetDev():
            log.info("Bringing up network in stage2 kickstart ...")
            rc = anaconda.id.network.bringUp()
            log.info("Network setup %s" % (rc and 'succeeded' or 'failed',))

class MultiPath(commands.multipath.FC6_MultiPath):
    def parse(self, args):
        raise NotImplementedError("The multipath kickstart command is not currently supported")

class DmRaid(commands.dmraid.FC6_DmRaid):
    def parse(self, args):
        raise NotImplementedError("The dmraid kickstart command is not currently supported")

class PartitionData(commands.partition.F12_PartData):
    def execute(self, anaconda):
        storage = anaconda.id.storage
        devicetree = storage.devicetree
        kwargs = {}

        storage.doAutoPart = False

        if self.onbiosdisk != "":
            self.disk = isys.doGetBiosDisk(self.onbiosdisk)

            if self.disk == "":
                raise KickstartValueError, formatErrorMsg(self.lineno, msg="Specified BIOS disk %s cannot be determined" % self.onbiosdisk)

        if self.mountpoint == "swap":
            type = "swap"
            self.mountpoint = ""
            if self.recommended:
                (self.size, self.maxSizeMB) = iutil.swapSuggestion()
                self.grow = True
        # if people want to specify no mountpoint for some reason, let them
        # this is really needed for pSeries boot partitions :(
        elif self.mountpoint == "None":
            self.mountpoint = ""
            if self.fstype:
                type = self.fstype
            else:
                type = storage.defaultFSType
        elif self.mountpoint == 'appleboot':
            type = "Apple Bootstrap"
            self.mountpoint = ""
            kwargs["weight"] = anaconda.platform.weight(fstype="appleboot")
        elif self.mountpoint == 'prepboot':
            type = "PPC PReP Boot"
            self.mountpoint = ""
            kwargs["weight"] = anaconda.platform.weight(fstype="prepboot")
        elif self.mountpoint.startswith("raid."):
            type = "mdmember"
            kwargs["name"] = self.mountpoint

            if devicetree.getDeviceByName(kwargs["name"]):
                raise KickstartValueError, formatErrorMsg(self.lineno, msg="RAID partition defined multiple times")

            # store "raid." alias for other ks partitioning commands
            if self.onPart:
                self.handler.onPart[kwargs["name"]] = self.onPart
            self.mountpoint = ""
        elif self.mountpoint.startswith("pv."):
            type = "lvmpv"
            kwargs["name"] = self.mountpoint

            if devicetree.getDeviceByName(kwargs["name"]):
                raise KickstartValueError, formatErrorMsg(self.lineno, msg="PV partition defined multiple times")

            # store "pv." alias for other ks partitioning commands
            if self.onPart:
                self.handler.onPart[kwargs["name"]] = self.onPart
            self.mountpoint = ""
        elif self.mountpoint == "/boot/efi":
            type = "EFI System Partition"
            self.fsopts = "defaults,uid=0,gid=0,umask=0077,shortname=winnt"
            kwargs["weight"] = anaconda.platform.weight(fstype="efi")
        else:
            if self.fstype != "":
                type = self.fstype
            elif self.mountpoint == "/boot":
                type = anaconda.platform.defaultBootFSType
            else:
                type = storage.defaultFSType

        # If this specified an existing request that we should not format,
        # quit here after setting up enough information to mount it later.
        if not self.format:
            if not self.onPart:
                raise KickstartValueError, formatErrorMsg(self.lineno, msg="--noformat used without --onpart")

            dev = devicetree.getDeviceByName(udev_resolve_devspec(self.onPart))
            if not dev:
                raise KickstartValueError, formatErrorMsg(self.lineno, msg="No preexisting partition with the name \"%s\" was found." % self.onPart)

            dev.format.mountpoint = self.mountpoint
            dev.format.mountopts = self.fsopts
            self.handler.skipSteps.extend(["partition", "zfcpconfig", "parttype"])
            return

        # Size specification checks.
        if not self.size and not self.onPart:
            raise KickstartValueError, formatErrorMsg(self.lineno, msg="Partition requires a size specification")

        # Now get a format to hold a lot of these extra values.
        kwargs["format"] = getFormat(type,
                                     mountpoint=self.mountpoint,
                                     label=self.label,
                                     mountopts=self.fsopts)
        if not kwargs["format"]:
            raise KickstartValueError, formatErrorMsg(self.lineno, msg="The \"%s\" filesystem type is not supported." % type)

        # If we were given a specific disk to create the partition on, verify
        # that it exists first.  If it doesn't exist, see if it exists with
        # mapper/ on the front.  If that doesn't exist either, it's an error.
        if self.disk:
            names = [self.disk, "mapper/" + self.disk]
            for n in names:
                disk = devicetree.getDeviceByName(udev_resolve_devspec(n))
                if disk:
                    kwargs["disks"] = [disk]
                    break

            if not kwargs["disks"]:
                raise KickstartValueError, formatErrorMsg(self.lineno, msg="Specified nonexistent disk %s in partition command" % self.disk)

        kwargs["grow"] = self.grow
        kwargs["size"] = self.size
        kwargs["maxsize"] = self.maxSizeMB
        kwargs["primary"] = self.primOnly

        # If we were given a pre-existing partition to create a filesystem on,
        # we need to verify it exists and then schedule a new format action to
        # take place there.  Also, we only support a subset of all the options
        # on pre-existing partitions.
        if self.onPart:
            device = devicetree.getDeviceByName(udev_resolve_devspec(self.onPart))
            if not device:
                raise KickstartValueError, formatErrorMsg(self.lineno, msg="Specified nonexistent partition %s in partition command" % self.onPart)

            devicetree.registerAction(ActionCreateFormat(device, kwargs["format"]))
        else:
            # If a previous device has claimed this mount point, delete the
            # old one.
            try:
                if self.mountpoint:
                    device = storage.mountpoints[self.mountpoint]
                    storage.destroyDevice(device)
            except KeyError:
                pass

            request = storage.newPartition(**kwargs)

            # FIXME: no way to specify an fsprofile right now
            # if self.fsprofile:
            #     request.format.fsprofile = self.fsprofile

            storage.createDevice(request)

        if self.encrypted:
            if self.passphrase and not storage.encryptionPassphrase:
               storage.encryptionPassphrase = self.passphrase

            cert = getEscrowCertificate(anaconda, self.escrowcert)
            if self.onPart:
                luksformat = format
                device.format = getFormat("luks", passphrase=self.passphrase, device=device.path,
                                          escrow_cert=cert,
                                          add_backup_passphrase=self.backuppassphrase)
                luksdev = LUKSDevice("luks%d" % storage.nextID,
                                     format=luksformat,
                                     parents=device)
            else:
                luksformat = request.format
                request.format = getFormat("luks", passphrase=self.passphrase,
                                           escrow_cert=cert,
                                           add_backup_passphrase=self.backuppassphrase)
                luksdev = LUKSDevice("luks%d" % storage.nextID,
                                     format=luksformat,
                                     parents=request)
            storage.createDevice(luksdev)

        self.handler.skipSteps.extend(["partition", "zfcpconfig", "parttype"])

class Reboot(commands.reboot.FC6_Reboot):
    def execute(self, anaconda):
        self.handler.skipSteps.append("complete")

class RaidData(commands.raid.F12_RaidData):
    def execute(self, anaconda):
        raidmems = []
        devicename = "md%d" % self.device

        storage = anaconda.id.storage
        devicetree = storage.devicetree
        kwargs = {}

        storage.doAutoPart = False

        if self.mountpoint == "swap":
            type = "swap"
            self.mountpoint = ""
        elif self.mountpoint.startswith("pv."):
            type = "lvmpv"
            kwargs["name"] = self.mountpoint
            self.handler.onPart[kwargs["name"]] = devicename

            if devicetree.getDeviceByName(kwargs["name"]):
                raise KickstartValueError, formatErrorMsg(self.lineno, msg="PV partition defined multiple times")

            self.mountpoint = ""
        else:
            if self.fstype != "":
                type = self.fstype
            elif self.mountpoint == "/boot" and anaconda.platform.supportsMdRaidBoot:
                type = anaconda.platform.defaultBootFSType
            else:
                type = storage.defaultFSType

        # Sanity check mountpoint
        if self.mountpoint != "" and self.mountpoint[0] != '/':
            raise KickstartValueError, formatErrorMsg(self.lineno, msg="The mount point is not valid.")

        # If this specifies an existing request that we should not format,
        # quit here after setting up enough information to mount it later.
        if not self.format:
            if not devicename:
                raise KickstartValueError, formatErrorMsg(self.lineno, msg="--noformat used without --device")

            dev = devicetree.getDeviceByName(devicename)
            if not dev:
                raise KickstartValueError, formatErrorMsg(self.lineno, msg="No preexisting RAID device with the name \"%s\" was found." % devicename)

            dev.format.mountpoint = self.mountpoint
            dev.format.mountopts = self.fsopts
            self.handler.skipSteps.extend(["partition", "zfcpconfig", "parttype"])
            return

        # Get a list of all the RAID members.
        for member in self.members:
            # if member is using --onpart, use original device
            member = self.handler.onPart.get(member, member)
            dev = devicetree.getDeviceByName(member)
            if not dev:
                raise KickstartValueError, formatErrorMsg(self.lineno, msg="Tried to use undefined partition %s in RAID specification" % member)

            raidmems.append(dev)

        if not self.preexist:
            if len(raidmems) == 0:
                raise KickstartValueError, formatErrorMsg(self.lineno, msg="RAID Partition defined without any RAID members")

            if self.level == "":
                raise KickstartValueError, formatErrorMsg(self.lineno, msg="RAID Partition defined without RAID level")

        # Now get a format to hold a lot of these extra values.
        kwargs["format"] = getFormat(type,
                                     mountpoint=self.mountpoint,
                                     mountopts=self.fsopts)
        if not kwargs["format"]:
            raise KickstartValueError, formatErrorMsg(self.lineno, msg="The \"%s\" filesystem type is not supported." % type)

        kwargs["name"] = devicename
        kwargs["level"] = self.level
        kwargs["parents"] = raidmems
        kwargs["memberDevices"] = len(raidmems)
        kwargs["totalDevices"] = kwargs["memberDevices"]+self.spares

        # If we were given a pre-existing RAID to create a filesystem on,
        # we need to verify it exists and then schedule a new format action
        # to take place there.  Also, we only support a subset of all the
        # options on pre-existing RAIDs.
        if self.preexist:
            device = devicetree.getDeviceByName(devicename)
            if not device:
                raise KickstartValueError, formatErrorMsg(self.lineno, msg="Specifeid nonexistent RAID %s in raid command" % devicename)

            devicetree.registerAction(ActionCreateFormat(device, kwargs["format"]))
        else:
            # If a previous device has claimed this mount point, delete the
            # old one.
            try:
                if self.mountpoint:
                    device = storage.mountpoints[self.mountpoint]
                    storage.destroyDevice(device)
            except KeyError:
                pass

            try:
                request = storage.newMDArray(**kwargs)
            except ValueError, e:
                raise KickstartValueError, formatErrorMsg(self.lineno, msg=str(e))

            # FIXME: no way to specify an fsprofile right now
            # if pd.fsprofile:
            #     request.format.fsprofile = pd.fsprofile

            storage.createDevice(request)

        if self.encrypted:
            if self.passphrase and not storage.encryptionPassphrase:
               storage.encryptionPassphrase = self.passphrase

            cert = getEscrowCertificate(anaconda, self.escrowcert)
            if self.preexist:
                luksformat = format
                device.format = getFormat("luks", passphrase=self.passphrase, device=device.path,
                                          escrow_cert=cert,
                                          add_backup_passphrase=self.backuppassphrase)
                luksdev = LUKSDevice("luks%d" % storage.nextID,
                                     format=luksformat,
                                     parents=device)
            else:
                luksformat = request.format
                request.format = getFormat("luks", passphrase=self.passphrase,
                                           escrow_cert=cert,
                                           add_backup_passphrase=self.backuppassphrase)
                luksdev = LUKSDevice("luks%d" % storage.nextID,
                                     format=luksformat,
                                     parents=request)
            storage.createDevice(luksdev)

        self.handler.skipSteps.extend(["partition", "zfcpconfig", "parttype"])

class RootPw(commands.rootpw.F8_RootPw):
    def execute(self, anaconda):
        anaconda.id.rootPassword["password"] = self.password
        anaconda.id.rootPassword["isCrypted"] = self.isCrypted
        anaconda.id.rootPassword["lock"] = self.lock
        self.handler.skipSteps.append("accounts")

class AddUser(commands.user.F8_User):
    def parse(self, args):
        ud=commands.user.F8_User.parse(self, args)
        if ud:  
            self.name = ud.name
            self.password = ud.password
            self.lock = ud.lock
            log.info("Parse user name=%s password=%s lock=%d" %(ud.name,ud.password,ud.lock))
            log.info("Set enablefirstboot = False since the user info is provided")
            flags.enablefirstboot = False
        else:
            log.warning("User set in kickstart is not valid")
        return self

    def execute(self, anaconda):
        # Check user name and password
        # Follow the rule of adduser_gui, only one user is valid to create
        anaconda.id.userAccount["username"] = self.name
        anaconda.id.userAccount["fullname"] = self.name
        anaconda.id.userAccount["password"] = self.password
        anaconda.id.userAccount["groups"] = ["video", "audio"]
        anaconda.id.userAccount["isSudoer"] = True
        anaconda.id.userAccount["lock"] = self.lock
        self.handler.skipSteps.append("adduser")

class SELinux(commands.selinux.FC3_SELinux):
    def execute(self, anaconda):
        anaconda.id.security.setSELinux(self.selinux)

class SkipX(commands.skipx.FC3_SkipX):
    def execute(self, anaconda):
        self.handler.skipSteps.extend(["setsanex", "videocard", "xcustom"])

        if anaconda.id.desktop is not None:
            anaconda.id.desktop.setDefaultRunLevel(3)

class Timezone(commands.timezone.FC6_Timezone):
    def execute(self, anaconda):
        # check validity
        #tab = zonetab.ZoneTab()
        #if self.timezone not in (entry.tz.replace(' ','_') for entry in
        #                         tab.getEntries()):
        #    log.warning("Timezone %s set in kickstart is not valid." % (self.timezone,))

        anaconda.id.timezone.setTimezoneInfo(self.timezone, self.isUtc)
        self.handler.skipSteps.append("timedate")

class Upgrade(commands.upgrade.F11_Upgrade):
    def execute(self, anaconda):
        anaconda.id.setUpgrade(self.upgrade)

class VolGroupData(commands.volgroup.FC3_VolGroupData):
    def execute(self, anaconda):
        pvs = []

        storage = anaconda.id.storage
        devicetree = storage.devicetree

        storage.doAutoPart = False

        # Get a list of all the physical volume devices that make up this VG.
        for pv in self.physvols:
            # if pv is using --onpart, use original device
            pv = self.handler.onPart.get(pv, pv)
            dev = devicetree.getDeviceByName(pv)
            if not dev:
                raise KickstartValueError, formatErrorMsg(self.lineno, msg="Tried to use undefined partition %s in Volume Group specification" % pv)

            pvs.append(dev)

        if len(pvs) == 0 and not self.preexist:
            raise KickstartValueError, formatErrorMsg(self.lineno, msg="Volume group defined without any physical volumes.  Either specify physical volumes or use --useexisting.")

        if self.pesize not in getPossiblePhysicalExtents(floor=1024):
            raise KickstartValueError, formatErrorMsg(self.lineno, msg="Volume group specified invalid pesize")

        # If --noformat or --useexisting was given, there's really nothing to do.
        if not self.format or self.preexist:
            if not self.vgname:
                raise KickstartValueError, formatErrorMsg(self.lineno, msg="--noformat or --useexisting used without giving a name")

            dev = devicetree.getDeviceByName(self.vgname)
            if not dev:
                raise KickstartValueError, formatErrorMsg(self.lineno, msg="No preexisting VG with the name \"%s\" was found." % self.vgname)
        else:
            request = storage.newVG(pvs=pvs,
                                    name=self.vgname,
                                    peSize=self.pesize/1024.0)

            storage.createDevice(request)

class XConfig(commands.xconfig.F10_XConfig):
    def execute(self, anaconda):
        if self.startX:
            anaconda.id.desktop.setDefaultRunLevel(5)

        if self.defaultdesktop:
            anaconda.id.desktop.setDefaultDesktop(self.defaultdesktop)

class ZeroMbr(commands.zerombr.FC3_ZeroMbr):
    def execute(self, anaconda):
        anaconda.id.storage.zeroMbr = 1

class ZFCPData(commands.zfcp.FC3_ZFCPData):
    def execute(self, anaconda):
        try:
            anaconda.id.zfcp.addFCP(self.devnum, self.wwpn, self.fcplun)
        except ValueError, e:
            log.warning(str(e))

        isys.flushDriveDict()


###
### HANDLERS
###

# This is just the latest entry from pykickstart.handlers.control with all the
# classes we're overriding in place of the defaults.
commandMap = {
        "auth": Authconfig,
        "authconfig": Authconfig,
        "autostep": AutoStep,
        "bootloader": Bootloader,
        "clearpart": ClearPart,
        "dmraid": DmRaid,
        "firewall": Firewall,
        "firstboot": Firstboot,
        "halt": Reboot,
        "ignoredisk": IgnoreDisk,
        "install": Upgrade,
        "iscsiname": IscsiName,
        "keyboard": Keyboard,
        "lang": Lang,
        "logging": Logging,
        "multipath": MultiPath,
        "poweroff": Reboot,
        "reboot": Reboot,
        "rootpw": RootPw,
        "user": AddUser,
        "selinux": SELinux,
        "shutdown": Reboot,
        "skipx": SkipX,
        "timezone": Timezone,
        "upgrade": Upgrade,
        "xconfig": XConfig,
        "zerombr": ZeroMbr,
}

dataMap = {
        "FcoeData": FcoeData,
        "IscsiData": IscsiData,
        "LogVolData": LogVolData,
        "NetworkData": NetworkData,
        "PartData": PartitionData,
        "RaidData": RaidData,
        "VolGroupData": VolGroupData,
        "ZFCPData": ZFCPData
}

superclass = returnClassForVersion()

class AnacondaKSHandler(superclass):
    def __init__ (self, anaconda):
        superclass.__init__(self, commandUpdates=commandMap, dataUpdates=dataMap)
        self.packages = AnacondaKSPackages()

        self.permanentSkipSteps = []
        self.skipSteps = []
        self.showSteps = []
        self.anaconda = anaconda
        self.id = self.anaconda.id
        self.onPart = {}

        # All the KickstartCommand and KickstartData objects that
        # handleCommand returns, so we can later iterate over them and run
        # the execute methods.  These really should be stored in the order
        # they're seen in the kickstart file.
        self._dataObjs = []

    def add(self, obj):
        if isinstance(obj, KickstartCommand):
            # Commands can only be run once, and the latest one seen takes
            # precedence over any earlier ones.
            i = 0
            while i < len(self._dataObjs):
                if self._dataObjs[i].__class__ == obj.__class__:
                    self._dataObjs.pop(i)
                    break

                i += 1

            self._dataObjs.append(obj)
        else:
            # Data objects can be seen over and over again.
            self._dataObjs.append(obj)

    def dispatcher(self, args, lineno, include=None):
        # This is a big fat hack, and I don't want it in pykickstart.  A lot
        # of our overridden data objects here refer to the handler (to skip
        # steps, mainly).  I don't think this should be pykickstart's job
        # since it's only required for anaconda, so it's got to go here.
        obj = superclass.dispatcher(self, args, lineno, include=include)

        if isinstance(obj, BaseData) and self.commands[args[0]] != None:
            obj.handler = self

        return obj

    def execute(self):
        for obj in filter(lambda o: hasattr(o, "execute"), self._dataObjs):
            obj.execute(self.anaconda)

class AnacondaPreParser(KickstartParser):
    # A subclass of KickstartParser that only looks for %pre scripts and
    # sets them up to be run.  All other scripts and commands are ignored.
    def __init__ (self, handler, followIncludes=True, errorsAreFatal=True,
                  missingIncludeIsFatal=True):
        KickstartParser.__init__(self, handler, missingIncludeIsFatal=False)

    def addScript (self):
        if self._script["type"] != KS_SCRIPT_PRE:
            return

        s = AnacondaKSScript (self._script["body"], type=self._script["type"],
                              interp=self._script["interp"],
                              lineno=self._script["lineno"],
                              inChroot=self._script["chroot"],
                              logfile=self._script["log"],
                              errorOnFail=self._script["errorOnFail"])
        self.handler.scripts.append(s)

    def addPackages (self, line):
        pass

    def handleCommand (self, lineno, args):
        pass

    def handlePackageHdr (self, lineno, args):
        pass

    def handleScriptHdr (self, lineno, args):
        if not args[0] == "%pre":
            return

        KickstartParser.handleScriptHdr(self, lineno, args)

class AnacondaKSParser(KickstartParser):
    def __init__ (self, handler, followIncludes=True, errorsAreFatal=True,
                  missingIncludeIsFatal=True):
        KickstartParser.__init__(self, handler)

    def addScript (self):
        if string.join(self._script["body"]).strip() == "":
            return

        s = AnacondaKSScript (self._script["body"], type=self._script["type"],
                              interp=self._script["interp"],
                              lineno=self._script["lineno"],
                              inChroot=self._script["chroot"],
                              logfile=self._script["log"],
                              errorOnFail=self._script["errorOnFail"])
        self.handler.scripts.append(s)

    def handlePackageHdr (self, lineno, args):
        KickstartParser.handlePackageHdr (self, lineno, args)
        self.handler.packages.seen = True

    def handleCommand (self, lineno, args):
        if not self.handler:
            return

        retval = KickstartParser.handleCommand(self, lineno, args)
        self.handler.add(retval)
        return retval

def preScriptPass(anaconda, file):
    # The first pass through kickstart file processing - look for %pre scripts
    # and run them.  This must come in a separate pass in case a script
    # generates an included file that has commands for later.
    ksparser = AnacondaPreParser(AnacondaKSHandler(anaconda))

    try:
        ksparser.readKickstart(file)
    except IOError, e:
        if anaconda.intf:
            anaconda.intf.kickstartErrorWindow("Could not open kickstart file or included file named %s" % e.filename)
            sys.exit(1)
        else:
            print _("The following error was found while parsing the kickstart "
                    "configuration file:\n\n%s") % e
            sys.exit(1)
    except KickstartError, e:
       if anaconda.intf:
           anaconda.intf.kickstartErrorWindow(e.__str__())
           sys.exit(1)
       else:
            print _("The following error was found while parsing the kickstart "
                    "configuration file:\n\n%s") % e
            sys.exit(1)

    # run %pre scripts
    runPreScripts(anaconda, ksparser.handler.scripts)

def parseKickstart(anaconda, file):
    try:
        file = preprocessKickstart(file)
    except KickstartError, msg:
        stdoutLog.critical(_("Error processing %%ksappend lines: %s") % msg)
        sys.exit(1)
    except Exception, e:
        stdoutLog.critical(_("Unknown error processing %%ksappend lines: %s") % e)
        sys.exit(1)

    handler = AnacondaKSHandler(anaconda)
    ksparser = AnacondaKSParser(handler)

    # We need this so all the /dev/disk/* stuff is set up before parsing.
    udev_trigger(subsystem="block")

    try:
        ksparser.readKickstart(file)
    except IOError, e:
        # We may not have an intf now, but we can do better than just raising
        # the exception.
        if anaconda.intf:
            anaconda.intf.kickstartErrorWindow("Could not open kickstart file or included file named %s" % e.filename)
            sys.exit(1)
        else:
            print _("The following error was found while parsing the kickstart "
                    "configuration file:\n\n%s") % e
            sys.exit(1)
    except KickstartError, e:
        if anaconda.intf:
            anaconda.intf.kickstartErrorWindow(e.__str__())
            sys.exit(1)
        else:
            print _("The following error was found while parsing the kickstart "
                    "configuration file:\n\n%s") % e
            sys.exit(1)

    return handler

def runPostScripts(anaconda):
    if not anaconda.id.ksdata:
        return

    postScripts = filter (lambda s: s.type == KS_SCRIPT_POST,
                          anaconda.id.ksdata.scripts)

    if len(postScripts) == 0:
        return

    # Remove environment variables that cause problems for %post scripts.
    for var in ["LIBUSER_CONF"]:
        if os.environ.has_key(var):
            del(os.environ[var])

    log.info("Running kickstart %%post script(s)")
    if anaconda.intf is not None:
        w = anaconda.intf.waitWindow(_("Post-Installation"),
                            _("Running post-installation scripts"))
        
    map (lambda s: s.run(anaconda.rootPath, flags.serial, anaconda.intf), postScripts)

    log.info("All kickstart %%post script(s) have been run")
    if anaconda.intf is not None:
        w.pop()

def runPreScripts(anaconda, scripts):
    preScripts = filter (lambda s: s.type == KS_SCRIPT_PRE, scripts)

    if len(preScripts) == 0:
        return

    log.info("Running kickstart %%pre script(s)")
    if anaconda.intf is not None:
        w = anaconda.intf.waitWindow(_("Pre-Installation"),
                            _("Running pre-installation scripts"))
    
    map (lambda s: s.run("/", flags.serial, anaconda.intf), preScripts)

    log.info("All kickstart %%pre script(s) have been run")
    if anaconda.intf is not None:
        w.pop()

def runTracebackScripts(anaconda):
    log.info("Running kickstart %%traceback script(s)")
    for script in filter (lambda s: s.type == KS_SCRIPT_TRACEBACK,
                          anaconda.id.ksdata.scripts):
        script.run("/", flags.serial)
    log.info("All kickstart %%traceback script(s) have been run")

def selectPackages(anaconda):
    ksdata = anaconda.id.ksdata
    ignoreAll = False

    # If no %packages header was seen, use the installclass's default group
    # selections.  This can also be explicitly specified with %packages
    # --default.  Otherwise, select whatever was given (even if it's nothing).
    if not ksdata.packages.seen or ksdata.packages.default:
        anaconda.id.instClass.setGroupSelection(anaconda)
        return

    for pkg in ksdata.packages.packageList:
        num = anaconda.backend.selectPackage(pkg)
        if ksdata.packages.handleMissing == KS_MISSING_IGNORE or ignoreAll:
            continue
        if num > 0:
            continue
        rc = anaconda.intf.messageWindow(_("Missing Package"),
                                _("You have specified that the "
                                  "package '%s' should be installed.  "
                                  "This package does not exist. "
                                  "Would you like to continue or "
                                  "abort this installation?") %(pkg,),
                                type="custom",
                                custom_buttons=[_("_Abort"),
                                                _("_Ignore All"),
                                                _("_Continue")])
        if rc == 0:
            sys.exit(1)
        elif rc == 1:
            ignoreAll = True

    anaconda.backend.selectGroup("Core")

    if ksdata.packages.addBase:
        anaconda.backend.selectGroup("Base")
    else:
        log.warning("not adding Base group")

    for grp in ksdata.packages.groupList:
        default = False
        optional = False

        if grp.include == GROUP_DEFAULT:
            default = True
        elif grp.include == GROUP_ALL:
            default = True
            optional = True

        try:
            anaconda.backend.selectGroup(grp.name, (default, optional))
        except NoSuchGroup, e:
            if ksdata.packages.handleMissing == KS_MISSING_IGNORE or ignoreAll:
                pass
            else:
                rc = anaconda.intf.messageWindow(_("Missing Group"),
                                        _("You have specified that the "
                                          "group '%s' should be installed. "
                                          "This group does not exist. "
                                          "Would you like to continue or "
                                          "abort this installation?")
                                        %(grp.name,),
                                        type="custom",
                                        custom_buttons=[_("_Abort"),
                                                        _("_Ignore All"),
                                                        _("_Continue")])
                if rc == 0:
                    sys.exit(1)
                elif rc == 1:
                    ignoreAll = True

    map(anaconda.backend.deselectPackage, ksdata.packages.excludedList)

def setSteps(anaconda):
    def havePackages(packages):
        return len(packages.groupList) > 0 or len(packages.packageList) > 0 or \
               len(packages.excludedList) > 0

    dispatch = anaconda.dispatch
    ksdata = anaconda.id.ksdata
    interactive = ksdata.interactive.interactive

    if ksdata.upgrade.upgrade:
        upgrade.setSteps(anaconda)

        # we have no way to specify migrating yet
        dispatch.skipStep("upgrademigfind")
        dispatch.skipStep("upgrademigratefs")
        dispatch.skipStep("upgradecontinue")
        dispatch.skipStep("findinstall", permanent = 1)
        dispatch.skipStep("language")
        dispatch.skipStep("keyboard")
        dispatch.skipStep("betanag")
        dispatch.skipStep("installtype")
    else:
        anaconda.id.instClass.setSteps(anaconda)
        dispatch.skipStep("findrootparts")

    if interactive or flags.autostep:
        dispatch.skipStep("installtype")
        dispatch.skipStep("bootdisk")

    dispatch.skipStep("bootdisk")
    dispatch.skipStep("betanag")
    dispatch.skipStep("installtype")
    dispatch.skipStep("network")
    dispatch.skipStep("complete")

    # Storage is initialized for us right when kickstart processing starts.
    dispatch.skipStep("storageinit")

    # Don't show confirmation screens on non-interactive installs.
    if not interactive:
        dispatch.skipStep("confirminstall")
        dispatch.skipStep("confirmupgrade")
        dispatch.skipStep("welcome")

    # Make sure to automatically reboot even in interactive if told to.
    #if interactive and ksdata.reboot.action in [KS_REBOOT, KS_SHUTDOWN]:
    #    dispatch.skipStep("complete")

    # If the package section included anything, skip group selection unless
    # they're in interactive.
    if ksdata.upgrade.upgrade:
        ksdata.skipSteps.extend(["tasksel", "group-selection"])

        # Special check for this, since it doesn't make any sense.
        if ksdata.packages.seen:
            warnings.warn("Ignoring contents of %packages section due to upgrade.")
    elif havePackages(ksdata.packages):
        if interactive:
            ksdata.showSteps.extend(["tasksel", "group-selection"])
        else:
            ksdata.skipSteps.extend(["tasksel", "group-selection"])
    else:
        if ksdata.packages.seen:
            ksdata.skipSteps.extend(["tasksel", "group-selection"])
        else:
            ksdata.showSteps.extend(["tasksel", "group-selection"])

    if not interactive:
        for n in ksdata.skipSteps:
            dispatch.skipStep(n)
        for n in ksdata.permanentSkipSteps:
            dispatch.skipStep(n, permanent=1)
    for n in ksdata.showSteps:
        dispatch.skipStep(n, skip = 0)

    # Text mode doesn't have all the steps that graphical mode does, so we
    # can't stop and prompt for missing information.  Make sure we've got
    # everything that would be provided by a missing section now and error
    # out if we don't.
    if anaconda.id.displayMode == "t":
        missingSteps = [("bootloader", "Bootloader configuration"),
                        ("group-selection", "Package selection")]
        errors = []

        for (step, msg) in missingSteps:
            if not dispatch.stepInSkipList(step):
                errors.append(msg)

        if len(errors) > 0:
            anaconda.intf.kickstartErrorWindow(_("The kickstart configuration "
                "file is missing required information that anaconda cannot "
                "prompt for. Please add the following sections and try "
                "again:\n%s") % ", ".join(errors))
            sys.exit(0)
