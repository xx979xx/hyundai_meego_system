#
# bootloaderInfo.py - bootloader config object used in creation of new
#                     bootloader configs.  Originally from anaconda
#
# Jeremy Katz <katzj@redhat.com>
# Erik Troan <ewt@redhat.com>
# Peter Jones <pjones@redhat.com>
#
# Copyright 2005-2008 Red Hat, Inc.
#
# This software may be freely redistributed under the terms of the GNU
# library public license.
#
# You should have received a copy of the GNU Library Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#

import os, sys
import crypt
import random
import shutil
import string
import struct
import rhpl
from copy import copy
import stat
import logging
log = logging.getLogger("anaconda")

import gettext
_ = lambda x: gettext.ldgettext("anaconda", x)
N_ = lambda x: x

from lilo import LiloConfigFile

from flags import flags
import iutil
import isys
from product import *

import booty
import checkbootloader
from util import getDiskPart

if not iutil.isS390():
    import block

dosFilesystems = ('FAT', 'fat16', 'fat32', 'ntfs', 'hpfs')

def doesDualBoot():
    if iutil.isX86():
        return 1
    return 0

def checkForBootBlock(device):
    fd = os.open(device, os.O_RDONLY)
    buf = os.read(fd, 512)
    os.close(fd)
    if len(buf) >= 512 and \
           struct.unpack("H", buf[0x1fe: 0x200]) == (0xaa55,):
        return True
    return False

# hack and a half
# there's no guarantee that data is written to the disk and grub
# reads both the filesystem and the disk.  suck.
def syncDataToDisk(dev, mntpt, instRoot = "/"):
    isys.sync()
    isys.sync()
    isys.sync()

    # and xfs is even more "special" (#117968)
    if isys.readFSType(dev) == "xfs":
        iutil.execWithRedirect("/usr/sbin/xfs_freeze",
                               ["-f", mntpt],
                               stdout = "/dev/tty5",
                               stderr = "/dev/tty5",
                               root = instRoot)
        iutil.execWithRedirect("/usr/sbin/xfs_freeze",
                               ["-u", mntpt],
                               stdout = "/dev/tty5",
                               stderr = "/dev/tty5",
                               root = instRoot)    

def rootIsDevice(dev):
    if dev.startswith("LABEL=") or dev.startswith("UUID="):
        return False
    return True

class KernelArguments:

    def get(self):
        if self.args and self.appendArgs:
            return self.args + " " + self.appendArgs
        else:
            return self.args + self.appendArgs

        args = self.args
        root = self.id.storage.rootDevice
        for d in self.id.storage.devices:
            if root.dependsOn(d):
                dracutSetupString = d.dracutSetupString()
                if len(dracutSetupString):
                    args += " %s" % dracutSetupString
                import storage
                if isinstance(d, storage.devices.NetworkStorageDevice):
                    args += " "
                    args += self.id.network.dracutSetupString(d)

        args += self.id.instLanguage.dracutSetupString()
        #args += self.id.keyboard.dracutSetupString()

        if args and self.appendArgs:
            args += " "

        return args + self.appendArgs

    def set(self, args):
        self.args = args
        self.appendArgs = ""

    def chandevget(self):
        return self.cargs

    def chandevset(self, args):
        self.cargs = args

    def append(self, args):
        # don't duplicate the addition of an argument (#128492)
        if self.args.find(args) != -1:
            return
        if self.appendArgs.find(args) != -1:
            return

        if self.appendArgs:
            self.appendArgs += " "

        self.appendArgs += args

    def __init__(self, instData):
        newArgs = []
        cfgFilename = "/tmp/install.cfg"

        if iutil.isS390():
            self.cargs = []
            f = open(cfgFilename)
            for line in f:
                try:
                    (vname,vparm) = line.split('=', 1)
                    vname = vname.strip()
                    vparm = vparm.replace('"','')
                    vparm = vparm.strip()
                    if vname == "CHANDEV":
                        self.cargs.append(vparm)
                    if vname == "QETHPARM":
                        self.cargs.append(vparm)
                except Exception, e:
                    pass
            f.close()

        # look for kernel arguments we know should be preserved and add them
        ourargs = ["speakup_synth", "apic", "noapic", "apm", "ide", "noht",
                   "acpi", "video", "pci", "nodmraid", "nompath", "nomodeset",
                   "noiswmd"]

        if iutil.isS390():
            ourargs.append("cio_ignore")

        for arg in ourargs:
            if not flags.cmdline.has_key(arg):
                continue

            val = flags.cmdline.get(arg, "")
            if val:
                newArgs.append("%s=%s" % (arg, val))
            else:
                newArgs.append(arg)

        self.args = " ".join(newArgs)
        self.appendArgs = ""
        self.id = instData


