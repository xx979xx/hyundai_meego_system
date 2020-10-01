#
# livecd.py: An anaconda backend to do an install from a live CD image
#
# The basic idea is that with a live CD, we already have an install
# and should be able to just copy those bits over to the disk.  So we dd
# the image, move things to the "right" filesystem as needed, and then
# resize the rootfs to the size of its container.
#
# Copyright (C) 2007  Red Hat, Inc.  All rights reserved.
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
# Author(s): Jeremy Katz <katzj@redhat.com>
#

import os, sys
import stat
import shutil
import time
import subprocess
import storage

import selinux

from flags import flags
from constants import *

import gettext
_ = lambda x: gettext.ldgettext("anaconda", x)

import backend
import isys
import iutil
import users

import packages

import logging
log = logging.getLogger("anaconda")

class Error(EnvironmentError):
    pass
def copytree(src, dst, symlinks=False, preserveOwner=False,
             preserveSelinux=False):
    def tryChown(src, dest):
        try:
            os.chown(dest, os.stat(src)[stat.ST_UID], os.stat(src)[stat.ST_GID])
        except OverflowError:
            log.error("Could not set owner and group on file %s" % dest)

    def trySetfilecon(src, dest):
        try:
            selinux.lsetfilecon(dest, selinux.lgetfilecon(src)[1])
        except:
            log.error("Could not set selinux context on file %s" % dest)

    # copy of shutil.copytree which doesn't require dst to not exist
    # and which also has options to preserve the owner and selinux contexts
    names = os.listdir(src)
    if not os.path.isdir(dst):
        os.makedirs(dst)
    errors = []
    for name in names:
        srcname = os.path.join(src, name)
        dstname = os.path.join(dst, name)
        try:
            if symlinks and os.path.islink(srcname):
                linkto = os.readlink(srcname)
                os.symlink(linkto, dstname)
                if preserveSelinux:
                    trySetfilecon(srcname, dstname)
            elif os.path.isdir(srcname):
                copytree(srcname, dstname, symlinks, preserveOwner, preserveSelinux)
            else:
                shutil.copyfile(srcname, dstname)
                if preserveOwner:
                    tryChown(srcname, dstname)

                if preserveSelinux:
                    trySetfilecon(srcname, dstname)
                shutil.copystat(srcname, dstname)
        except (IOError, os.error), why:
            errors.append((srcname, dstname, str(why)))
        # catch the Error from the recursive copytree so that we can
        # continue with other files
        except Error, err:
            errors.extend(err.args[0])
    try:
        if preserveOwner:
            tryChown(src, dst)
        if preserveSelinux:
            trySetfilecon(src, dst)
        shutil.copystat(src, dst)
    except OSError as e:
        errors.extend((src, dst, e.strerror))
    if errors:
        raise Error, errors

