# udev.py
# Python module for querying the udev database for device information.
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
#                    Chris Lumens <clumens@redhat.com>
#

import iutil
import os
import string

import pyudev
global_udev = pyudev.Udev()

import logging
log = logging.getLogger("storage")

def udev_enumerate_devices(deviceClass="block"):
    top_dir = "/sys/class/%s" % deviceClass
    devices = []
    for dev_name in os.listdir(top_dir):
        full_path = os.path.join(top_dir, dev_name)
        link_ref = os.readlink(full_path)
        real_path = os.path.join(top_dir, link_ref)
        if deviceClass == "block" and string.find (real_path, "devices/virtual/block") > 0:
            log.info("MeeGo: drop virtual block device %s", dev_name)
            continue
        sysfs_path = os.path.normpath(real_path)
        devices.append(sysfs_path[4:])
    return devices

def udev_get_device(sysfs_path):
    if not os.path.exists("/sys%s" % sysfs_path):
        log.debug("%s does not exist" % sysfs_path)
        return None

    # XXX we remove the /sys part when enumerating devices,
    # so we have to prepend it when creating the device
    dev = global_udev.create_device("/sys" + sysfs_path)

    if dev:
        dev["name"] = dev.sysname
        dev["symlinks"] = dev["DEVLINKS"]
        dev["sysfs_path"] = sysfs_path

        # now add in the contents of the uevent file since they're handy
        dev = udev_parse_uevent_file(dev)

    return dev

def udev_get_devices(deviceClass="block"):
    udev_settle(timeout=30)
    entries = []
    for path in udev_enumerate_devices(deviceClass):
        entry = udev_get_device(path)
        if entry:
            entries.append(entry)
    return entries

def udev_parse_uevent_file(dev):
    path = os.path.normpath("/sys/%s/uevent" % dev['sysfs_path'])
    if not os.access(path, os.R_OK):
        return dev

    with open(path) as f:
        for line in f.readlines():
            (key, equals, value) = line.strip().partition("=")
            if not equals:
                continue

            dev[key] = value

    return dev

def udev_settle(timeout=None):
    argv = ["settle"]
    if timeout:
        argv.append("--timeout=%d" % int(timeout))

    iutil.execWithRedirect("udevadm", argv, stderr="/dev/null", searchPath=1)

def udev_trigger(subsystem=None, action="add"):
    argv = ["trigger", "--action=%s" % action]
    if subsystem:
        argv.append("--subsystem-match=%s" % subsystem)

    iutil.execWithRedirect("udevadm", argv, stderr="/dev/null", searchPath=1)