class BootImages:
    """A collection to keep track of boot images available on the system.
    Examples would be:
    ('linux', 'Red Hat Linux', 'ext2'),
    ('Other', 'Other', 'fat32'), ...
    """
    def __init__(self):
        self.default = None
        self.images = {}
        self.bootDevice = None

    def getImages(self):
        """returns dictionary of (label, longlabel, devtype) pairs 
        indexed by device"""
        # return a copy so users can modify it w/o affecting us
        return copy(self.images)

    def setDefault(self, default):
        # default is a device
        self.default = default

    def getDefault(self):
        return self.default

    # Construct a dictionary mapping device names to (OS, product, type)
    # tuples.
    def setup(self, storage):
        devices = {}
        bootDevs = self.availableBootDevices(storage)

        for (dev, type) in bootDevs:
            devices[dev.name] = 1

        # These partitions have disappeared
        for dev in self.images.keys():
            if not devices.has_key(dev):
                del self.images[dev]

        # These have appeared
        for (dev, type) in bootDevs:
            if not self.images.has_key(dev.name):
                if type in dosFilesystems and doesDualBoot():
                    self.images[dev.name] = ("Other", "Other", type)
                elif type in ("hfs", "hfs+") and iutil.getPPCMachine() == "PMac":
                    self.images[dev.name] = ("Other", "Other", type)
                else:
                    self.images[dev.name] = (None, None, type)

        if not self.images.has_key(self.default):
            if self.bootDevice:
                self.default = self.bootDevice.name
            else:
                self.default = storage.rootDevice.name
            (label, longlabel, type) = self.images[self.default]
            if not label:
                self.images[self.default] = ("linux", productName, type)

    # Return a list of (storage.Device, string) tuples that are bootable
    # devices.  The string is the type of the device, which is just a string
    # like "vfat" or "swap" or "lvm".
    def availableBootDevices(self, storage):
        import parted
        retval = []
        foundDos = False
        foundAppleBootstrap = False

        for part in [p for p in storage.partitions if p.exists]:
            # Skip extended, metadata, freespace, etc.
            if part.partType not in (parted.PARTITION_NORMAL, parted.PARTITION_LOGICAL) or not part.format:
                continue

            type = part.format.type

            if type in dosFilesystems and not foundDos and doesDualBoot():
                try:
                    bootable = checkForBootBlock(part.path)
                    retval.append((part, type))
                    foundDos = True
                except:
                    pass
            elif type in ["ntfs", "hpfs"] and not foundDos and doesDualBoot():
                retval.append((part, type))
                # maybe questionable, but the first ntfs or fat is likely to
                # be the correct one to boot with XP using ntfs
                foundDos = True
            elif type == "appleboot" and iutil.getPPCMachine() == "PMac" and part.bootable:
                foundAppleBootstrap = True
            elif type in ["hfs", "hfs+"] and foundAppleBootstrap:
                # questionable for same reason as above, but on mac this time
                retval.append((part, type))
        
        rootDevice = storage.rootDevice

        if not rootDevice or not rootDevice.format:
            raise ValueError, ("Trying to pick boot devices but do not have a "
                               "sane root partition.  Aborting install.")

        try:
            self.bootDevice = storage.mountpoints["/boot"]
        except KeyError:
            log.info("Failed to get bootDevice, using rootDevice")
            self.bootDevice = rootDevice

        log.info("Got bootDevice.format.type = %s" % self.bootDevice.format.type)
        retval.append((self.bootDevice, self.bootDevice.format.type))
        retval.sort()
        return retval