class LiveCDCopyBackend(backend.AnacondaBackend):
    def __init__(self, anaconda):
        backend.AnacondaBackend.__init__(self, anaconda)
        flags.livecdInstall = True
        self.supportsUpgrades = False
        self.supportsPackageSelection = False
        self.skipFormatRoot = True

        self.osimg = anaconda.methodstr[8:]
        if not stat.S_ISBLK(os.stat(self.osimg)[stat.ST_MODE]):
            anaconda.intf.messageWindow(_("Unable to find image"),
                               _("The given location isn't a valid %s "
                                 "live CD to use as an installation source.")
                               %(productName,), type = "custom",
                               custom_icon="error",
                               custom_buttons=[_("Exit installer")])
            sys.exit(0)
        #self.rootFsType = isys.readFSType(self.osimg)
        self.rootFsType = "btrfs"

    def _getLiveBlockDevice(self):
        return os.path.normpath(self.osimg)

    def _getLiveSize(self):
        def parseField(output, field):
            for line in output.split("\n"):
                if line.startswith(field + ":"):
                    return line[len(field) + 1:].strip()
            raise KeyError("Failed to find field '%s' in output" % field)

        output = subprocess.Popen(['/sbin/dumpe2fs', '-h', self.osimg],
                                  stdout=subprocess.PIPE,
                                  stderr=open('/dev/null', 'w')
                                  ).communicate()[0]
        blkcnt = int(parseField(output, "Block count"))
        blksize = int(parseField(output, "Block size"))
        return blkcnt * blksize

    def _getLiveSizeMB(self):
        return self._getLiveSize() / 1048576

    def _unmountNonFstabDirs(self, anaconda):
        # unmount things that aren't listed in /etc/fstab.  *sigh*
        dirs = []
        if flags.selinux:
            dirs.append("/selinux")
        for dir in dirs:
            try:
                isys.umount("%s/%s" %(anaconda.rootPath,dir), removeDir = False)
            except Exception, e:
                log.error("unable to unmount %s: %s" %(dir, e))

    def postAction(self, anaconda):
        self._unmountNonFstabDirs(anaconda)
        try:
            anaconda.id.storage.umountFilesystems(swapoff = False)
            #os.rmdir(anaconda.rootPath)
        except Exception, e:
            log.error("Unable to unmount filesystems: %s" % e) 

    def doPreInstall(self, anaconda):
        if anaconda.dir == DISPATCH_BACK:
            self._unmountNonFstabDirs(anaconda)
            return
        anaconda.id.storage.umountFilesystems(swapoff = False)
         
    def _getUsedSize(self, fs):
        output = subprocess.Popen(['df', fs],
                                  stdout=subprocess.PIPE,
                                  stderr=open('/dev/null', 'w')
                                  ).communicate()[0]
        for line in output.split("\n"):
            if line.split()[5] == fs:
                return line.split()[2]
        return 0

    def doInstall(self, anaconda):
        log.info("Preparing to install packages")
        if flags.test:
            log.info("Test mode - not performing install")
            return

        progress = anaconda.id.instProgress
        progress.set_label(_("Copying live image to hard drive."))
        progress.processEvents()

        osimg = self._getLiveBlockDevice() # the real image
        
        rootDevice = anaconda.id.storage.rootDevice
        rootDevice.setup()
        rootfs = rootDevice.path

        if rootDevice.format.type == "btrfs":
            rootfs_src = "/media/loop"
            rootfs_dst = "/mnt/sysimage"
            log.info ("The root fstype is btrfs, mount and copy the rootfs instead of dd")            
            if not os.path.isdir(rootfs_src):
                os.makedirs(rootfs_src)
            if not os.path.isdir(rootfs_dst):
                os.makedirs(rootfs_dst)

            try:
                isys.mount(osimg, rootfs_src, fstype="ext3", readOnly=True, options = "loop")  
                isys.mount(rootfs, rootfs_dst, fstype="btrfs", options="nodatasum")
            except:
                rc = anaconda.intf.messageWindow(_("Error"),
                        _("There was an error installing the live image to "
                          "your hard drive: mount root filesystem failure. \n\nIf you "
                          "exit, your system will be left in an inconsistent "
                          "state that will require reinstallation."),
                        type="custom", custom_icon="error",
                        custom_buttons=[_("_Exit installer")])

                if rc == 0:
                    sys.exit(0)

            out = open("/dev/tty5", "w")
            size = int(self._getUsedSize(rootfs_src))
            log.info ("Get used size : %d" %(size,))

            cmd = ['cp -af /media/loop/* /mnt/sysimage']
            try:
                proc = subprocess.Popen(cmd, stdout=out, stderr=out, shell=True)
                rc = proc.poll()
                while rc is None:
                    time.sleep(3)
                    rc = proc.poll()
                    copied = int(self._getUsedSize(rootfs_dst))
                    if copied > 0:
                        progress.set_fraction(pct = copied / float(size))
                        progress.processEvents()
                         
            except Exception, e:
                log.error("Failed to copy %s: %s" %(srcname, e))
                rc = anaconda.intf.messageWindow(_("Error"),
                     _("There was an error copying the live image to "
                      "your hard drive. This could be due to bad media. "
                      "Please verify your installation media.\n\nIf you "
                      "exit, your system will be left in an inconsistent "
                      "state that will require reinstallation."),
                    type="custom", custom_icon="error",
                    custom_buttons=[_("_Exit installer")])

                if rc == 0:
                    sys.exit(0)

            progress.set_fraction(pct = 1.0)
            progress.processEvents()
            time.sleep(2)
            
            anaconda.id.instProgress = None   
            return

        # set the rootfs to have the right type.  this lets things work
        # given ext2 or ext3 (and in the future, ext4)
        # FIXME: should we try to migrate if there isn't a match?
        rootfd = os.open(rootDevice.path, os.O_WRONLY)
        osfd = os.open(osimg, os.O_RDONLY)
        readamt = 1024 * 1024 * 8 # 8 megs at a time
        size = self._getLiveSize()
        copied = 0
        while copied < size:
            try:
                buf = os.read(osfd, readamt)
                written = os.write(rootfd, buf)
            except:
                rc = anaconda.intf.messageWindow(_("Error"),
                        _("There was an error installing the live image to "
                          "your hard drive. This could be due to bad media. "
                          "Please verify your installation media.\n\nIf you "
                          "exit, your system will be left in an inconsistent "
                          "state that will require reinstallation."),
                        type="custom", custom_icon="error",
                        custom_buttons=[_("_Exit installer"), _("_Retry")])

                if rc == 0:
                    sys.exit(0)
                else:
                    os.lseek(osfd, 0, 0)
                    os.lseek(rootfd, 0, 0)
                    copied = 0
                    continue

            if (written < readamt) and (written < len(buf)):
                raise RuntimeError, "error copying filesystem!"
            copied += written
            progress.set_fraction(pct = copied / float(size))
            progress.processEvents()

        os.close(osfd)
        os.close(rootfd)

        anaconda.id.instProgress = None

    def _doFilesystemMangling(self, anaconda):
        log.info("doing post-install fs mangling")
        wait = anaconda.intf.waitWindow(_("Doing post-installation"),
                                        _("Performing post-installation filesystem changes.  This may take several minutes..."))

        # resize rootfs first, since it is 100% full due to genMinInstDelta
        self._resizeRootfs(anaconda, wait)

        rootDevice = anaconda.id.storage.rootDevice
        ##Fixme: maybe need to do it for btrfs
        if rootDevice.format.type == "btrfs":
            log.info ("The root fsystem is btrfs, mount filesystem with skiproot = true")
            anaconda.id.storage.mountFilesystems(skipRoot=True)
        else:
            # remount filesystems
            anaconda.id.storage.mountFilesystems()

        # restore the label of / to what we think it is
        rootDevice = anaconda.id.storage.rootDevice
        rootDevice.setup()
        # ensure we have a random UUID on the rootfs
        # FIXME: this should be abstracted per filesystem type
        iutil.execWithRedirect("tune2fs",
                               ["-U",
                                "random",
                                rootDevice.path],
                               stdout="/dev/tty5",
                               stderr="/dev/tty5",
                               searchPath = 1)
        # and now set the uuid in the storage layer
        rootDevice.updateSysfsPath()
        iutil.notify_kernel("/sys%s" %rootDevice.sysfsPath)
        storage.udev.udev_settle()
        rootDevice.updateSysfsPath()
        info = storage.udev.udev_get_block_device(rootDevice.sysfsPath)
        rootDevice.format.uuid = storage.udev.udev_device_get_uuid(info)
        log.info("reset the rootdev (%s) to have a uuid of %s" %(rootDevice.sysfsPath, rootDevice.format.uuid))
 

        # for any filesystem that's _not_ on the root, we need to handle
        # moving the bits from the livecd -> the real filesystems.
        # this is pretty distasteful, but should work with things like
        # having a separate /usr/local
        
        # now create a tree so that we know what's mounted under where
        fsdict = {"/": []}
        for mount in sorted(anaconda.id.storage.mountpoints.keys()):
            entry = anaconda.id.storage.mountpoints[mount]
            tocopy = entry.format.mountpoint
            if tocopy.startswith("/mnt") or tocopy == "swap":
                continue
            keys = sorted(fsdict.keys(), reverse = True)
            for key in keys:
                if tocopy.startswith(key):
                    fsdict[key].append(entry)
                    break
            fsdict[tocopy] = []
        log.debug("mangling dict looks like %s" %(fsdict,))

        
        # and now let's do the real copies; and we don't want to copy /!
        copied = ["/"]
        for tocopy in sorted(fsdict.keys()):
            if tocopy in copied:
                continue
            copied.append(tocopy)
            copied.extend(map(lambda x: x.format.mountpoint, fsdict[tocopy]))
            entry = anaconda.id.storage.mountpoints[tocopy]

            # FIXME: all calls to wait.refresh() are kind of a hack... we
            # should do better about not doing blocking things in the
            # main thread.  but threading anaconda is a job for another
            # time.
            wait.refresh()

            # unmount subdirs + this one and then remount under /mnt
            for e in fsdict[tocopy] + [entry]:
                e.format.teardown()
            for e in [entry] + fsdict[tocopy]:
                e.format.setup(chroot=anaconda.rootPath + "/mnt")              

            copytree("%s/%s" %(anaconda.rootPath, tocopy),
                     "%s/mnt/%s" %(anaconda.rootPath, tocopy), True, True,
                     flags.selinux)
            shutil.rmtree("%s/%s" %(anaconda.rootPath, tocopy))
            wait.refresh()

            # mount it back in the correct place
            for e in fsdict[tocopy] + [entry]:
                e.format.teardown()
                try:
                    os.rmdir("%s/mnt/%s" %(anaconda.rootPath,
                                           e.format.mountpoint))
                except OSError as e:
                    log.debug("error removing %s" %(tocopy,))
            for e in [entry] + fsdict[tocopy]:                
                e.format.setup(chroot=anaconda.rootPath)        

            wait.refresh()

        # ensure that non-fstab filesystems are mounted in the chroot
        if flags.selinux:
            try:
                isys.mount("/selinux", anaconda.rootPath + "/selinux", "selinuxfs")
            except Exception, e:
                log.error("error mounting selinuxfs: %s" %(e,))

        wait.pop()

    def _resizeRootfs(self, anaconda, win = None):
        log.info("going to do resize")
        rootDevice = anaconda.id.storage.rootDevice

        ##Fixme: maybe need to do it for btrfs
        if rootDevice.format.type == "btrfs":
            log.info ("The root fsystem is btrfs, skip the resize step")
            return

        # FIXME: we'd like to have progress here to give an idea of
        # how long it will take.  or at least, to give an indefinite
        # progress window.  but, not for this time
        cmd = ["resize2fs", rootDevice.path, "-p"]
        # set the resizetarget size if exists, fix bug #4663
        #try:
        #    resizetarget = r.resizeTargetSize;
        #    if resizetarget:
        #        log.debug("get resizetarget size %s" %(resizetarget,))
        #        cmd = ["resize2fs", "/dev/%s" %(rootdev,), "-p", "%sM" %(resizetarget,)]
        #except Exception, e:
        #    log.error("failed to get resizetarget: %s" %(e,))

        out = open("/dev/tty5", "w")
        proc = subprocess.Popen(cmd, stdout=out, stderr=out)
        rc = proc.poll()
        while rc is None:
            win and win.refresh()
            time.sleep(0.5)
            rc = proc.poll()

        if rc:
            log.error("error running resize2fs; leaving filesystem as is")


    def doPostInstall(self, anaconda):
        import rpm

        self._doFilesystemMangling(anaconda)

        # setup /etc/rpm for the post-install environment
        iutil.writeRpmPlatform(anaconda.rootPath)

        # maybe heavy handed, but it'll do
        #if os.path.exists(anaconda.rootPath + "/usr/bin/rhgb") or os.path.exists(anaconda.rootPath + "/usr/bin/plymouth"):
        #    anaconda.id.bootloader.args.append("rhgb quiet")
        #Moblin: add quiet to boot options
        anaconda.id.bootloader.args.append("quiet")
        anaconda.id.bootloader.args.append("vga=current")
        
        #if os.path.exists(anaconda.rootPath + "/usr/sbin/gdm") or os.path.exists(anaconda.rootPath + "/usr/bin/kdm"):
        # Moblin Fixme: when package installation is supported, the run level should be 
        # set dynamically by checking whether X is installed or not.
        anaconda.id.desktop.setDefaultRunLevel(5)

        """Delete moblin/meego user only if it is a non-recovery mode and firstboot is enabled"""
        proc_cmdline_fp = open("/proc/cmdline", "r")
        cmdline = proc_cmdline_fp.readline()
        proc_cmdline_fp.close()
        if cmdline.find(" recover") == -1 and os.path.exists("/usr/sbin/firstboot"):
            # Delete the user "moblin" first
            usersUtil = users.Users()
            if not usersUtil.deleteUser("meego", root=anaconda.rootPath):
                log.error("warning: failed to delete user - 'meego'.")
           
            if os.path.exists("/home/moblin"):
                log.info("The user moblin exists, delete it")
                if not usersUtil.deleteUser("moblin", root=anaconda.rootPath):
                    log.error("warning: failed to delete user - 'moblin'.")

        
        storage.writeEscrowPackets(anaconda)

        packages.rpmSetupGraphicalSystem(anaconda)
        
        # now write out the "real" fstab and mtab
        log.info("Write out the real fstab and mtab")
        anaconda.id.storage.write(anaconda.rootPath)
        f = open(anaconda.rootPath + "/etc/mtab", "w+")
        f.write(anaconda.id.storage.mtab)
        f.close()        
        
        # copy over the modprobe.conf
        if os.path.exists("/etc/modprobe.conf"):
            shutil.copyfile("/etc/modprobe.conf", 
                            anaconda.rootPath + "/etc/modprobe.conf")

        # rebuild the initrd(s)
        vers = self.kernelVersionList(anaconda.rootPath)
        for (n, arch, tag) in vers:
            packages.recreateInitrd(n, anaconda.rootPath)

        # Clean work: delete unused packages
        backend.AnacondaBackend.deleteUnusedPackages(self, anaconda)


    def writeConfiguration(self):
        pass

    def kernelVersionList(self, rootPath = "/"):
        return packages.rpmKernelVersionList(rootPath)

    def getMinimumSizeMB(self, part):
        if part == "/":
            return self._getLiveSizeMB()
        return 0

    def doBackendSetup(self, anaconda):
        # ensure there's enough space on the rootfs
        # FIXME: really, this should be in the general sanity checking, but
        # trying to weave that in is a little tricky at present.
        ossize = self._getLiveSizeMB()
        slash = anaconda.id.storage.rootDevice
        if slash.size < ossize:
            rc = anaconda.intf.messageWindow(_("Error"),
                                        _("The root filesystem you created is "
                                          "not large enough for this live "
                                          "image (%.2f MB required).") % ossize,
                                        type = "custom",
                                        custom_icon = "error",
                                        custom_buttons=[_("_Back"),
                                                        _("_Exit installer")])
            if rc == 0:
                return DISPATCH_BACK
            else:
                sys.exit(1)
        
    # package/group selection doesn't apply for this backend
    def groupExists(self, group):
        pass
    def selectGroup(self, group, *args):
        pass
    def deselectGroup(self, group, *args):
        pass
    def selectPackage(self, pkg, *args):
        pass
    def deselectPackage(self, pkg, *args):
        pass
    def packageExists(self, pkg):
        return True
    def getDefaultGroups(self, anaconda):
        return []
    def writePackagesKS(self, f, anaconda):
        pass
