#
# meego.py
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

from installclass import BaseInstallClass
from constants import *
from product import *
from filer import *
from flags import flags
import os, types
import iutil

import gettext
_ = lambda x: gettext.ldgettext("anaconda", x)

import installmethod
#import yuminstall

#import rpmUtils.arch

class InstallClass(BaseInstallClass):
    # name has underscore used for mnemonics, strip if you dont need it
    id = "meego"
    name = N_("_MeeGo")
    _description = N_("The default installation of %s includes a set of "
                    "software applicable for general internet usage. "
                    "What additional tasks would you like your system "
                    "to include support for?") 
    _descriptionFields = (productName,)
    sortPriority = 10000
    if productName.startswith("Red Hat Enterprise"):
        hidden = 1
    
    # defaultdesktop = moblin
    if flags.moblindesktop:
        DefaultDesktop = "moblin-desktop"
    # defaultdesktop = gnome
    else:
        DefaultDesktop = "gnome-desktop"
    tasks = [(N_("Office and Productivity"), ["core", "base", "base-x", DefaultDesktop,"base-hardware-support", "moblin-foundation", "base-desktop"]),
             (N_("Software Development"), ["development-libs", "development-tools","x-software-development", "moblin-foundation-development"])]


    bugFiler = BugzillaFiler(bugUrl="https://bugzilla.meego.com/xmlrpc.cgi",
                             develVersion="leaky", defaultProduct="MeeGo")

    def getPackagePaths(self, uri):
        if not type(uri) == types.ListType:
            uri = [uri,]

        return {'Installation Repo': uri}

    def setInstallData(self, anaconda):
	BaseInstallClass.setInstallData(self, anaconda)
        BaseInstallClass.setDefaultPartitioning(self, anaconda.id.storage,
                                                    anaconda.platform)

    def setGroupSelection(self, anaconda):
        BaseInstallClass.setGroupSelection(self, anaconda)
        map(lambda x: anaconda.backend.selectGroup(x), ["core"])

    def setSteps(self, anaconda):
	BaseInstallClass.setSteps(self, anaconda);
	anaconda.dispatch.skipStep("partition")

    def getBackend(self):
        if flags.livecdInstall:
            import livecd
            return livecd.LiveCDCopyBackend
        else:
            return yuminstall.YumBackend

    def __init__(self):
	BaseInstallClass.__init__(self)
