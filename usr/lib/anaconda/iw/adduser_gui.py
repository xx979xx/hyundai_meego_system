#
# adduser_gui.py: gui adduser screen.
#
# Copyright (C) 2008, 2009  Intel Corp.
# Copyright (C) 2000, 2001, 2002  Red Hat, Inc.  All rights reserved.
# Copyright (C) 2001-2005 Red Hat, Inc.
# Copyright (C) 2001-2003 Brent Fox <bfox@redhat.com>
# Copyright (C) 2004-2005 Nils Philippsen <nphilipp@redhat.com>#
# Copyright (C) 2008 Red Hat, Inc.
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
# Author(s): Xu Li <xu.li@intel.com>
#            Vivian Zhang <vivian.zhang@intel.com>

import gtk
import gui
import iutil
from iw_gui import *
from constants import *
import os, string, sys
sys.path.append("/usr/share/system-config-users")
import users
import re
import gettext
import os
import sys
import subprocess
import libuser
import cracklib
_ = lambda x: gettext.ldgettext("anaconda", x)


class AddUserWindow (InstallWindow):        

    windowTitle = "" #N_("AddUser")

    def __init__ (self, ics):
        InstallWindow.__init__ (self, ics)
        ics.setPrevEnabled(False)

    def _checkUsername(self, username):
        usersUtil = users.Users()
        (ret, retStr) = usersUtil.checkUsername(username, root=self.rootPath)
        if ret == False:
            self.intf.messageWindow(_("Error with Username"),
                                    retStr,
                                    custom_icon="error")
            self.usernameEntry.set_text("")
            self.usernameEntry.grab_focus()
            raise gui.StayOnScreen

        maxnamelength = libuser.UT_NAMESIZE - 1
        if len(username) > maxnamelength:
            self.intf.messageWindow(_("Error with Username"),
                                    _("The user name must not exceed %d characters.") % maxnamelength,
                                    custom_icon="error")
            self.usernameEntry.set_text("")
            self.usernameEntry.grab_focus()
            raise gui.StayOnScreen

        alldigits = True
        for i, j in map(lambda x: (username[x], x), range(len(username))):
            if i == "_" or (i == "-" and j != 0) or (i == "$" and j != 0 and j == len(username)-1):
                #specifically allow "-" (except at the beginning), "$" at the end and "_"
                alldigits = False
                continue

            if i == "$":
                self.intf.messageWindow(_("Error with Username"),
                                        _("The user name '%s' contains a dollar sign which is not at the end. "
                                          "Please use dollar signs only at the end of user names to indicate "
                                          "Samba machine accounts.") % username,
                                        custom_icon="error")
                self.usernameEntry.set_text("")
                self.usernameEntry.grab_focus()
                raise gui.StayOnScreen

            if i not in string.ascii_letters and i not in string.digits and i != '.': 
                self.intf.messageWindow(_("Error with Username"),
                                        _("The user name '%(name)s' contains an invalid character at "
                                          "position %(position)d.") % {'name': username, 'position': j+1},
                                        custom_icon="error")
                self.usernameEntry.set_text("")
                self.usernameEntry.grab_focus()
                raise gui.StayOnScreen

            if i not in string.digits:
                alldigits = False

        if alldigits:
            ret = self.intf.messageWindow(_("Warning with Username"),
                                          _("Using all numbers as the user name can cause confusion about whether "
                                            "the user name or numerical user id is meant. Do you really want to "
                                            "use a numerical-only user name?"),
                                          type="yesno")

            if ret == 0:
                self.usernameEntry.set_text("")
                self.usernameEntry.grab_focus()
                raise gui.StayOnScreen

        # If a home directory for the user already exists, offer to reuse it
        # for the new user.
        try:
            os.stat("%s/home/%s" % (self.rootPath, username))
            hashomedir = True
        except:
            hashomedir = False

        if hashomedir:
            ret = self.intf.messageWindow(_("Warning with Username"),
                                          _("A home directory for user %s already exists. "
                                            "Would you like to reuse this home directory? "
                                            "If not, please choose a different username.") % username,
                                          type="yesno")
            if ret == 0:
                self.usernameEntry.set_text("")
                self.usernameEntry.grab_focus()
                raise gui.StayOnScreen

        return None

    def _checkFullname(self, fullname):
        try:
            dummy = fullname.decode ('utf-8')
        except UnicodeDecodeError:
            #have to check for whitespace for gecos, since whitespace is ok
            self.intf.messageWindow(_("Error with Fullname"),
                                    _("The name '%s' contains invalid characters. "
                                      "Please use only UTF-8 characters.") % fullname,
                                    custom_icon="error")
            self.fullnameEntry.set_text("")
            self.fullnameEntry.grab_focus()
            raise gui.StayOnScreen

        if string.find(fullname, ":") >= 0:
            #have to check for colons since /etc/passwd is a colon delimited file
            self.intf.messageWindow(_("Error with Fullname"),
                                    _("The name '%s' contains a colon. "
                                      "Please do not use colons in the name.") % fullname,
                                    custom_icon="error")
            self.fullnameEntry.set_text("")
            self.fullnameEntry.grab_focus()
            raise gui.StayOnScreen

        return None

    def _checkPassword(self, password, confirm):
        if not password or not confirm:
            self.intf.messageWindow(_("Error with Password"),
                                    _("The password should not be empty. Please enter "
                                     "the password."),
                                    custom_icon="error")
            self.passwordEntry.grab_focus()
            raise gui.StayOnScreen

        if password != confirm:
            self.intf.messageWindow(_("Error with Password"),
                                    _("The passwords do not match. Please enter "
                                     "the password again."),
                                    custom_icon="error")
            self.passwordEntry.set_text("")
            self.confirmEntry.set_text("")
            self.passwordEntry.grab_focus()
            raise gui.StayOnScreen

        if len(password) < 6:
            self.intf.messageWindow(_("Error with Password"),
                                    _("The password must be at least "
                                     "six characters long."),
                                    custom_icon="error")
            self.passwordEntry.set_text("")
            self.confirmEntry.set_text("")
            self.passwordEntry.grab_focus()
            raise gui.StayOnScreen

        legal = string.digits + string.ascii_letters + string.punctuation + " "
        for letter in password:
            if letter not in legal:
                self.intf.messageWindow(_("Error with Password"),
                                        _("Requested password contains "
                                         "invalid characters."),
                                        custom_icon="error")
                raise gui.StayOnScreen

        try:
            cracklib.FascistCheck(password)
        except ValueError, e:
            msg = gettext.ldgettext("cracklib", e)
            ret = self.intf.messageWindow(_("Weak Password"),
                                          _("Weak password provided: %s"
                                            "\n\n"
                                            "Would you like to continue with "
                                            "this password?") % (msg, ),
                                          type = "yesno")
            if ret == 0:
                self.passwordEntry.set_text("")
                self.confirmEntry.set_text("")
                self.passwordEntry.grab_focus()
                raise gui.StayOnScreen

        return None

    def getNext(self):
        # Check username
        username = self.usernameEntry.get_text()
        username = string.strip(username)
        self._checkUsername(username)

        # Check fullname
        fullname = self.fullnameEntry.get_text()
        self._checkFullname(fullname)

        # Check password & confirm
        password = self.passwordEntry.get_text()
        confirm  = self.confirmEntry.get_text()
        self._checkPassword(password, confirm)

        # Record the user account info
        self.userAccount["username"] = username
        self.userAccount["fullname"] = fullname
        self.userAccount["password"] = password
        self.userAccount["isCrypted"] = False 
        self.userAccount["isSudoer"] = True
        self.userAccount["groups"] = ["video", "audio"]
        self.userAccount["homedir"] = "/home/%s" % username
        self.userAccount["shell"] = None
        self.userAccount["uid"] = None
        self.userAccount["lock"] = False

        return None

    def getScreen (self, anaconda):        
        self.rootPath = anaconda.rootPath
        self.intf = anaconda.intf
        self.userAccount = anaconda.id.userAccount

        vbox = gtk.VBox(spacing=10)
        vbox.set_border_width(25)

        hbox = gtk.HBox (False, 0)       
        pix = gui.readImageFromFile ("user_add.png")
        if pix:
            a = gtk.Alignment ()
            a.add (pix)
            a.set (0.0, 0.0, 0.5, 0.5)
            hbox.pack_start (a, False, False, 18)

        label = gtk.Label(_("You are required to create a user account for regular "
                            "(non-administrative) use of your system. Please provide "
                            "the information requested below.\n\n"
                            "Criteria for the password:\n"
                            "1. Be a minimum of six characters in length.\n"
                            "2. Contain characters from the following categories only:\n"
                            "   * Uppercase and lowercase letters (A-Za-z)\n"
                            "   * Digits (0-9)\n"
                            "   * Special characters (including ~`!@#$%^&*()-=_+[]\{}|;\':\",./<>? and whitespace)\n"
                            "Notice: The root password will be set to the same as the "
                            "password input below.\n"))
        label.set_line_wrap(True)
        label.set_alignment(0.0, 0.5)
        label.set_size_request(500, -1)
        hbox.pack_start(label, False, True)

        vbox.pack_start(hbox,False)
        
        self.usernameEntry = gtk.Entry()
        self.fullnameEntry = gtk.Entry()
        self.passwordEntry = gtk.Entry()
        self.confirmEntry = gtk.Entry()

        self.passwordEntry.set_visibility(False)
        self.confirmEntry.set_visibility(False)

        table = gtk.Table(2, 4)
        table.set_col_spacings(5)
        table.set_row_spacings(5)
        
        label = gtk.Label(_("_Username:"))
        label.set_use_underline(True)
        label.set_mnemonic_widget(self.usernameEntry)
        label.set_alignment(0.0, 0.5)
        table.attach(label, 0, 1, 0, 1, gtk.FILL)
        table.attach(self.usernameEntry, 1, 2, 0, 1, gtk.SHRINK, gtk.FILL, 5)

        label = gtk.Label(_("_Full Name:"))
        label.set_use_underline(True)
        label.set_mnemonic_widget(self.fullnameEntry)
        label.set_alignment(0.0, 0.5)
        table.attach(label, 0, 1, 1, 2, gtk.FILL)
        table.attach(self.fullnameEntry, 1, 2, 1, 2, gtk.SHRINK, gtk.FILL, 5)

        label = gtk.Label(_("_Password:"))
        label.set_use_underline(True)
        label.set_mnemonic_widget(self.passwordEntry)
        label.set_alignment(0.0, 0.5)
        table.attach(label, 0, 1, 2, 3, gtk.FILL)
        table.attach(self.passwordEntry, 1, 2, 2, 3, gtk.SHRINK, gtk.FILL, 5)

        label = gtk.Label(_("_Confirm Password:"))
        label.set_use_underline(True)
        label.set_mnemonic_widget(self.confirmEntry)
        label.set_alignment(0.0, 0.5)
        table.attach(label, 0, 1, 3, 4, gtk.FILL)
        table.attach(self.confirmEntry, 1, 2, 3, 4, gtk.SHRINK, gtk.FILL, 5)

        vbox.pack_start(table, False)
        gtk.gdk.beep()
        return vbox