class bootloaderInfo(object):
    def getConfigFileName(self):
        if not self._configname:
            raise NotImplementedError
        return self._configname
    configname = property(getConfigFileName, None, None, \
                          "bootloader config file name")

    def getConfigFileDir(self):
        if not self._configdir:
            raise NotImplementedError
        return self._configdir
    configdir = property(getConfigFileDir, None, None, \
                         "bootloader config file directory")

    def getConfigFilePath(self):
        return "%s/%s" % (self.configdir, self.configname)
    configfile = property(getConfigFilePath, None, None, \
                          "full path and name of the real config file")

    def setUseGrub(self, val):
        pass

    def useGrub(self):
        return self.useGrubVal

    def useSyslinux(self):
        return self.useSyslinuxVal

    def setPassword(self, val, isCrypted = 1):
        pass

    def getPassword(self):
        pass

    def getDevice(self):
        return self.device

    def setDevice(self, device):
        self.device = device

        (dev, part) = getDiskPart(device, self.storage)
        if part is None:
            self.defaultDevice = "mbr"
        else:
            self.defaultDevice = "partition"

    def makeInitrd(self, kernelTag, instRoot):
        initrd = "initrd%s.img" % kernelTag
        if os.access(instRoot + "/boot/" + initrd, os.R_OK):
            return initrd

        initrd = "initramfs%s.img" % kernelTag
        if os.access(instRoot + "/boot/" + initrd, os.R_OK):
            return initrd

        return None

    def getBootloaderConfig(self, instRoot, bl, kernelList,
                            chainList, defaultDev):
        images = bl.images.getImages()

        confFile = instRoot + self.configfile

        # on upgrade read in the lilo config file
        lilo = LiloConfigFile ()
        self.perms = 0600
        if os.access (confFile, os.R_OK):
            self.perms = os.stat(confFile)[0] & 0777
            lilo.read(confFile)
            os.rename(confFile, confFile + ".rpmsave")
        # if it's an absolute symlink, just get it out of our way
        elif (os.path.islink(confFile) and os.readlink(confFile)[0] == '/'):
            os.rename(confFile, confFile + ".rpmsave")

        # Remove any invalid entries that are in the file; we probably
        # just removed those kernels. 
        for label in lilo.listImages():
            (fsType, sl, path, other) = lilo.getImage(label)
            if fsType == "other": continue

            if not os.access(instRoot + sl.getPath(), os.R_OK):
                lilo.delImage(label)

        lilo.addEntry("prompt", replace = 0)
        lilo.addEntry("timeout", self.timeout or "20", replace = 0)

        rootDev = self.storage.rootDevice

        if rootDev.name == defaultDev.name:
            lilo.addEntry("default", kernelList[0][0])
        else:
            lilo.addEntry("default", chainList[0][0])

        for (label, longlabel, version) in kernelList:
            kernelTag = "-" + version
            kernelFile = self.kernelLocation + "vmlinuz" + kernelTag

            try:
                lilo.delImage(label)
            except IndexError, msg:
                pass

            sl = LiloConfigFile(imageType = "image", path = kernelFile)

            initrd = self.makeInitrd(kernelTag, instRoot)

            sl.addEntry("label", label)
            if initrd:
                sl.addEntry("initrd", "%s%s" %(self.kernelLocation, initrd))

            sl.addEntry("read-only")

            append = "%s" %(self.args.get(),)
            realroot = rootDev.fstabSpec
            if rootIsDevice(realroot):
                sl.addEntry("root", rootDev.path)
            else:
                if len(append) > 0:
                    append = "%s root=%s" %(append,realroot)
                else:
                    append = "root=%s" %(realroot,)
            
            if len(append) > 0:
                sl.addEntry('append', '"%s"' % (append,))
                
            lilo.addImage (sl)

        for (label, longlabel, device) in chainList:
            if ((not label) or (label == "")):
                continue
            try:
                (fsType, sl, path, other) = lilo.getImage(label)
                lilo.delImage(label)
            except IndexError:
                sl = LiloConfigFile(imageType = "other",
                                    path = "/dev/%s" %(device))
                sl.addEntry("optional")

            sl.addEntry("label", label)
            lilo.addImage (sl)

        # Sanity check #1. There could be aliases in sections which conflict
        # with the new images we just created. If so, erase those aliases
        imageNames = {}
        for label in lilo.listImages():
            imageNames[label] = 1

        for label in lilo.listImages():
            (fsType, sl, path, other) = lilo.getImage(label)
            if sl.testEntry('alias'):
                alias = sl.getEntry('alias')
                if imageNames.has_key(alias):
                    sl.delEntry('alias')
                imageNames[alias] = 1

        # Sanity check #2. If single-key is turned on, go through all of
        # the image names (including aliases) (we just built the list) and
        # see if single-key will still work.
        if lilo.testEntry('single-key'):
            singleKeys = {}
            turnOff = 0
            for label in imageNames.keys():
                l = label[0]
                if singleKeys.has_key(l):
                    turnOff = 1
                singleKeys[l] = 1
            if turnOff:
                lilo.delEntry('single-key')

        return lilo

    def write(self, instRoot, bl, kernelList, chainList,
            defaultDev, justConfig):
        rc = 0

        if len(kernelList) >= 1:
            config = self.getBootloaderConfig(instRoot, bl,
                                              kernelList, chainList,
                                              defaultDev)
            rc = config.write(instRoot + self.configfile, perms = self.perms)
        else:
            raise booty.BootyNoKernelWarning

        return rc

    def getArgList(self):
        args = []

        if self.defaultDevice is None:
            args.append("--location=none")
            return args

        args.append("--location=%s" % (self.defaultDevice,))
        args.append("--driveorder=%s" % (",".join(self.drivelist)))

        if self.args.get():
            args.append("--append=\"%s\"" %(self.args.get()))

        return args

    def writeKS(self, f):
        f.write("bootloader")
        for arg in self.getArgList():
            f.write(" " + arg)
        f.write("\n")

    def updateDriveList(self, sortedList=[]):
        self._drivelist = map(lambda x: x.name, self.storage.disks)
        self._drivelist.sort(isys.compareDrives)

        # If we're given a sort order, make sure the drives listed in it
        # are put at the head of the drivelist in that order.  All other
        # drives follow behind in whatever order they're found.
        if sortedList != []:
            revSortedList = sortedList
            revSortedList.reverse()

            for i in revSortedList:
                try:
                    ele = self._drivelist.pop(self._drivelist.index(i))
                    self._drivelist.insert(0, ele)
                except:
                    pass

    def _getDriveList(self):
        if self._drivelist is not None:
            return self._drivelist
        self.updateDriveList()
        return self._drivelist
    def _setDriveList(self, val):
        self._drivelist = val
    drivelist = property(_getDriveList, _setDriveList)

    def __init__(self, instData):
        self.args = KernelArguments(instData)
        self.images = BootImages()
        self.device = None
        self.defaultDevice = None  # XXX hack, used by kickstart
        self.useGrubVal = 0      # only used on x86
        self.useSyslinuxVal = 0  # use syslinux by default
        self._configdir = None
        self._configname = None
        self.kernelLocation = "/boot/"
        self.password = None
        self.pure = None
        self.above1024 = 0
        self.timeout = None
        self.storage = instData.storage

        # this has somewhat strange semantics.  if 0, act like a normal
        # "install" case.  if 1, update lilo.conf (since grubby won't do that)
        # and then run lilo or grub only.
        # XXX THIS IS A HACK.  implementation details are only there for x86
        self.doUpgradeOnly = 0
        self.kickstart = 0

        self._drivelist = None

        if flags.serial != 0:
            options = ""
            device = ""
            console = flags.cmdline.get("console", "")

            # the options are everything after the comma
            comma = console.find(",")
            if comma != -1:
                options = console[comma:]
                device = console[:comma]
            else:
                device = console

            if not device and iutil.isIA64():
                self.serialDevice = "ttyS0"
                self.serialOptions = ""
            else:
                self.serialDevice = device
                # don't keep the comma in the options
                self.serialOptions = options[1:]

            if self.serialDevice:
                self.args.append("console=%s%s" %(self.serialDevice, options))
                self.serial = 1
                self.timeout = 5
        else:
            self.serial = 0
            self.serialDevice = None
            self.serialOptions = None

        if flags.virtpconsole is not None:
            if flags.virtpconsole.startswith("/dev/"):
                con = flags.virtpconsole[5:]
            else:
                con = flags.virtpconsole
            self.args.append("console=%s" %(con,))


