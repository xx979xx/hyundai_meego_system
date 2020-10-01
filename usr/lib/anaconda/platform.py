#
# platform.py:  Architecture-specific information
#
# Copyright (C) 2009
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
# Authors: Chris Lumens <clumens@redhat.com>
#

import iutil
import parted
import storage
from storage.errors import *
from storage.formats import *
from storage.partspec import *

import gettext
_ = lambda x: gettext.ldgettext("anaconda", x)
N_ = lambda x: x

class Platform(object):
    """Platform

       A class containing platform-specific information and methods for use
       during installation.  The intent is to eventually encapsulate all the
       architecture quirks in one place to avoid lots of platform checks
       throughout anaconda."""
    _bootFSTypes = ["ext3"]
    _diskLabelType = parted.diskType["msdos"]
    _isEfi = iutil.isEfi()
    _minimumSector = 0
    _packages = []
    _supportsMdRaidBoot = False
    _minBootPartSize = 50
    _maxBootPartSize = 0

    def __init__(self, anaconda):
        """Creates a new Platform object.  This is basically an abstract class.
           You should instead use one of the platform-specific classes as
           returned by getPlatform below.  Not all subclasses need to provide
           all the methods in this class."""
        self.anaconda = anaconda

    def _mntDict(self):
        """Return a dictionary mapping mount points to devices."""
        ret = {}
        for device in [d for d in self.anaconda.id.storage.devices if d.format.mountable]:
            ret[device.format.mountpoint] = device

        return ret

    def bootDevice(self):
        """Return the device where /boot is mounted."""
        if self.__class__ is Platform:
            raise NotImplementedError("bootDevice not implemented for this platform")

        mntDict = self._mntDict()
        return mntDict.get("/boot", mntDict.get("/"))

    @property
    def defaultBootFSType(self):
        """Return the default filesystem type for the boot partition."""
        return self._bootFSTypes[0]

    @property
    def bootFSTypes(self):
        """Return a list of all valid filesystem types for the boot partition."""
        return self._bootFSTypes

    def bootloaderChoices(self, bl):
        """Return the default list of places to install the bootloader.
           This is returned as a dictionary of locations to (device, identifier)
           tuples.  If there is no boot device, an empty dictionary is
           returned."""
        if self.__class__ is Platform:
            raise NotImplementedError("bootloaderChoices not implemented for this platform")

        bootDev = self.bootDevice()
        ret = {}

        if not bootDev:
            return ret

        if bootDev.type == "mdarray":
            ret["boot"] = (bootDev.name, N_("RAID Device"))
            ret["mbr"] = (bl.drivelist[0], N_("Master Boot Record (MBR)"))
        else:
            ret["boot"] = (bootDev.name, N_("First sector of boot partition"))
            ret["mbr"] = (bl.drivelist[0], N_("Master Boot Record (MBR)"))

        return ret

    def checkBootRequest(self, req):
        """Perform an architecture-specific check on the boot device.  Not all
           platforms may need to do any checks.  Returns a list of errors if
           there is a problem, or [] otherwise."""
        errors = []

        if not req:
            return [_("You have not created a bootable partition.")]

        if req.type == "mdarray" and req.level != 1:
            errors.append(_("Bootable partitions can only be on RAID1 devices."))

        # can't have bootable partition on LV
        if req.type == "lvmlv":
            errors.append(_("Bootable partitions cannot be on a logical volume."))

        # most arches can't have boot on RAID
        if req.type == "mdarray" and not self.supportsMdRaidBoot:
            errors.append(_("Bootable partitions cannot be on a RAID device."))

        # Make sure /boot is on a supported FS type.  This prevents crazy
        # things like boot on vfat.
        if not req.format.bootable or not req.format.type in self.bootFSTypes:
            errors.append(_("Bootable partitions cannot be on an %s filesystem.") % req.format.type)

        if req.type == "luks/dm-crypt":
            # Handle encrypted boot on a partition.
            errors.append(_("Bootable partitions cannot be on an encrypted block device"))
        else:
            # Handle encrypted boot on more complicated devices.
            for dev in map(lambda d: d.type == "luks/dm-crypt", self.anaconda.id.storage.devices):
                if req in self.anaconda.id.storage.deviceDeps(dev):
                    errors.append(_("Bootable partitions cannot be on an encrypted block device"))

        return errors

    def diskLabelType(self, deviceType):
        """Return the disk label type as a parted.DiskType."""
        return self._diskLabelType

    @property
    def isEfi(self):
        return self._isEfi

    @property
    def minimumSector(self, disk):
        """Return the minimum starting sector for the provided disk."""
        return self._minimumSector

    @property
    def packages (self):
        return self._packages

    def setDefaultPartitioning(self):
        """Return the default platform-specific partitioning information."""
        return [PartSpec(mountpoint="/boot", fstype=self.defaultBootFSType, size=250,
                         weight=self.weight(mountpoint="/boot"))]

    @property
    def supportsMdRaidBoot(self):
        """Does the platform support /boot on MD RAID?"""
        return self._supportsMdRaidBoot

    @property
    def minBootPartSize(self):
        return self._minBootPartSize

    @property
    def maxBootPartSize(self):
        return self._maxBootPartSize

    def validBootPartSize(self, size):
        """ Is the given size (in MB) acceptable for a boot device? """
        if not isinstance(size, int) and not isinstance(size, float):
            return False

        return ((not self.minBootPartSize or size >= self.minBootPartSize)
                and
                (not self.maxBootPartSize or size <= self.maxBootPartSize))

    def weight(self, fstype=None, mountpoint=None):
        """ Given an fstype (as a string) or a mountpoint, return an integer
            for the base sorting weight.  This is used to modify the sort
            algorithm for partition requests, mainly to make sure bootable
            partitions and /boot are placed where they need to be."""
        return 0

