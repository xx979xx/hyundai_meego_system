#
# userauth_text.py: text mode authentication setup dialogs
#
# Copyright (C) 2000, 2001, 2002, 2008  Red Hat, Inc.  All rights reserved.
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

from snack import *
from constants_text import *
import cracklib

from constants import *
import gettext
_ = lambda x: gettext.ldgettext("anaconda", x)

class RootPasswordWindow:
    def __call__ (self, screen, anaconda):
        toplevel = GridFormHelp(screen, _("Root Password"), "rootpw", 1, 3)

        toplevel.add(TextboxReflowed(37,
                                     _("Pick a root password. You must "
                                       "type it twice to ensure you know "
                                       "it and do not make a mistake typing.")),
                     0, 0, (0, 0, 0, 1))

        if anaconda.id.rootPassword["isCrypted"]:
            anaconda.id.rootPassword["password"] = ""

        entry1 = Entry(24, password=1,
                       text=anaconda.id.rootPassword["password"])
        entry2 = Entry(24, password=1,
                       text=anaconda.id.rootPassword["password"])
        passgrid = Grid(2, 2)
        passgrid.setField(Label(_("Password:")), 0, 0, (0, 0, 1, 0),
                          anchorLeft=1)
        passgrid.setField(Label(_("Password (confirm):")), 0, 1, (0, 0, 1, 0),
                          anchorLeft=1)
        passgrid.setField(entry1, 1, 0)
        passgrid.setField(entry2, 1, 1)
        toplevel.add(passgrid, 0, 1, (0, 0, 0, 1))

        bb = ButtonBar(screen, (TEXT_OK_BUTTON, TEXT_BACK_BUTTON))
        toplevel.add(bb, 0, 2, growx = 1)

        while 1:
            toplevel.setCurrent(entry1)
            result = toplevel.run()
            rc = bb.buttonPressed(result)
            if rc == TEXT_BACK_CHECK:
                screen.popWindow()
                return INSTALL_BACK
            if len(entry1.value()) < 6:
                ButtonChoiceWindow(screen, _("Password Length"),
                    _("The root password must be at least 6 characters long."),
                    buttons = [ TEXT_OK_BUTTON ], width = 50)
            elif entry1.value() != entry2.value():
                ButtonChoiceWindow(screen, _("Password Mismatch"),
                    _("The passwords you entered were different. Please "
                      "try again."), buttons = [ TEXT_OK_BUTTON ], width = 50)
            elif self.hasBadChars(entry1.value()):
                ButtonChoiceWindow(screen, _("Error with Password"),
                    _("Requested password contains non-ASCII characters, "
                      "which are not allowed."),
                    buttons = [ TEXT_OK_BUTTON ], width = 50)
            else:
                try:
                    cracklib.FascistCheck(entry1.value())
                except ValueError, e:
                    msg = gettext.ldgettext("cracklib", e)
                    ret = anaconda.intf.messageWindow(_("Weak Password"),
                             _("You have provided a weak password: %s\n\n"
                               "Would you like to continue with this password?"
                               % (msg, )),
                             type = "yesno", default="no")
                    if ret == 1:
                        break
                else:
                    break

            entry1.set("")
            entry2.set("")

        screen.popWindow()
        anaconda.id.rootPassword["password"] = entry1.value()
        anaconda.id.rootPassword["isCrypted"] = False
        return INSTALL_OK

    def hasBadChars(self, pw):
        allowed = string.digits + string.ascii_letters + \
                  string.punctuation + " "
        for letter in pw:
            if letter not in allowed:
                return True
        return False
