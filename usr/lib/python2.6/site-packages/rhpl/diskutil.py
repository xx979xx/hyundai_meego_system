#
# diskutil.py - handling of various disk related functions
#
# Copyright 2002 Red Hat, Inc.
#
# This software may be freely redistributed under the terms of the GNU
# library public license.
#
# You should have received a copy of the GNU Library Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#


import os,sys
import _diskutil

def mount(device, location, fstype = "ext2", readOnly = 0):
    location = os.path.normpath(location)
    rc = _diskutil.mount(fstype, device, location, readOnly)

    try:
        if readOnly == 0:
            ro = "ro"
        else:
            ro = "rw"
        newline = "%s %s %s %s 0 0\n" %(device, location, fstype, ro)

        f = open('/etc/mtab', 'a')
        f.write(newline)
        f.close()
    except:
        pass
    
    return rc

def umount(what, removeDir = 0):
    what = os.path.normpath(what)

    if not os.path.isdir(what):
        raise ValueError, "diskutil.umount() can only unmount by mount point"

    rc = _diskutil.umount(what)

    try:
        f = open('/etc/mtab', 'r')
        lines = f.readlines()
        f.close()

        f = open('/etc/mtab', 'w')
        for line in lines:
            (dev, mntpt, foo) = line.split(' ', 2)
            if mntpt == what:
                continue
            f.write(line)
        f.close()
    except:
        pass

    # FIXME: probably racy
    if removeDir and os.path.isdir(what):
        os.rmdir(what)

    return rc

def ejectCdrom(device = "/dev/cdrom"):
    fd = os.open(device, os.O_RDONLY|os.O_NONBLOCK)

    # best effort
    try:
        _diskutil.ejectcdrom(fd)
    except SystemError:
        pass

    os.close(fd)

def losetup(device, file, readOnly = 0):
    if readOnly:
	mode = os.O_RDONLY
    else:
	mode = os.O_RDWR
    targ = os.open(file, mode)
    loop = os.open(device, mode)
    try:
        _diskutil.losetup(loop, targ, file)
    finally:
        os.close(loop)
        os.close(targ)

def unlosetup(device):
    loop = os.open(device, os.O_RDONLY)
    try:
        _diskutil.unlosetup(loop)
    finally:
        os.close(loop)

def getUnusedLoop():
    dev = _diskutil.findunusedloopdev()
    if dev is None:
        raise SystemError, "Unable to find loop device"
    return dev