class EFI(Platform):
    _bootFSTypes = ["ext3", "ext4", "ext2"]
    _diskLabelType = parted.diskType["gpt"]
    _minBootPartSize = 50
    _maxBootPartSize = 256

    def bootDevice(self):
        mntDict = self._mntDict()
        return mntDict.get("/boot/efi")

    def bootloaderChoices(self, bl):
        bootDev = self.bootDevice()
        ret = {}

        if not bootDev:
            return ret

        ret["boot"] = (bootDev.name, N_("EFI System Partition"))
        return ret

    def checkBootRequest(self, req):
        if not req:
            return [_("You have not created a /boot/efi partition.")]

        errors = Platform.checkBootRequest(self, req)

        if req.format.mountpoint == "/boot/efi":
            if req.format.type != "efi":
                errors.append(_("/boot/efi is not EFI."))

        disk = req.disk.format.partedDisk

        # Check that we've got a correct disk label.
        if not disk.type in ["gpt", "msdos"]:
            errors.append(_("%s must have a GPT or MSDOS disk label.") % req.disk.name)

        return errors

    def setDefaultPartitioning(self):
        ret = Platform.setDefaultPartitioning(self)

        # Only add the EFI partition to the default set if there's not already
        # one on the system.
        if len(filter(lambda dev: dev.format.type == "efi" and self.validBootPartSize(dev.size),
                      self.anaconda.id.storage.partitions)) == 0:
            ret.append(PartSpec(mountpoint="/boot/efi", fstype="efi", size=20,
                                maxSize=200, grow=True, weight=self.weight(fstype="efi")))

        return ret

    def weight(self, fstype=None, mountpoint=None):
        if fstype and fstype == "efi" or mountpoint and mountpoint == "/boot/efi":
            return 5000
        elif mountpoint and mountpoint == "/boot":
            return 2000
        else:
            return 0

class Alpha(Platform):
    _diskLabelType = parted.diskType["bsd"]

    def checkBootRequest(self, req):
        errors = Platform.checkBootRequest(self, req)

        if not req or not req.disk:
            return errors

        disk = req.disk.format.partedDisk

        # Check that we're a BSD disk label
        if not disk.type == self._diskLabelType.name:
            errors.append(_("%s must have a bsd disk label.") % req.disk.name)

        # The first free space should start at the beginning of the drive and
        # span for a megabyte or more.
        free = disk.getFirstPartition()
        while free:
            if free.type & parted.PARTITION_FREESPACE:
                break

            free = free.nextPartition()

        if not free or free.geoemtry.start != 1L or free.getSize(unit="MB") < 1:
            errors.append(_("The disk %s requires at least 1MB of free space at the beginning.") % req.disk.name)

        return errors