class syslinuxBootloaderInfo(bootloaderInfo):
    def __init__(self, instData):
        bootloaderInfo.__init__(self, instData)
        self._configdir = None
        self._configname = None
        self.bootloader = None
        self.kernelLocation = "/boot"
        self.useSyslinuxVal = 1
        self.storage = instData.storage

    def setBootloader(self, name):
        self.bootloader = name
        if name == "syslinux":
            self._configdir = "/boot/syslinux"
            self._configname = "syslinux.cfg"
        elif name == "extlinux":
            self._configdir = "/boot/extlinux"
            self._configname = "extlinux.conf"

    def setPassword(self, val, isCrypted = 1):
        if not val:
            self.password = val
            self.pure = val
            return

        if isCrypted and self.useSyslinuxVal == 0:
            self.pure = None
            return
        elif isCrypted:
            self.password = val
            self.pure = None
        else:
            salt = "$1$"
            saltLen = 8

            saltchars = string.letters + string.digits + './'
            for i in range(saltLen):
                salt += random.choice(saltchars)

            self.password = crypt.crypt(val, salt)
            self.pure = val

    def getPassword (self):
        return self.pure


    def syslinuxDiskNum(self, dev):
        (name, partNum) = getDiskPart(dev, self.storage)
        num = name.strip()[-1]
        if num.isalpha():
           num = ord(num) - 97
        elif num.isdigit():
           num = ord(num) - 48
        return num

    def syslinuxPartitionNum(self, dev):
        (name, partNum) = getDiskPart(dev, self.storage)
        return partNum

    def write(self, instRoot, bl, kernelList, chainList,
              defaultDev, justConfig):
        if not os.path.isdir(instRoot + self.configdir):
            os.mkdir(instRoot + self.configdir)

        f = open(instRoot + self.configfile, "w+")
        f.write("# extlinux.conf generated by anaconda\n\n")

        f.write("prompt 0\n")
        if not self.password:
            f.write("timeout %s\n" % (self.timeout or 1))

        rootDev = self.storage.rootDevice.name
        if rootDev[0] != "/":
            rootDev = "/dev/" + rootDev        
        log.info("booty: rootDev %s" %(rootDev,))

        try:
            bootp = self.storage.mountpoints["/boot"]
        except KeyError:
            bootp = False

        if not bootp:
            bootp = self.storage.rootDevice
        bootDev = bootp.name        
        if bootDev[0] != "/":
            bootDev = "/dev/" + bootDev        
        bootdisk = getDiskPart(bootDev, self.storage)[0]
        log.info("booty: bootdisk %s" %(bootdisk,))

        # syslinux config header
        log.info("booty: write bootloader config")
        resolutionline = ""
        splash = "%s/usr/lib/anaconda-runtime/syslinux-vesa-splash.jpg" % instRoot
        try:
            import gtk
            width = gtk.gdk.screen_width()
            height = gtk.gdk.screen_height()

            resolutionline = "menu resolution %s %s" %(width, height )
            log.info("booty: Write resolution width=%s, height=%s" %(width, height ))
            if width > 640:
                splash = "%s/usr/lib/anaconda-runtime/splash-high-resolution.jpg" % instRoot
        except:
            log.info("booty: failed to get screen width and height")

        if os.path.exists(splash):
            shutil.copy(splash, "%s%s/splash.jpg" % (instRoot, self.configdir))
            splashline = "menu background splash.jpg"
        else:
            splashline = ""
        
        if self.password:
            menuhidden=""
        else:
            menuhidden="menu hidden"

        defaultmenu="default vesamenu.c32"
        for (label, longlabel, version) in kernelList:
            if version.find("-connext") != -1 or version.find("-automotive") != -1 :
                log.info("booty: ivi build, use menu.c32")
                defaultmenu="default menu.c32"
                break
 
        f.write("""
%s
menu autoboot Starting MeeGo...
%s

%s
%s
menu title Welcome to MeeGo!
menu color border 0 #ffffffff #00000000
menu color sel 7 #ffffffff #ff000000
menu color title 0 #ffffffff #00000000
menu color tabmsg 0 #ffffffff #00000000
menu color unsel 0 #ffffffff #00000000
menu color hotsel 0 #ff000000 #ffffffff
menu color hotkey 7 #ffffffff #ff000000
menu color timeout_msg 0 #ffffffff #00000000
menu color timeout 0 #ffffffff #00000000
menu color cmdline 0 #ffffffff #00000000
""" %(defaultmenu, menuhidden, resolutionline, splashline))

        if self.password:
            f.write("menu master passwd %s\n" %(self.password))
    
        menudefault = True
        if defaultDev and chainList:
            defaultDev_name = defaultDev.name
            if defaultDev_name[0] != "/":
                defaultDev_name = "/dev/" + defaultDev_name
            log.info("booty: defautldev %s rootdev %s bootdev %s" %(defaultDev_name, rootDev, bootDev))
            if defaultDev_name != rootDev and defaultDev_name != bootDev:
                menudefault = False

        for (label, longlabel, version) in kernelList:
            # XXX hackity, hack hack hack.  but we need them in a different
            # path for live cd only
            os.symlink("../vmlinuz-%s" % version,
                        "%s%s/vmlinuz-%s" %(instRoot, self.configdir, version))
            
            # FIXME: need to dtrt for xen kernels with multiboot com32 module
            f.write("label meego\n")
            if self.password:
                f.write("\tmenu passwd\n")
            if ((not longlabel) or (longlabel == "")):
                f.write("\tmenu label MeeGo (%s)\n" % version)
            else:
                f.write('\tmenu label %s (%s)\n' % (longlabel, version))

            f.write("\tkernel vmlinuz-%s\n" % version)
            f.write('\tappend ro root=%s' % rootDev)
            if self.args.get():
                f.write(' %s' % self.args.get())
            f.write('\n')
            if menudefault:
                f.write("\tmenu default\n")
            break
        for (label, longlabel, device) in chainList:
            if ((not longlabel) or (longlabel == "")):
                continue
            f.write("label %s\n" % (label))
            if self.password:
                f.write("\tmenu passwd\n")
            f.write('\tmenu label %s\n' % (longlabel))
            f.write('\tkernel chain.c32\n')
            bootdisknum = self.syslinuxDiskNum(bootDev)
            mydisknum = self.syslinuxDiskNum(device)
            if bootdisknum == mydisknum:
                hdx = "boot"
            else:
                hdx = "hd%d" % mydisknum
            appendline = "\tappend %s" % hdx
            mypartnum = self.syslinuxPartitionNum(device)
            if mypartnum != None:
                appendline += " %d" % (mypartnum + 1)
            else:
                appendline += " 0"
            appendline += "\n"
            if not menudefault and defaultDev.name == label:
                log.info("Set menu default for %s" %(label))
                appendline = appendline + "\tmenu default\n"    
            f.write(appendline)
            
        f.close()
        os.chmod(instRoot + self.configfile, 0600)

        # Set bootable flag for /boot or / partition
        log.info("booty: set bootable flag for %s" % bootDev)
        parted = "/sbin/parted"
        if not os.path.exists(parted):
            parted = "/usr/sbin/parted"
            if not os.path.exists(parted):
                raise RuntimeError, "Failed to find parted"

        (mydisk,mypartnum) = getDiskPart(bootDev, self.storage)
        if mypartnum:
            mypartnum = mypartnum + 1
            log.info("booty: run command parted -s %s set %d boot on" %(mydisk, mypartnum))
            argv= [parted, "-s", mydisk, "set", "%d" % mypartnum, "boot", "on"]
            rhpl.executil.execWithRedirect(parted, argv,
                                           stdout = "/dev/tty5", stderr = "/dev/tty5",
                                           root = instRoot)

        # Install syslinux
        log.info("booty: install bootloader %s" % self.bootloader)
        if self.bootloader == "syslinux":
            prog = "/usr/bin/syslinux"
            argv = [prog, "-d", "syslinux", bootDev]
        elif self.bootloader == "extlinux":
            prog = "/sbin/extlinux"
            argv = [prog, "-i", self.configdir]
        rhpl.executil.execWithRedirect(prog, argv,
                                    stdout = "/dev/tty5", stderr = "/dev/tty5",
                                    root = instRoot)

        # Set MBR and save the original MBR for booting old partitions
        log.info("booty: save and set MBR")
        mbrsize = os.stat("/usr/share/syslinux/mbr.bin")[stat.ST_SIZE]
        rhpl.executil.execWithRedirect( "/bin/dd",
                                    ["/bin/dd", "if=" + bootdisk, "of=%s/mbr.bak" % self.configdir,
                                     "count=1", "bs=%d" % mbrsize],
                                    stdout = "/dev/tty5", stderr = "/dev/tty5",
                                    root = instRoot)
        rhpl.executil.execWithRedirect( "/bin/dd",
                                    ["/bin/dd", "if=/usr/share/syslinux/mbr.bin", "of=" + bootdisk],
                                    stdout = "/dev/tty5", stderr = "/dev/tty5",
                                    root = instRoot)

