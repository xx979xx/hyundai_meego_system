#
# flags.py: global anaconda flags
#
# Copyright (C) 2001  Red Hat, Inc.  All rights reserved.
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

import os
import shlex
from constants import *

# A lot of effort, but it only allows a limited set of flags to be referenced
class Flags:

    def __getattr__(self, attr):
        if self.__dict__['flags'].has_key(attr):
            return self.__dict__['flags'][attr]

        raise AttributeError, attr

    def __setattr__(self, attr, val):
        if self.__dict__['flags'].has_key(attr):
            self.__dict__['flags'][attr] = val
        else:
            raise AttributeError, attr

    def get(self, attr, val=None):
        if self.__dict__['flags'].has_key(attr):
            return self.__dict__['flags'][attr]
        else:
            return val

    def createCmdlineDict(self):
        cmdlineDict = {}
        cmdline = open("/proc/cmdline", "r").read().strip()

        # if the BOOT_IMAGE contains a space, pxelinux will strip one of the
        # quotes leaving one at the end that shlex doesn't know what to do
        # with
        if cmdline.find("BOOT_IMAGE=") and cmdline.endswith('"'):
            cmdline = cmdline.replace("BOOT_IMAGE=", "BOOT_IMAGE=\"")

        lst = shlex.split(cmdline)

        for i in lst:
            try:
                (key, val) = i.split("=", 1)
            except:
                key = i
                val = None

            cmdlineDict[key] = val

        return cmdlineDict
    
    def __init__(self):
        self.__dict__['flags'] = {}
        self.__dict__['flags']['test'] = 0
        self.__dict__['flags']['rootpath'] = 0
        self.__dict__['flags']['livecdInstall'] = 0
        self.__dict__['flags']['ibft'] = 1
        self.__dict__['flags']['iscsi'] = 0
        self.__dict__['flags']['serial'] = 0
        self.__dict__['flags']['setupFilesystems'] = 1
        self.__dict__['flags']['autostep'] = 0
        self.__dict__['flags']['autoscreenshot'] = 0
        self.__dict__['flags']['usevnc'] = 0
        self.__dict__['flags']['vncquestion'] = True
        self.__dict__['flags']['mpath'] = 0
        self.__dict__['flags']['dmraid'] = 0
        self.__dict__['flags']['raid'] = 0
        self.__dict__['flags']['selinux'] = 0
        self.__dict__['flags']['debug'] = 0
        self.__dict__['flags']['targetarch'] = None
        self.__dict__['flags']['updateRpmPlatform'] = False
        self.__dict__['flags']['cmdline'] = self.createCmdlineDict()
        self.__dict__['flags']['useIPv4'] = True
        self.__dict__['flags']['useIPv6'] = True
        self.__dict__['flags']['moblindesktop'] = True
        self.__dict__['flags']['grub'] = False
        self.__dict__['flags']['enablefirstboot'] = False
        self.__dict__['flags']['sshd'] = False
        # for non-physical consoles like some ppc and sgi altix,
        # we need to preserve the console device and not try to
        # do things like bogl on them.  this preserves what that
        # device is
        self.__dict__['flags']['virtpconsole'] = None

        if self.__dict__['flags']['cmdline'].has_key("selinux"):
            if self.__dict__['flags']['cmdline']["selinux"]:
                self.__dict__['flags']['selinux'] = 1
            else:
                self.__dict__['flags']['selinux'] = 0

        if self.__dict__['flags']['cmdline'].has_key("debug"):
            self.__dict__['flags']['debug'] = self.__dict__['flags']['cmdline']['debug']

        if self.__dict__['flags']['cmdline'].has_key("rpmarch"):
            self.__dict__['flags']['targetarch'] = self.__dict__['flags']['cmdline']['rpmarch']             

        if not os.path.exists("/selinux/load"):
            self.__dict__['flags']['selinux'] = 0

                
global flags
flags = Flags()