class IA64(EFI):
    _packages = ["elilo"]

    def __init__(self, anaconda):
        EFI.__init__(self, anaconda)

class PPC(Platform):
    _bootFSTypes = ["ext4", "ext3", "ext2"]
    _packages = ["yaboot"]
    _ppcMachine = iutil.getPPCMachine()
    _supportsMdRaidBoot = True

    @property
    def ppcMachine(self):
        return self._ppcMachine

class IPSeriesPPC(PPC):
    _minBootPartSize = 4
    _maxBootPartSize = 10

    def bootDevice(self):
        bootDev = None

        # We want the first PReP partition.
        for device in self.anaconda.id.storage.partitions:
            if device.format.type == "prepboot":
                bootDev = device
                break

        return bootDev

    def bootloaderChoices(self, bl):
        ret = {}

        bootDev = self.bootDevice()
        if not bootDev:
            return ret

        if bootDev.type == "mdarray":
            ret["boot"] = (bootDev.name, N_("RAID Device"))
            ret["mbr"] = (bl.drivelist[0], N_("Master Boot Record (MBR)"))
        else:
            ret["boot"] = (bootDev.name, N_("PPC PReP Boot"))

        return ret

    def checkBootRequest(self, req):
        errors = PPC.checkBootRequest(self, req)

        bootPart = getattr(req, "partedPartition", None)
        if not bootPart:
            return errors

        # All of the above just checks the PPC PReP boot partitions.  We still
        # need to make sure that whatever /boot is on also meets these criteria.
        if req == self.bootDevice():
            # However, this check only applies to prepboot.
            if bootPart.geometry.end * bootPart.geometry.device.sectorSize / (1024.0 * 1024) > 4096:
                errors.append(_("The boot partition must be within the first 4MB of the disk."))

            try:
                req = self.anaconda.id.storage.mountpoints["/boot"]
            except KeyError:
                req = self.anaconda.id.storage.rootDevice

            return errors + self.checkBootRequest(req)
        else:
            return errors

    def setDefaultPartitioning(self):
        ret = PPC.setDefaultPartitioning(self)
        ret.append(PartSpec(fstype="PPC PReP Boot", size=4,
                            weight=self.weight(fstype="prepboot")))
        return ret

    def weight(self, fstype=None, mountpoint=None):
        if fstype and fstype == "prepboot":
            return 5000
        elif mountpoint and mountpoint == "/boot":
            return 2000
        else:
            return 0

class NewWorldPPC(PPC):
    _diskLabelType = parted.diskType["mac"]
    _minBootPartSize = (800.00 / 1024.00)
    _maxBootPartSize = 1

    def bootDevice(self):
        bootDev = None

        for part in self.anaconda.id.storage.partitions:
            if part.format.type == "appleboot" and self.validBootPartSize(part.size):
                bootDev = part
                # if we're only picking one, it might as well be the first
                break

        return bootDev

    def bootloaderChoices(self, bl):
        ret = {}

        bootDev = self.bootDevice()
        if not bootDev:
            return ret

        if bootDev.type == "mdarray":
            ret["boot"] = (bootDev.name, N_("RAID Device"))
            ret["mbr"] = (bl.drivelist[0], N_("Master Boot Record (MBR)"))
        else:
            ret["boot"] = (bootDev.name, N_("Apple Bootstrap"))
            for (n, device) in enumerate(self.anaconda.id.storage.partitions):
                if device.format.type == "appleboot" and device.path != bootDev.path:
                    ret["boot%d" % n] = (device.path, N_("Apple Bootstrap"))

        return ret

    def checkBootRequest(self, req):
        errors = PPC.checkBootRequest(self, req)

        if not req or not req.disk:
            return errors

        disk = req.disk.format.partedDisk

        # Check that we're a Mac disk label
        if not disk.type == self._diskLabelType.name:
            errors.append(_("%s must have a mac disk label.") % req.disk.name)

        # All of the above just checks the appleboot partitions.  We still
        # need to make sure that whatever /boot is on also meets these criteria.
        if req == self.bootDevice():
            try:
                req = self.anaconda.id.storage.mountpoints["/boot"]
            except KeyError:
                req = self.anaconda.id.storage.rootDevice

            return errors + self.checkBootRequest(req)
        else:
            return errors

    def setDefaultPartitioning(self):
        ret = Platform.setDefaultPartitioning(self)
        ret.append(PartSpec(fstype="Apple Bootstrap", size=1, maxSize=1,
                            weight=self.weight(fstype="appleboot")))
        return ret

    def weight(self, fstype=None, mountpoint=None):
        if fstype and fstype == "appleboot":
            return 5000
        elif mountpoint and mountpoint == "/boot":
            return 2000
        else:
            return 0

