# swap.py
# Python module for managing swap devices.
#
# Copyright (C) 2009  Red Hat, Inc.
#
# This copyrighted material is made available to anyone wishing to use,
# modify, copy, or redistribute it subject to the terms and conditions of
# the GNU General Public License v.2, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY expressed or implied, including the implied warranties of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
# Public License for more details.  You should have received a copy of the
# GNU General Public License along with this program; if not, write to the
# Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
# 02110-1301, USA.  Any Red Hat trademarks that are incorporated in the
# source code or documentation are not subject to the GNU General Public
# License and may only be used or replicated with the express permission of
# Red Hat, Inc.
#
# Red Hat Author(s): Dave Lehman <dlehman@redhat.com>
#

import resource

import iutil
import os

from ..errors import *

import gettext
_ = lambda x: gettext.ldgettext("anaconda", x)


def mkswap(device, label=''):
    argv = []
    if label:
        argv.extend(["-L", label])
    argv.append(device)

    rc = iutil.execWithRedirect("mkswap", argv,
                                stderr = "/dev/tty5",
                                stdout = "/dev/tty5",
                                searchPath=1)

    if rc:
        raise SwapError("mkswap failed for '%s'" % device)

def swapon(device, priority=None):
    pagesize = resource.getpagesize()
    buf = None
    sig = None

    if pagesize > 2048:
        num = pagesize
    else:
        num = 2048

    try:
        fd = os.open(device, os.O_RDONLY)
        buf = os.read(fd, num)
    except OSError:
        pass
    finally:
        try:
            os.close(fd)
        except (OSError, UnboundLocalError):
            pass

    if buf is not None and len(buf) == pagesize:
        sig = buf[pagesize - 10:]
        if sig == 'SWAP-SPACE':
            raise OldSwapError
        if sig == 'S1SUSPEND\x00' or sig == 'S2SUSPEND\x00':
            raise SuspendError

    if sig != 'SWAPSPACE2':
        raise UnknownSwapError

    argv = []
    if isinstance(priority, int) and 0 <= priority <= 32767:
        argv.extend(["-p", "%d" % priority])
    argv.append(device)
        
    rc = iutil.execWithRedirect("swapon",
                                argv,
                                stderr = "/dev/tty5",
                                stdout = "/dev/tty5",
                                searchPath=1)

    if rc:
        raise SwapError("swapon failed for '%s'" % device)

def swapoff(device):
    rc = iutil.execWithRedirect("swapoff", [device],
                                stderr = "/dev/tty5",
                                stdout = "/dev/tty5",
                                searchPath=1)

    if rc:
        raise SwapError("swapoff failed for '%s'" % device)

def swapstatus(device):
    lines = open("/proc/swaps").readlines()
    status = False
    for line in lines:
        if not line.strip():
            continue
            
        if line.split()[0] == device:
            status = True
            break

    return status

