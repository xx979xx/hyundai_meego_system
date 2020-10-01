#
# kbd_gui.py: gui keyboard setting screen 
#
# Copyright (C) 2002, 2003, 2006, 2007, 2008 Red Hat, Inc.  All rights reserved.
# Brent Fox <bfox@redhat.com>
# Mike Fulbright <msf@redhat.com>
# Jeremy Katz <katzj@redhat.com>
# Chris Lumens <clumens@redhat.com>
# Bill Nottingham <notting@redhat.com>
# Lubomir Kundrak <lkundrak@redhat.com>
#
# Copyright (C) 2009 Intel Corp.
# Xu Li <xu.li@intel.com>
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

from iw_gui import *
import sys
import gobject, gtk
import rhpl.keyboard as keyboard
import gettext
_ = lambda x: gettext.ldgettext("anaconda", x)

def setupTreeViewFixupIdleHandler(view, store):
    id = {}
    id["id"] = gobject.idle_add(scrollToIdleHandler, (view, store, id))

def scrollToIdleHandler((view, store, iddict)):
    if not view or not store or not iddict:
        return

    try:
        id = iddict["id"]
    except:
        return

    selection = view.get_selection()
    if not selection:
        return

    model, iter = selection.get_selected()
    if not iter:
        return

    path = store.get_path(iter)
    col = view.get_column(0)
    view.scroll_to_cell(path, col, True, 0.5, 0.5)

    if id:
        gobject.source_remove(id)

class KeyboardWindow(InstallWindow):
    def __init__(self, ics):
        InstallWindow.__init__(self, ics)
        self.icon = None
        self.sidebarTitle = N_("Keyboard")
        self.title = N_("Keyboard")
        self.kbd = None

    def select_row(self, *args):
        rc = self.modelView.get_selection().get_selected()
        if rc:
            model, iter = rc
            if iter is not None:
                key = self.modelStore.get_value(iter, 0)
                if key:
                    self.type = key

    def getNext(self):
        self.kbd.set(self.type)
        self.kbd.beenset = 1
        self.kbd.activate()

    def getScreen(self, anaconda):
        if anaconda.id.keyboard is None:
            anaconda.id.keyboard = keyboard.Keyboard()

        anaconda.id.keyboard.beenset = 1
        self.kbd = anaconda.id.keyboard

        self.vbox = gtk.VBox()
        self.vbox.set_spacing(10)
        self.vbox.set_border_width(10)

        label = gtk.Label(_("Select the appropriate keyboard for the system."))
        label.set_alignment(0.0, 0.5)
        label.set_size_request(500, -1)
        self.vbox.pack_start(label, False)

        if not self.kbd.beenset:
            default = anaconda.id.instLanguage.getDefaultKeyboard()
        else:
            default = self.kbd.get()
        self.type = default

        self.modelStore = gtk.ListStore(gobject.TYPE_STRING,
                                        gobject.TYPE_STRING)
        self.modelStore.set_sort_column_id(1, gtk.SORT_ASCENDING)

        # Sort the UI by the descriptive names, not the keymap abbreviations.
        self.kbdDict = self.kbd.modelDict
        lst = self.kbdDict.items()
        lst.sort(lambda a, b: cmp(a[1][0], b[1][0]))

        for item in lst:
            iter = self.modelStore.append()
            self.modelStore.set_value(iter, 0, item[0])
            self.modelStore.set_value(iter, 1, item[1][0])

        self.modelView = gtk.TreeView(self.modelStore)
        self.col = gtk.TreeViewColumn(None, gtk.CellRendererText(), text=1)
        self.modelView.append_column(self.col)
        self.modelView.set_property("headers-visible", False)
        self.modelView.get_selection().set_mode(gtk.SELECTION_BROWSE)

        # Type ahead should search on the names, not the keymap abbreviations.
        self.modelView.set_enable_search(True)
        self.modelView.set_search_column(1)

        selection = self.modelView.get_selection()
        selection.connect("changed", self.select_row)

        iter = self.modelStore.get_iter_root()
        while iter is not None:
            if self.modelStore.get_value(iter, 0) == default:
                path = self.modelStore.get_path(iter)
                self.modelView.set_cursor(path, self.col, False)
                self.modelView.scroll_to_cell(path, self.col, True,
                                              0.5, 0.5)
                break
            iter = self.modelStore.iter_next(iter)

        self.modelViewSW = gtk.ScrolledWindow()
        self.modelViewSW.set_policy(gtk.POLICY_AUTOMATIC, gtk.POLICY_AUTOMATIC)
        self.modelViewSW.set_shadow_type(gtk.SHADOW_IN)
        self.modelViewSW.add(self.modelView)

        self.vbox.pack_start(self.modelViewSW, True)

        setupTreeViewFixupIdleHandler(self.modelView, self.modelView.get_model())

        return self.vbox
