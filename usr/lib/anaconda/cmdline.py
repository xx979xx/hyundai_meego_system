#
# cmdline.py - non-interactive, very very simple frontend to anaconda
#
# Copyright (C) 2003, 2004, 2005, 2006, 2007  Red Hat, Inc.
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
# Author(s): Jeremy Katz <katzj@redhat.com
#

import time
import signal
import parted
from constants import *
from flags import flags
from iutil import strip_markup

import gettext
_ = lambda x: gettext.ldgettext("anaconda", x)

import logging
log = logging.getLogger("anaconda")

stepToClasses = { "install" : "setupProgressDisplay" }

class WaitWindow:
    def pop(self):
        pass
    def refresh(self):
        pass
    def __init__(self, title, text):
        print(text)

class ProgressWindow:
    def pop(self):
        print("")

    def pulse(self):
        pass

    def set(self, amount):
        if amount == self.total:
            print(_("Completed"))

    def refresh(self):
        pass

    def __init__(self, title, text, total, updpct = 0.05, pulse = False):
        self.total = total
        print(text)
        print(_("In progress"))

class InstallInterface:
    def __init__(self):
#        signal.signal(signal.SIGINT, signal.SIG_IGN)
        signal.signal(signal.SIGTSTP, signal.SIG_DFL)

    def __del__(self):
        pass

    def shutdown(self):
        pass

    def suspend(self):
        pass

    def resume(self):
        pass

    def progressWindow(self, title, text, total, updpct = 0.05, pulse = False):
        return ProgressWindow(title, text, total, updpct, pulse)

    def kickstartErrorWindow(self, text):
        s = _("The following error was found while parsing the "
              "kickstart configuration file:\n\n%s") %(text,)
        print(s)

        while 1:
            time.sleep(5)

    def messageWindow(self, title, text, type="ok", default = None,
                      custom_icon = None, custom_buttons = []):
        if type == "ok":
            print(text)
        else:
            print(_("Command line mode requires all choices to be specified in a kickstart configuration file."))
            print(title)
            print(text)
            print(type, custom_buttons)

            # don't exit
            while 1:
                time.sleep(5)

    def detailedMessageWindow(self, title, text, longText=None, type="ok",
                              default=None, custom_buttons=None,
                              custom_icon=None):
        if longText:
            text += "\n\n%s" % longText

        self.messageWindow(title, text, type=type, default=default,
                           custom_buttons=custom_buttons, custom_icon=custom_icon)

    def passphraseEntryWindow(self, device):
        print(_("Can't have a question in command line mode!"))
        print("(passphraseEntryWindow: '%s')" % device)
        # don't exit
        while 1:
            time.sleep(5)

    def getLUKSPassphrase(self, passphrase = "", isglobal = False):
        print(_("Can't have a question in command line mode!"))
        print("(getLUKSPassphrase)")
        # don't exit
        while 1:
            time.sleep(5)

    def enableNetwork(self):
        print(_("Can't have a question in command line mode!"))
        print("(enableNetwork)")
        # don't exit
        while 1:
            time.sleep(5)

    def mainExceptionWindow(self, shortText, longTextFile):
        print(shortText)

    def waitWindow(self, title, text):
        return WaitWindow(title, text)

    def beep(self):
        pass

    def run(self, anaconda):
        (step, instance) = anaconda.dispatch.currentStep()
        while step:
            if stepToClasses.has_key(step):
                s = "nextWin = %s" %(stepToClasses[step],)
                exec s
                nextWin(instance)
            else:
                print("In interactive step %s, can't continue" %(step,))
                while 1:
                    time.sleep(1)

            anaconda.dispatch.gotoNext()
	    (step, instance) = anaconda.dispatch.currentStep()
            

class progressDisplay:
    def __init__(self):
        self.pct = 0
        self.display = ""

    def __del__(self):
        pass

    def processEvents(self):
        pass
    def setShowPercentage(self, val):
        pass
    def get_fraction(self):
        return self.pct
    def set_fraction(self, pct):
        self.pct = pct
    def set_text(self, txt):
        pass
    def set_label(self, txt):
        stripped = strip_markup(txt)
        if stripped != self.display:
            self.display = stripped
            print(self.display)

def setupProgressDisplay(anaconda):
    if anaconda.dir == DISPATCH_BACK:
        anaconda.id.setInstallProgressClass(None)
        return DISPATCH_BACK
    else:
        anaconda.id.setInstallProgressClass(progressDisplay())
        
    return DISPATCH_FORWARD