class PS3(PPC):
    _diskLabelType = parted.diskType["msdos"]

    def __init__(self, anaconda):
        PPC.__init__(self, anaconda)

class S390(Platform):
    _packages = ["s390utils"]

    def __init__(self, anaconda):
        Platform.__init__(self, anaconda)

    def diskLabelType(self, deviceType):
        """Return the disk label type as a parted.DiskType."""
        if deviceType == parted.DEVICE_DASD:
            return parted.diskType["dasd"]
        else:
            return Platform.diskLabelType(self, deviceType)

class Sparc(Platform):
    _diskLabelType = parted.diskType["sun"]

    @property
    def minimumSector(self, disk):
        (cylinders, heads, sector) = disk.device.biosGeometry
        start = long(sectors * heads)
        start /= long(1024 / disk.device.sectorSize)
        return start+1

class X86(EFI):
    _bootFSTypes = ["ext3", "ext4", "ext2"]
    _packages = ["grub"]
    _supportsMdRaidBoot = True

    def __init__(self, anaconda):
        EFI.__init__(self, anaconda)

        if self.isEfi:
            self._diskLabelType = parted.diskType["gpt"]
        else:
            self._diskLabelType = parted.diskType["msdos"]

    def bootDevice(self):
        if self.isEfi:
            return EFI.bootDevice(self)
        else:
            return Platform.bootDevice(self)

    def bootloaderChoices(self, bl):
        if self.isEfi:
            return EFI.bootloaderChoices(self, bl)

        bootDev = self.bootDevice()
        ret = {}

        if not bootDev:
            return {}

        if bootDev.type == "mdarray":
            ret["boot"] = (bootDev.name, N_("RAID Device"))
            ret["mbr"] = (bl.drivelist[0], N_("Master Boot Record (MBR)"))
        else:
            ret["boot"] = (bootDev.name, N_("First sector of boot partition"))
            ret["mbr"] = (bl.drivelist[0], N_("Master Boot Record (MBR)"))

        return ret

    @property
    def maxBootPartSize(self):
        if self.isEfi:
            return EFI._maxBootPartSize
        else:
            return Platform._maxBootPartSize

    @property
    def minBootPartSize(self):
        if self.isEfi:
            return EFI._minBootPartSize
        else:
            return Platform._minBootPartSize

    def setDefaultPartitioning(self):
        if self.isEfi:
            return EFI.setDefaultPartitioning(self)
        else:
            return Platform.setDefaultPartitioning(self)

def getPlatform(anaconda):
    """Check the architecture of the system and return an instance of a
       Platform subclass to match.  If the architecture could not be determined,
       raise an exception."""
    if iutil.isAlpha():
        return Alpha(anaconda)
    elif iutil.isIA64():
        return IA64(anaconda)
    elif iutil.isPPC():
        ppcMachine = iutil.getPPCMachine()

        if (ppcMachine == "PMac" and iutil.getPPCMacGen() == "NewWorld"):
            return NewWorldPPC(anaconda)
        elif ppcMachine in ["iSeries", "pSeries"]:
            return IPSeriesPPC(anaconda)
        elif ppcMachine == "PS3":
            return PS3(anaconda)
        else:
            raise SystemError, "Unsupported PPC machine type"
    elif iutil.isS390():
        return S390(anaconda)
    elif iutil.isSparc():
        return Sparc(anaconda)
    elif iutil.isX86():
        return X86(anaconda)
    else:
        raise SystemError, "Could not determine system architecture."