class efiBootloaderInfo(bootloaderInfo):
    def getBootloaderName(self):
        return self._bootloader
    bootloader = property(getBootloaderName, None, None, \
                          "name of the bootloader to install")

    # XXX wouldn't it be nice to have a real interface to use efibootmgr from?
    def removeOldEfiEntries(self, instRoot):
        p = os.pipe()
        rc = iutil.execWithRedirect('/usr/sbin/efibootmgr', [],
                                    root = instRoot, stdout = p[1])
        os.close(p[1])
        if rc:
            return rc

        c = os.read(p[0], 1)
        buf = c
        while (c):
            c = os.read(p[0], 1)
            buf = buf + c
        os.close(p[0])
        lines = string.split(buf, '\n')
        for line in lines:
            fields = string.split(line)
            if len(fields) < 2:
                continue
            if string.join(fields[1:], " ") == productName:
                entry = fields[0][4:8]
                rc = iutil.execWithRedirect('/usr/sbin/efibootmgr',
                                            ["-b", entry, "-B"],
                                            root = instRoot,
                                            stdout="/dev/tty5", stderr="/dev/tty5")
                if rc:
                    return rc

        return 0

    def addNewEfiEntry(self, instRoot):
        try:
            bootdev = self.storage.mountpoints["/boot/efi"].name
        except:
            bootdev = "sda1"

        link = "%s%s/%s" % (instRoot, "/etc/", self.configname)
        if not os.access(link, os.R_OK):
            os.symlink("../%s" % (self.configfile), link)

        ind = len(bootdev)
        try:
            while (bootdev[ind-1] in string.digits):
                ind = ind - 1
        except IndexError:
            ind = len(bootdev) - 1

        bootdisk = bootdev[:ind]
        bootpart = bootdev[ind:]
        if (bootdisk.startswith('ida/') or bootdisk.startswith('cciss/') or
            bootdisk.startswith('rd/') or bootdisk.startswith('sx8/')):
            bootdisk = bootdisk[:-1]

        argv = [ "/usr/sbin/efibootmgr", "-c" , "-w", "-L",
                 productName, "-d", "/dev/%s" % bootdisk,
                 "-p", bootpart, "-l", "\\EFI\\redhat\\" + self.bootloader ]
        rc = iutil.execWithRedirect(argv[0], argv[1:], root = instRoot,
                                    stdout = "/dev/tty5",
                                    stderr = "/dev/tty5")
        return rc

    def installGrub(self, instRoot, bootDev, grubTarget, grubPath, cfPath):
        if not iutil.isEfi():
            raise EnvironmentError
        rc = self.removeOldEfiEntries(instRoot)
        if rc:
            return rc
        return self.addNewEfiEntry(instRoot)

    def __init__(self, instData, initialize = True):
        if initialize:
            bootloaderInfo.__init__(self, instData)
        else:
            self.storage = instData.storage

        if iutil.isEfi():
            self._configdir = "/boot/efi/EFI/redhat"
            self._configname = "grub.conf"
            self._bootloader = "grub.efi"
            self.useGrubVal = 1
            self.kernelLocation = ""
