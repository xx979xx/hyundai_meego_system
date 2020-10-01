#
# examine_gui.py: dialog to allow selection of a RHL installation to upgrade
#
# Copyright (C) 2000, 2001, 2002, 2003, 2004, 2005, 2006  Red Hat, Inc.
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

import gtk
import gui
from iw_gui import *
from pixmapRadioButtonGroup_gui import pixmapRadioButtonGroup
from constants import *
import upgrade
from flags import flags

import gettext
_ = lambda x: gettext.ldgettext("anaconda", x)

UPGRADE_STR = "upgrade"
REINSTALL_STR = "reinstall"

class UpgradeExamineWindow (InstallWindow):		

    windowTitle = N_("Upgrade Examine")

    def getNext (self):
        if self.doupgrade:
            upgrade.setSteps(self.anaconda)
            self.anaconda.id.setUpgrade(True)

	    rootfs = self.parts[self.upgradecombo.get_active()]
            self.anaconda.id.upgradeRoot = [(rootfs[0], rootfs[1])]
            self.anaconda.id.rootParts = self.parts

            self.anaconda.dispatch.skipStep("installtype", skip = 1)
            self.anaconda.id.upgrade = True
        else:
            self.anaconda.dispatch.skipStep("installtype", skip = 0)
            self.anaconda.id.upgrade = False
	
        return None

    def createUpgradeOption(self):
	r = pixmapRadioButtonGroup()
	r.addEntry(REINSTALL_STR,
                   _("_Install %s") %(productName,),
		   pixmap=gui.readImageFromFile("install.png"),
		   descr=_("Choose this option to freshly install your system. "                           "Existing software and data may be overwritten "
			   "depending on your configuration choices."))        
        
	r.addEntry(UPGRADE_STR,
                   _("_Upgrade an existing installation"),
		   pixmap=gui.readImageFromFile("upgrade.png"),
		   descr=_("Choose this option if you would like "
                           "to upgrade your existing %s system.  "
                           "This option preserves the "
                           "existing data on your drives.") %(productName,))
        
	return r

    def upgradeOptionsSetSensitivity(self, state):
	self.uplabel.set_sensitive(state)
	self.upgradecombo.set_sensitive(state)

    def optionToggled(self, widget, name):
	if name == UPGRADE_STR:
	    self.upgradeOptionsSetSensitivity(widget.get_active())
	    self.doupgrade = widget.get_active()

    #UpgradeExamineWindow tag = "upgrade"
    def getScreen (self, anaconda):
        self.anaconda = anaconda

	if self.anaconda.id.upgrade == None:
	    # this is the first time we've entered this screen
	    self.doupgrade = self.anaconda.dispatch.stepInSkipList("installtype")
	else:
	    self.doupgrade = self.anaconda.id.upgrade

        # we might get here after storage reset that obsoleted
        # root device objects we had found
        if not self.anaconda.id.rootParts:
            self.anaconda.id.rootParts = upgrade.findExistingRoots(self.anaconda,
                                                                   flags.cmdline.has_key("upgradeany"))
            upgrade.setUpgradeRoot(self.anaconda)

        self.parts = self.anaconda.id.rootParts 

        vbox = gtk.VBox (False, 10)
	vbox.set_border_width (8)

	r = self.createUpgradeOption()
        self.r = r

	b = self.r.render()
	if self.doupgrade:
	    self.r.setCurrent(UPGRADE_STR)
	else:
	    self.r.setCurrent(REINSTALL_STR)

	self.r.setToggleCallback(self.optionToggled)
	box = gtk.VBox (False)
        box.pack_start(b, False)

        vbox.pack_start (box, False)
        self.root = self.parts[0]

	# hack hack hackity hack
	upboxtmp = gtk.VBox(False, 5)
	uplabelstr = _("The following installed system will be upgraded:")
	self.uplabel = gtk.Label(uplabelstr)
	self.uplabel.set_alignment(0.0, 0.0)
        model = gtk.ListStore(str)
	self.upgradecombo = gtk.ComboBox(model)

        cell = gtk.CellRendererText()
        self.upgradecombo.pack_start(cell, True)
        self.upgradecombo.set_attributes(cell, markup=0)

	for (dev, desc) in self.parts:
            iter = model.append()
	    if (desc is None) or len(desc) < 1:
		desc = _("Unknown Linux system")
            model[iter][0] = "<small>%s (%s)</small>" %(desc, dev.path)

	upboxtmp.pack_start(self.uplabel)

	# more indentation
	box1 = gtk.HBox(False)
	crackhbox = gtk.HBox(False)
	crackhbox.set_size_request(35, -1)
	box1.pack_start(crackhbox, False, False)
	box1.pack_start(self.upgradecombo, False, False)
	upboxtmp.pack_start(box1, False, False)

	# hack indent it
	upbox = gtk.HBox(False)

#	upbox.pack_start(upboxtmp, True, True)
	upbox.pack_start(upboxtmp, False, False)

	# all done phew
	r.packWidgetInEntry(UPGRADE_STR, upbox)

	# set default
	idx = 0
	for p in self.parts:
	    if self.anaconda.id.upgradeRoot[0][0] == p[0]:
	        self.upgradecombo.set_active(idx)
	        break
	    idx = idx + 1

	self.upgradeOptionsSetSensitivity(self.doupgrade)

        return vbox
