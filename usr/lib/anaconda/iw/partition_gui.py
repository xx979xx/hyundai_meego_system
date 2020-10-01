#
# partition_gui.py: allows the user to choose how to partition their disks
#
# Copyright (C) 2001, 2002  Red Hat, Inc.  All rights reserved.
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
# Author(s): Matt Wilson <msw@redhat.com>
#            Michael Fulbright <msf@redhat.com>
#

import gobject
import gtk
import gtk.glade
try:
    import gnomecanvas
except ImportError:
    import gnome.canvas as gnomecanvas
import pango
import gui
import parted
import string
import types
import copy

import storage
from iw_gui import *
from flags import flags

import datacombo
import lvm_dialog_gui as l_d_g
import raid_dialog_gui as r_d_g
import partition_dialog_gui as p_d_g

from partIntfHelpers import *
from constants import *
from partition_ui_helpers_gui import *
from storage.partitioning import doPartitioning
from storage.partitioning import hasFreeDiskSpace
from storage.devicelibs import lvm
from storage.devices import devicePathToName, PartitionDevice

import gettext
_ = lambda x: gettext.ldgettext("anaconda", x)
P_ = lambda x, y, z: gettext.ldngettext("anaconda", x, y, z)

import logging
log = logging.getLogger("anaconda")

STRIPE_HEIGHT = 35.0
LOGICAL_INSET = 3.0
TREE_SPACING = 2

# XXX hack but will work for now
if gtk.gdk.screen_width() > 640:
    CANVAS_WIDTH = 490
else:
    CANVAS_WIDTH = 390
CANVAS_HEIGHT = 200

MODE_ADD = 1
MODE_EDIT = 2

class Slice:
    """Class representing a slice of a stripe.

    parent -- the stripe that the slice belongs too.
    text -- what will appear in the slice
    type -- either SLICE or SUBSLICE
    xoffset -- start percentage
    xlength -- a length percentage
    dcCB -- function that is called on a double click.
    cCB -- function that is called when one click (selected)
    sel_col -- color when selected
    unsel_col -- color when unselected
    obj -- some python object that is related to this slice.
    selected -- initial state of slice.
    """
    SLICE = 0
    SUBSLICE = 1
    CONTAINERSLICE = 2

    def __init__(self, parent, text, type, xoffset, xlength, dcCB=lambda: None,
            cCB=lambda x: None, sel_col="cornsilk1", unsel_col="white",
            obj = None, selected = False):
        self.text = text
        self.type = type
        self.xoffset = xoffset
        self.xlength = xlength
        self.parent = parent
        self.dcCB = dcCB
        self.cCB = cCB
        self.sel_col = sel_col
        self.unsel_col = unsel_col
        self.obj = obj
        self.selected = selected

    def eventHandler(self, widget, event):
        if event.type == gtk.gdk.BUTTON_PRESS:
            if event.button == 1:
                self.select()
                self.cCB(self.obj)
        elif event.type == gtk.gdk._2BUTTON_PRESS:
            #self.select()
            self.dcCB()

        return True

    def putOnCanvas(self):
        pgroup = self.parent.getGroup()
        self.group = pgroup.add(gnomecanvas.CanvasGroup)
        self.box = self.group.add(gnomecanvas.CanvasRect)
        self.group.connect("event", self.eventHandler)
        canvas_text = self.group.add(gnomecanvas.CanvasText,
                                    font="sans", size_points=8)

        xoffset = self.xoffset * CANVAS_WIDTH
        xlength = self.xlength * CANVAS_WIDTH

        if self.type == Slice.SUBSLICE:
            yoffset = 0.0 + LOGICAL_INSET
            yheight = STRIPE_HEIGHT - (LOGICAL_INSET * 2)
            texty = 0.0
        else:
            yoffset = 0.0
            yheight = STRIPE_HEIGHT
            texty = LOGICAL_INSET

        if self.selected:
            fill_color = self.sel_col
        else:
            fill_color = self.unsel_col

        self.group.set(x=xoffset, y=yoffset)
        self.box.set(x1=0.0, y1=0.0, x2=xlength,
                     y2=yheight, fill_color=fill_color,
                     outline_color='black', width_units=1.0)
        canvas_text.set(x=2.0, y=texty + 2.0, text=self.text,
                            fill_color='black',
                            anchor=gtk.ANCHOR_NW, clip=True,
                            clip_width=xlength-1, clip_height=yheight-1)

    def shutDown(self):
        self.parent = None
        if self.group:
            self.group.destroy()
            self.group = None

    def select(self):
        for slice in self.parent.slices:
            slice.deselect()
        self.selected = True

        if self.group and self.box:
            if self.type != Slice.CONTAINERSLICE:
                self.group.raise_to_top()
            self.box.set(outline_color="red")
            self.box.set(fill_color=self.sel_col)

    def deselect(self):
        self.selected = False
        if self.box:
            self.box.set(outline_color="black", fill_color=self.unsel_col)

class Stripe:
    """
    canvas -- the canvas where everything goes
    text -- the text that will appear on top of the stripe
    yoff -- its the position in the y axis where this stripe should be drawn
    dcCB -- function that should be called on a double click
    obj -- some python object that is related to this stripe

    """
    def __init__(self, canvas, text, dcCB, obj = None):
        self.canvas_text = None
        self.canvas = canvas
        self.text = text
        self.group = None
        self._slices = []
        self.dcCB = dcCB
        self.selected = None
        self.obj = obj

    def putOnCanvas(self, yoff):
        """
        returns the yposition after drawhing this stripe.

        """
        # We set the text for the stripe.
        self.canvas_text = self.canvas.root().add(gnomecanvas.CanvasText,
                x=0.0, y=yoff, font="sans", size_points=9)
        self.canvas_text.set(text=self.text, fill_color='black',
                anchor=gtk.ANCHOR_NW, weight=pango.WEIGHT_BOLD)

        (xxx1, yyy1, xxx2, yyy2) =  self.canvas_text.get_bounds()
        textheight = yyy2 - yyy1 + 2
        self.group = self.canvas.root().add(gnomecanvas.CanvasGroup,
                                       x=0, y=yoff+textheight)

        self.group.add(gnomecanvas.CanvasRect, x1=0.0, y1=0.0, x2=CANVAS_WIDTH,
                  y2=STRIPE_HEIGHT, fill_color='green',
                  outline_color='grey71', width_units=1.0)
        self.group.lower_to_bottom()

        # We paint all the container slices first.  So the contained slices
        # actually show up.
        for slice in [s for s in self.slices if s.type == Slice.CONTAINERSLICE]:
            slice.putOnCanvas()
        # After painting the containers we paint the rest.
        for slice in [s for s in self.slices if s.type != Slice.CONTAINERSLICE]:
            slice.putOnCanvas()

        # 10 is a separator space.
        return yoff + STRIPE_HEIGHT+textheight+10

    def shutDown(self):
        for slice in self.slices:
            slice.shutDown()
        self._slices = []

        if self.canvas_text:
            self.canvas_text.destroy()

        if self.group:
            self.group.destroy()
            self.group = None

    def getGroup(self):
        return self.group

    @property
    def slices(self):
        return self._slices

    def addSlice(self, new_slice):
        # check to see if they overlap.
        for slice in self.slices:
            # Container slices and subslices can overlap.
            if new_slice.type+slice.type == Slice.CONTAINERSLICE+Slice.SUBSLICE:
                continue

            if new_slice.xoffset > slice.xoffset \
                    and new_slice.xoffset < slice.xoffset + slice.xlength:
                # there is a colission, we cannot add.
                return

        self._slices.append(new_slice)

    def getSelectedSlice(self):
        for slice in self.slices:
            if slice.selected:
                return slice
        return None

class StripeGraph:
    """ This class will only handle one stripe."""

    __canvas = None
    def __init__(self):
        self.stripe = None
        self.next_ypos = 0.0

    def __del__(self):
        self.shutDown()

    def shutDown(self):
        if self.stripe:
            self.stripe.shutDown()
            self.stripe = None

        self.next_ypos = 0.0

    @classmethod
    def getCanvas(cls):
        if not StripeGraph.__canvas:
            StripeGraph.__canvas = gnomecanvas.Canvas()
        return StripeGraph.__canvas

    def setDisplayed(self, obj):
        # Check to see if we already have the correct obj displayed.
        if self.getDisplayed() and self.getDisplayed().obj == obj:
            return

        if self.stripe:
            self.stripe.shutDown()

        self.stripe = self._createStripe(obj)
        self.stripe.putOnCanvas(0)

        # Trying to center the picture.
        apply(self.getCanvas().set_scroll_region, self.getCanvas().root().get_bounds())

    def getDisplayed(self):
        return self.stripe

    def selectSliceFromObj(self, obj):
        """Search for obj in the slices """
        stripe = self.getDisplayed()
        if not stripe:
            return

        for slice in stripe.slices:
            # There is a part object in each slice.
            if not slice.obj:
                continue

            if obj == slice.obj and not slice.selected:
                slice.select()
                break

    def _createStripe(self, obj):
        #This method needs to be overridden
        pass

    def getSelectedSlice(self):
        return self.stripe.getSelectedSlice()


class DiskStripeGraph(StripeGraph):
    """Handles the creation of a bar view for the 'normal' devies.

    storage -- the storage object

    cCB -- call back function used when the user clicks on a slice. This function
           is passed a device object when its executed.
    dcCB -- call back function used when the user double clicks on a slice.
    drive -- drive to display
    """
    def __init__(self, storage, drive=None, cCB=lambda x:None, dcCB=lambda:None):
        StripeGraph.__init__(self)
        self.storage = storage
        self.cCB = cCB
        self.dcCB = dcCB
       # Define the default colors per partition type.
        self.part_type_colors = \
                {"sel_logical": "cornsilk1", "unsel_logical": "white",
                 "sel_extended": "cornsilk1", "unsel_extended": "white",
                 "sel_normal": "cornsilk1", "unsel_normal": "white",
                 "sel_freespace": "grey88", "unsel_freespace": "grey88"}
        if drive:
            self.setDisplayed(drive)

    def _createStripe(self, drive):
        # Create the stripe
        drivetext = _("Drive %(drive)s (%(size)-0.f MB) (Model: %(model)s)") \
                    % {'drive': drive.path,
                       'size': drive.size,
                       'model': drive.model}
        stripe = Stripe(self.getCanvas(), drivetext, self.dcCB, obj = drive)

        # Free Extended Calculation
        # Free slice/partition in the extended partition "free space".  If there
        # is space between the last logical partition and the ending of the
        # extended partition we create a "free space" in the extended part.
        # Create the slices.

        # These offsets are where the partition/slices end. 0<offset<1
        last_logical_offset = None
        last_extended_offset = None

        for part in drive.format.partedDisk.getFreeSpacePartitions() \
                + [d for d in drive.format.partitions]:
            if part.getSize(unit="MB") <= 1.0:
                continue

            # Create the start and length for the slice.
            xoffset = (float(part.geometry.start)
                        / float(drive.partedDevice.length))
            xlength = (float(part.geometry.length)
                        / float(drive.partedDevice.length))

            if part.type == parted.PARTITION_LOGICAL:
                partstr = "%s\n%.0f MB" % (part.path, float(part.getSize()))
                stype = Slice.SUBSLICE
                unsel_col = self.part_type_colors["unsel_logical"]
                sel_col = self.part_type_colors["sel_logical"]

                # Free Extended Calculation
                if last_logical_offset == None:
                    last_logical_offset = xoffset + xlength
                elif last_logical_offset < xoffset + xlength:
                    last_logical_offset = xoffset + xlength

            elif part.type == parted.PARTITION_FREESPACE:
                partstr = "%s\n%.0f MB" % (_("Free"), float(part.getSize()))
                stype = Slice.SLICE
                unsel_col = self.part_type_colors["unsel_freespace"]
                sel_col = self.part_type_colors["sel_freespace"]

            elif part.type == parted.PARTITION_EXTENDED:
                partstr = ""
                stype = Slice.CONTAINERSLICE
                unsel_col = self.part_type_colors["unsel_extended"]
                sel_col = self.part_type_colors["sel_extended"]

                # Free Extended Calculation
                last_extended_offset = xoffset + xlength

            elif part.type == parted.PARTITION_NORMAL:
                partstr = "%s\n%.0f MB" % (part.path, float(part.getSize()))
                stype = Slice.SLICE
                unsel_col = self.part_type_colors["unsel_normal"]
                sel_col = self.part_type_colors["sel_normal"]

            else:
                # We don't really want to draw anything in this case.
                continue

            # We need to use the self.storage objects not the partedDisk ones.
            # The free space has not storage object.
            if part.type != parted.PARTITION_FREESPACE:
                partName = devicePathToName(part.getDeviceNodeName())
                o_part = self.storage.devicetree.getDeviceByName(partName)
            else:
                o_part = None

            slice = Slice(stripe, partstr, stype, xoffset, xlength,
                    dcCB = self.dcCB, cCB = self.cCB, sel_col = sel_col,
                    unsel_col = unsel_col, obj = o_part)
            stripe.addSlice(slice)

        # Free Extended Calculation
        if (last_logical_offset != None and last_extended_offset != None) \
                and last_logical_offset < last_extended_offset:
            # We must create a "free extended" slice
            stype = Slice.SUBSLICE
            unsel_col = self.part_type_colors["unsel_freespace"]
            sel_col = self.part_type_colors["sel_freespace"]
            xoffset = last_logical_offset
            xlength = last_extended_offset - last_logical_offset
            slcstr = "%s\n%.0f MB" % (_("Free"), float(drive.size * xlength))

            slice = Slice(stripe, slcstr, stype, xoffset, xlength,
                    dcCB = self.dcCB, cCB = self.cCB, sel_col=sel_col,
                    unsel_col=unsel_col)
            stripe.addSlice(slice)

        return stripe

class LVMStripeGraph(StripeGraph):
    """
    storage -- the storage object

    cCB -- call back function used when the user clicks on a slice. This function
           is passed a device object when its executed.
    dcCB -- call back function used when the user double clicks on a slice.
    vg -- volume group to display
    """
    def __init__(self, storage, vg=None, cCB=lambda x:None, dcCB=lambda:None):
        StripeGraph.__init__(self)
        self.storage = storage
        self.cCB = cCB
        self.dcCB = dcCB
       # Define the default colors per partition type.
        self.part_type_colors = \
                {"sel_lv": "cornsilk1", "unsel_lv": "white",
                 "sel_freespace": "grey88", "unsel_freespace": "grey88"}
        if vg:
            self.setDisplayed(vg)

    def _createStripe(self, vg):
        # Create the stripe
        vgtext = _("LVM Volume Group %s (%-0.f MB)") % (vg.name, vg.size)
        stripe = Stripe(self.getCanvas(), vgtext, self.dcCB, obj = vg)

        # Create the slices.
        # Since se don't have a start and length like in the partitions, we
        # put all the LVs next to each other and put the free space at the end.
        curr_offset = float(0)
        for lv in vg.lvs:
            lvstr = "%s\n%.0f MB" % (lv.name, float(lv.size))
            stype = Slice.SLICE
            sel_col = self.part_type_colors["sel_lv"]
            unsel_col = self.part_type_colors["unsel_lv"]

            #xoffset = float(curr_offset) / float(vg.size)
            xoffset = curr_offset
            xlength = float(lv.size) / float(vg.size)

            slice = Slice(stripe, lvstr, stype, xoffset, xlength,
                    dcCB = self.dcCB, cCB = self.cCB, sel_col = sel_col,
                    unsel_col = unsel_col, obj = lv)
            stripe.addSlice(slice)

            curr_offset += xlength

        # We add the free space if there is any space left.
        if curr_offset < 1:
            #freestr = _("Free")
            stype = Slice.SLICE
            sel_col = self.part_type_colors["sel_freespace"]
            unsel_col = self.part_type_colors["unsel_freespace"]

            xoffset = curr_offset
            xlength = float(1 - curr_offset)

            # with the xlength we give an approximate size
            freestr = "%s\n%.0f MB" % (_("Free"), float(vg.size*xlength))

            # We append no object.
            slice = Slice(stripe, freestr, stype, xoffset, xlength,
                    dcCB = self.dcCB, cCB = self.cCB, sel_col = sel_col,
                    unsel_col = unsel_col)

            stripe.addSlice(slice)

        return stripe

class MDRaidArrayStripeGraph(StripeGraph):
    """
    storage -- the storage object

    cCB -- call back function used when the user clicks on a slice. This function
           is passed a device object when its executed.
    dcCB -- call back function used when the user double clicks on a slice.
    md -- RAID device to display.
    """
    def __init__(self, storage, md=None, cCB=lambda x:None, dcCB=lambda:None):
        StripeGraph.__init__(self)
        self.storage = storage
        self.cCB = cCB
        self.dcCB = dcCB
        self.part_type_colors = \
                {"sel_md": "cornsilk1", "unsel_md": "white"}
        if md:
            self.setDisplayed(md)

    def _createStripe(self, md):
        mdtext = _("MD RAID ARRAY %s (%-0.f MB)") % (md.path, md.size)
        stripe = Stripe(self.getCanvas(), mdtext, self.dcCB, obj = md)

        # Since we can't really create subslices with md devices we will only
        # show the md device size in the bar.
        mdstr = "%s\n%.0f MB" % (md.path, float(md.size))
        stype = Slice.SLICE
        sel_col = self.part_type_colors["sel_md"]
        unsel_col = self.part_type_colors["unsel_md"]
        xoffset = 0
        xlength = 1

        slice = Slice(stripe, mdstr, stype, xoffset, xlength,
                dcCB = self.dcCB, cCB = self.cCB, sel_col = sel_col,
                unsel_col = unsel_col, obj = md)
        stripe.addSlice(slice)

        return stripe

class MessageGraph:
    def __init__(self, canvas, message):
        self.canvas = canvas
        self.message = message
        self.canvas_text = None

    def display(self):
        if self.canvas_text != None:
            # This means that its already displayed.
            return

        self.canvas_text = self.canvas.root().add(gnomecanvas.CanvasText,
                x=0.0, y=20, font="sans", size_points=16)
        self.canvas_text.set(text=self.message, fill_color='black',
                anchor=gtk.ANCHOR_CENTER, weight=pango.WEIGHT_BOLD)

        # Trying to center the picture.
        apply(self.canvas.set_scroll_region, self.canvas.root().get_bounds())

    def destroy(self):
        if self.canvas_text:
            self.canvas_text.destroy()
            self.canvas_text = None

class DiskTreeModelHelper:
    def __init__(self, model, columns, iter):
        self.model = model
        self.iter = iter
        self.columns = columns

    def __getitem__(self, key):
        if type(key) == types.StringType:
            key = self.columns[key]
        try:
            return self.model.get_value(self.iter, key)
        except:
            return None

    def __setitem__(self, key, value):
        if type(key) == types.StringType:
            key = self.columns[key]
        self.model.set_value(self.iter, key, value)

class DiskTreeModel(gtk.TreeStore):
    isLeaf = -3
    isFormattable = -2
    
    # format: column header, type, x alignment, hide?, visibleKey
    titles = ((N_("Device"), gobject.TYPE_STRING, 0.0, 0, 0),
              (N_("Label"), gobject.TYPE_STRING, 0.0, 1, 0),
              (N_("Size (MB)"), gobject.TYPE_STRING, 1.0, 0, 0),
              (N_("Mount Point"), gobject.TYPE_STRING, 0.0, 0, isLeaf),
              (N_("Type"), gobject.TYPE_STRING, 0.0, 0, 0),
              (N_("Format"), gobject.TYPE_OBJECT, 0.5, 0, isFormattable),
              ("", gobject.TYPE_STRING, 0.0, 0, 0),
              # the following must be the last two
              ("IsLeaf", gobject.TYPE_BOOLEAN, 0.0, 1, 0),
              ("IsFormattable", gobject.TYPE_BOOLEAN, 0.0, 1, 0),
              ("PyObject", gobject.TYPE_PYOBJECT, 0.0, 1, 0))
    
    def __init__(self):
	self.hiddenPartitions = []
        self.titleSlot = {}
        i = 0
        types = [self]
        self.columns = []
        for title, kind, alignment, hide, key in self.titles:
            self.titleSlot[title] = i
            types.append(kind)
            if hide:
                i += 1
                continue
            elif kind == gobject.TYPE_OBJECT:
                renderer = gtk.CellRendererPixbuf()
                propertyMapping = {'pixbuf': i}
            elif kind == gobject.TYPE_BOOLEAN:
                renderer = gtk.CellRendererToggle()
                propertyMapping = {'active': i}
            elif (kind == gobject.TYPE_STRING or
                  kind == gobject.TYPE_INT):
                renderer = gtk.CellRendererText()
                propertyMapping = {'markup': i}

            # wire in the cells that we want only visible on leaf nodes to
            # the special leaf node column.
            if key < 0:
                propertyMapping['visible'] = len(self.titles) + key
                
            renderer.set_property('xalign', alignment)
	    if title == "Mount Point":
		title = _("Mount Point")
	    elif title == "Size (MB)":
		title = _("Size\n(MB)")
            elif title != "":
                title = _(title)
            col = apply(gtk.TreeViewColumn, (title, renderer),
                        propertyMapping)
	    col.set_alignment(0.5)
	    if kind == gobject.TYPE_STRING or kind == gobject.TYPE_INT:
		col.set_property('sizing', gtk.TREE_VIEW_COLUMN_AUTOSIZE)
            self.columns.append(col)
            i += 1

        apply(gtk.TreeStore.__init__, types)

        self.view = gtk.TreeView(self)
        # append all of the columns
        map(self.view.append_column, self.columns)

    def getTreeView(self):
        return self.view

    def selectRowFromObj(self, obj, iter=None):
        """Find the row in the tree containing obj and select it.

        obj -- the object that we are searching
        iter -- an iter from the tree. If None, get the first one.

        Returns the iter where obj was found.  None otherwise.
        """
        retval = None
        r_obj = None
        #FIXME: watch out for hidden rows.

        if not iter:
            iter = self.get_iter_first()

        while iter:
            # r_obj -> (row object)
            r_obj = self[iter]["PyObject"]

            if obj and r_obj == obj:
                # We have fond our object, select this row and break.
                selection = self.view.get_selection()
                if selection is not None:
                    selection.unselect_all()
                    selection.select_iter(iter)

                # Make sure the tree view shows what we have selected.
                path = self.get_path(iter)
                col = self.view.get_column(0)
                self.view.set_cursor(path, col, False)
                self.view.scroll_to_cell(path, col, True, 0.5, 0.5)
                retval = iter
                break

            if self.iter_has_child(iter):
                # Call recursively if row has children.
                rv = self.selectRowFromObj(obj, iter=self.iter_children(iter))
                if rv != None:
                    retval = rv
                    break

            iter = self.iter_next(iter)

        return iter

    def getCurrentDevice(self):
        """ Return the device representing the current selection,
            None otherwise.
        """
        selection = self.view.get_selection()
        model, iter = selection.get_selected()
        if not iter:
            return None

        return model[iter]['PyObject']

    def getCurrentDeviceParent(self):
        """ Return the parent of the selected row.  Returns an iter.
            None if there is no parent.
        """
        selection = self.view.get_selection()
        model, iter = selection.get_selected()
        if not iter:
            return None

        return model.iter_parent(iter)

    def resetSelection(self):
        pass

    def clear(self):
        selection = self.view.get_selection()
        if selection is not None:
            selection.unselect_all()
        gtk.TreeStore.clear(self)

    def __getitem__(self, iter):
        if type(iter) == gtk.TreeIter:
            return DiskTreeModelHelper(self, self.titleSlot, iter)
        raise KeyError, iter


class PartitionWindow(InstallWindow):
    def __init__(self, ics):
	InstallWindow.__init__(self, ics)
        ics.setTitle(_("Partitioning"))
        ics.setNextEnabled(True)
        self.parent = ics.getICW().window

    def quit(self):
        pass

    def presentPartitioningComments(self,title, labelstr1, labelstr2, comments,
				    type="ok", custom_buttons=None):

        if flags.autostep:
            return 1

        win = gtk.Dialog(title)
        gui.addFrame(win)
        
        if type == "ok":
            win.add_button('gtk-ok', 1)
	    defaultchoice = 0
        elif type == "yesno":
            win.add_button('gtk-no', 2)
            win.add_button('gtk-yes', 1)
	    defaultchoice = 1
	elif type == "continue":
            win.add_button('gtk-cancel', 0)
            win.add_button(_("Continue"), 1)
	    defaultchoice = 1
	elif type == "custom":
	    rid=0

	    for button in custom_buttons:
		widget = win.add_button(button, rid)
		rid = rid + 1

            defaultchoice = rid - 1
	    
        image = gtk.Image()
        image.set_from_stock('gtk-dialog-warning', gtk.ICON_SIZE_DIALOG)
        hbox = gtk.HBox(False, 9)
	al=gtk.Alignment(0.0, 0.0)
	al.add(image)
        hbox.pack_start(al, False)

        buffer = gtk.TextBuffer(None)
        buffer.set_text(comments)
        text = gtk.TextView()
        text.set_buffer(buffer)
        text.set_property("editable", False)
        text.set_property("cursor_visible", False)
        text.set_wrap_mode(gtk.WRAP_WORD)
        
        sw = gtk.ScrolledWindow()
        sw.add(text)
	sw.set_size_request(400, 200)
        sw.set_policy(gtk.POLICY_AUTOMATIC, gtk.POLICY_AUTOMATIC)
        sw.set_shadow_type(gtk.SHADOW_IN)
        
        info1 = gtk.Label(labelstr1)
        info1.set_line_wrap(True)
        info1.set_size_request(400, -1)

        info2 = gtk.Label(labelstr2)
        info2.set_line_wrap(True)
        info2.set_size_request(400, -1)
        
        vbox = gtk.VBox(False, 9)

	al=gtk.Alignment(0.0, 0.0)
	al.add(info1)
        vbox.pack_start(al, False)
	
        vbox.pack_start(sw, True, True)

	al=gtk.Alignment(0.0, 0.0)
	al.add(info2)
        vbox.pack_start(al, True)
	
        hbox.pack_start(vbox, True, True)

        win.vbox.pack_start(hbox)
        win.set_position(gtk.WIN_POS_CENTER)
        win.set_default_response(defaultchoice)
        win.show_all()
        rc = win.run()
        win.destroy()
        return rc
        
    def getNext(self):
        (errors, warnings) = self.storage.sanityCheck()
        if errors:
            labelstr1 =  _("The partitioning scheme you requested "
                           "caused the following critical errors.")
            labelstr2 = _("You must correct these errors before "
                          "you continue your installation of "
                          "%s.") % (productName,)

            commentstr = string.join(errors, "\n\n")
            
            self.presentPartitioningComments(_("Partitioning Errors"),
                                             labelstr1, labelstr2,
                                             commentstr, type="ok")
            raise gui.StayOnScreen
        
        if warnings:
            # "storage configuration"
            labelstr1 = _("The partitioning scheme you requested "
                          "generated the following warnings.")
            labelstr2 = _("Would you like to continue with "
                         "your requested partitioning "
                         "scheme?")
            
            commentstr = string.join(warnings, "\n\n")
            rc = self.presentPartitioningComments(_("Partitioning Warnings"),
                                                  labelstr1, labelstr2,
                                                  commentstr,
						  type="yesno")
            if rc != 1:
                raise gui.StayOnScreen

        formatWarnings = getPreExistFormatWarnings(self.storage)
        if formatWarnings:
            labelstr1 = _("The following pre-existing partitions have been "
                          "selected to be formatted, destroying all data.")

#            labelstr2 = _("Select 'Yes' to continue and format these "
#                          "partitions, or 'No' to go back and change these "
#                          "settings.")
            labelstr2 = ""
            commentstr = ""
            for (dev, type, mntpt) in formatWarnings:
                commentstr = commentstr + \
                        "%s         %s         %s\n" % (dev,type,mntpt)

            rc = self.presentPartitioningComments(_("Format Warnings"),
                                                  labelstr1, labelstr2,
                                                  commentstr,
						  type="custom",
						  custom_buttons=["gtk-cancel",
								  _("_Format")])
            if rc != 1:
                raise gui.StayOnScreen

        self.stripeGraph.shutDown()
        self.tree.clear()
        del self.parent
        return None

    def getPrev(self):
        self.stripeGraph.shutDown()
        self.storage.clearPartType = None
        self.storage.reset()
        self.tree.clear()
        del self.parent
        return None

    def populate(self, initial = 0):
        self.tree.resetSelection()

        # first do LVM
        vgs = self.storage.vgs
        if vgs:
	    lvmparent = self.tree.append(None)
	    self.tree[lvmparent]['Device'] = _("LVM Volume Groups")
            for vg in vgs:

                vgparent = self.tree.append(lvmparent)
		self.tree[vgparent]['Device'] = "%s" % vg.name
                self.tree[vgparent]['Label'] = ""
		self.tree[vgparent]['Mount Point'] = ""
		self.tree[vgparent]['Size (MB)'] = "%Ld" % (vg.size,)
                self.tree[vgparent]['PyObject'] = vg
		for lv in vg.lvs:
                    if lv.format.type == "luks":
                        # we'll want to grab format info from the mapped
                        # device, not the encrypted one
                        try:
                            dm_dev = self.storage.devicetree.getChildren(lv)[0]
                        except IndexError:
                            format = lv.format
                        else:
                            format = dm_dev.format
                    else:
                        format = lv.format

                    # icon for the format column
                    format_icon = None
                    if lv.format.type == "luks" and not lv.format.exists:
                        # we're creating the LUKS header
                        format_icon = self.lock_pixbuf
                    elif not format.exists:
                        # we're creating a format on the device
                        format_icon = self.checkmark_pixbuf

                    # mount point string
                    if format.mountable and format.mountpoint:
                        mnt_str = format.mountpoint
                    else:
                        mnt_str = ""

                    iter = self.tree.append(vgparent)
                    self.tree[iter]['Device'] = lv.lvname
                    self.tree[iter]['Size (MB)'] = "%Ld" % lv.size
                    self.tree[iter]['PyObject'] = lv
                    self.tree[iter]['IsFormattable'] = format.formattable
                    self.tree[iter]['Format'] = format_icon
                    self.tree[iter]['Mount Point'] = mnt_str
                    self.tree[iter]['IsLeaf'] = True
                    self.tree[iter]['Type'] = format.name

                # We add a row for the VG free space.
                if vg.freeSpace > 0:
                    iter = self.tree.append(vgparent)
                    self.tree[iter]['Device'] = _("Free")
                    self.tree[iter]['Size (MB)'] = vg.freeSpace
                    self.tree[iter]['PyObject'] = None
                    self.tree[iter]['Mount Point'] = ""
                    self.tree[iter]['IsLeaf'] = True


        # handle RAID next
        mdarrays = self.storage.mdarrays
        if mdarrays:
	    raidparent = self.tree.append(None)
	    self.tree[raidparent]['Device'] = _("RAID Devices")
            for array in mdarrays:
		mntpt = None
                if array.format.type == "luks":
                    # look up the mapped/decrypted device since that's
                    # where we'll find the format we want to display
                    try:
                        dm_dev = self.storage.devicetree.getChildren(array)[0]
                    except IndexError:
                        format = array.format
                    else:
                        format = dm_dev.format
                else:
                    format = array.format

                if format.type == "lvmpv":
                    vg = None
		    for _vg in self.storage.vgs:
                        if _vg.dependsOn(array):
                            vg = _vg
                            break
                    if vg:
                        mntpt = vg.name
                    else:
                        mntpt = ""
                elif format.mountable and format.mountpoint:
                    mntpt = format.mountpoint

                iter = self.tree.append(raidparent)
		if mntpt:
                    self.tree[iter]["Mount Point"] = mntpt
                else:
                    self.tree[iter]["Mount Point"] = ""
		    
                if format.type:
                    ptype = format.name
                    if array.format.type == "luks" and \
                       not array.format.exists:
			self.tree[iter]['Format'] = self.lock_pixbuf
                    elif not format.exists:
                        self.tree[iter]['Format'] = self.checkmark_pixbuf
                    self.tree[iter]['IsFormattable'] = format.formattable
                else:
                    ptype = _("Unknown")
                    self.tree[iter]['IsFormattable'] = False

                if array.minor is not None:
                    device = "%s <span size=\"small\" color=\"gray\">(%s)</span>" \
                            % (array.name, array.path)
                else:
                    device = "Auto"

                self.tree[iter]['IsLeaf'] = True
                self.tree[iter]['Device'] = device
                if array.format.exists and getattr(format, "label", None):
                    self.tree[iter]['Label'] = "%s" % format.label
                else:
                    self.tree[iter]['Label'] = ""
                self.tree[iter]['Type'] = ptype
                self.tree[iter]['Size (MB)'] = "%Ld" % array.size
                self.tree[iter]['PyObject'] = array

	# now normal partitions
        disks = self.storage.disks
	drvparent = self.tree.append(None)
	self.tree[drvparent]['Device'] = _("Hard Drives")
        for disk in disks:
            # add a parent node to the tree
            parent = self.tree.append(drvparent)

            # Insert a '\n' when device string is too long.  Usually when it
            # contains '/dev/mapper'.  First column should be around 20 chars.
            if len(disk.name) + len(disk.path) > 20:
                separator = "\n"
            else:
                separator= " "
            self.tree[parent]['Device'] = \
                    "%s%s<span size=\"small\" color=\"gray\">(%s)</span>" \
                    % (disk.name, separator, disk.path)
            self.tree[parent]['PyObject'] = disk

            part = disk.format.firstPartition
            extendedParent = None
            while part:
                if part.type & parted.PARTITION_METADATA:
                    part = part.nextPartition()
                    continue

                partName = devicePathToName(part.getDeviceNodeName())
                device = self.storage.devicetree.getDeviceByName(partName)
                if not device and not part.type & parted.PARTITION_FREESPACE:
                    log.debug("can't find partition %s in device"
                                       " tree" % partName)

                # ignore the tiny < 1 MB free space partitions (#119479)
                if part.getSize(unit="MB") <= 1.0 and \
                   part.type & parted.PARTITION_FREESPACE:
                    if not part.active or not device.bootable:
                        part = part.nextPartition()
                        continue

                if device and device.isExtended:
                    if extendedParent:
                        raise RuntimeError, ("can't handle more than "
                                             "one extended partition per disk")
                    extendedParent = self.tree.append(parent)
                    iter = extendedParent
                elif device and device.isLogical:
                    if not extendedParent:
                        raise RuntimeError, ("crossed logical partition "
                                             "before extended")
                    iter = self.tree.append(extendedParent)
                    self.tree[iter]['IsLeaf'] = True
                else:
                    iter = self.tree.append(parent)
                    self.tree[iter]['IsLeaf'] = True

                if device and device.format.type == "luks":
                    # look up the mapped/decrypted device in the tree
                    # the format we care about will be on it
                    try:
                        dm_dev = self.storage.devicetree.getChildren(device)[0]
                    except IndexError:
                        format = device.format
                    else:
                        format = dm_dev.format
                elif device:
                    format = device.format
                else:
                    format = None

                if format and format.mountable and format.mountpoint:
                    self.tree[iter]['Mount Point'] = format.mountpoint
                else:
                    self.tree[iter]['Mount Point'] = ""

		if format and format.type == "lvmpv":
		    vg = None
                    for _vg in self.storage.vgs:
                        if _vg.dependsOn(part):
                            vg = _vg
                            break
                    if vg and vg.name:
                        self.tree[iter]['Mount Point'] = vg.name
                    else:
                        self.tree[iter]['Mount Point'] = ""

                if device and device.format and \
                   device.format.type == "luks" and \
                   not device.format.exists:
                    self.tree[iter]['Format'] = self.lock_pixbuf
                elif format and not format.exists:
                    self.tree[iter]['Format'] = self.checkmark_pixbuf
		
                if format and format.type:
                    self.tree[iter]['IsFormattable'] = device.format.formattable

                if device and device.isExtended:
                    ptype = _("Extended")
                elif format and format.type == "mdmember":
                    ptype = _("software RAID")
                    mds = self.storage.mdarrays
                    array = None
                    for _array in mds:
                        if _array.dependsOn(device):
                            array = _array
                            break
                    if array:
                        if array.minor is not None:
                            mddevice = "%s" % array.path
                        else:
                            mddevice = "Auto"
                        self.tree[iter]['Mount Point'] = mddevice

		    else:
			self.tree[iter]['Mount Point'] = ""

                    if device.format.type == "luks" and \
                       not device.format.exists:
			self.tree[iter]['Format'] = self.lock_pixbuf
                else:
                    if format and format.type:
                        ptype = format.name
                    else:
                        ptype = _("Unknown")
                if part.type & parted.PARTITION_FREESPACE:
                    devstring = _("Free")
                    ptype = ""
                else:
                    devstring = device.name
                self.tree[iter]['Device'] = devstring
                if format and format.exists and \
                   getattr(format, "label", None):
                    self.tree[iter]['Label'] = "%s" % format.label
                else:
                    self.tree[iter]['Label'] = ""

                self.tree[iter]['Type'] = ptype
                size = part.getSize(unit="MB")
                if size < 1.0:
                    sizestr = "< 1"
                else:
                    sizestr = "%Ld" % (size)
                self.tree[iter]['Size (MB)'] = sizestr
                self.tree[iter]['PyObject'] = device

                part = part.nextPartition()

        self.treeView.expand_all()
        self.messageGraph.display()

    def barviewActivateCB(self):
        """ Should be called when we double click on a slice"""
        # This is a bit of a hack to make the double click on free space work.
        # This function is useful when the selected slice is a free space,
        # in any other case it calls self.treeActiveCB.

        # We first see if the double click was from a free space or from another
        # slice.
        sel_slice = self.stripeGraph.getSelectedSlice()

        if sel_slice == None:
            # This really should not happen. Do nothing.
            return

        # The selected slice is a free slice if the object contained in it is
        # None.
        if sel_slice.obj != None:
            # This is not a free slice, we should call treeActivateCB
            return self.treeActivateCB()
        else:
            # Display a create window according to the stripe object.
            # Get the device from the stripe.obj
            disp_stripe = self.stripeGraph.getDisplayed()
            if disp_stripe == None:
                # this should not happen
                return

            # Display a create dialog.
            stripe_dev = disp_stripe.obj
            if isinstance(stripe_dev, storage.DiskDevice):
                tempformat = self.storage.defaultFSType
                device = self.storage.newPartition(fmt_type=tempformat, size=200)
                self.editPartition(device, isNew = True)

            elif isinstance(stripe_dev, storage.LVMVolumeGroupDevice):
                self.editLVMLogicalVolume(vg = stripe_dev)
                return

    def treeActivateCB(self, *args):
        curr_dev = self.tree.getCurrentDevice()
        if isinstance(curr_dev, storage.PartitionDevice) \
                or isinstance(curr_dev, storage.LVMLogicalVolumeDevice) \
                or isinstance(curr_dev, storage.LVMVolumeGroupDevice) \
                or isinstance(curr_dev, storage.MDRaidArrayDevice):
            self.editCB()

        elif curr_dev == None:
            # Its probably a free space
            iparent = self.tree.getCurrentDeviceParent()
            if iparent == None:
                # it was not free space, it is a root row.
                return

            # We execute a create function given the type of parent that was
            # found.
            # FIXME: This code might repeat itself.  might be a good idea to
            # put it in a function.
            curr_parent = self.tree[iparent]["PyObject"]
            if isinstance(curr_parent, storage.DiskDevice):
                tempformat = self.storage.defaultFSType
                device = self.storage.newPartition(fmt_type=tempformat, size=200)
                self.editPartition(device, isNew = True)

            elif isinstance(curr_parent, storage.LVMVolumeGroupDevice):
                self.editLVMLogicalVolume(vg = curr_parent)
                return

    def treeSelectCB(self, selection, *args):
        # The edit and create buttons will be enabled if the user has chosen
        # something editable and/or deletable.
        self.deleteButton.set_sensitive(False)
        self.editButton.set_sensitive(False)

        # I have no idea why this iter might be None.  Its best to return
        # without any action.
        model, iter = selection.get_selected()
        if not iter:
            return

        # If we return because there is no parent, make sure we show the user
        # the infoGraph and no stripeGraph.  The 'create' and 'delete' buttons
        # will be deactivated.
        iparent = model.iter_parent(iter)
        if not iparent:
            self.stripeGraph.shutDown()
            self.messageGraph.display()
            return # This is a root row.

        # We destroy the message first.  We will make sure to repaint it later
        # if no stipe is displayed.  Can't destroy it at the end of this func
        # because it uncenters the created stripe, if any.
        self.messageGraph.destroy()

        device = model[iter]['PyObject']

        # See if we need to change what is in the canvas. In all possibilities
        # we must make sure we have the correct StripeGraph class.
        if not device:
            # This is free space.
            parent = self.tree[iparent]["PyObject"]
            if isinstance(parent, storage.DiskDevice):
                if not isinstance(self.stripeGraph, DiskStripeGraph):
                    self.stripeGraph.shutDown()
                    self.stripeGraph = DiskStripeGraph(self.storage,
                            drive = parent, cCB = self.tree.selectRowFromObj,
                            dcCB = self.barviewActivateCB)
                self.stripeGraph.setDisplayed(parent)

            elif isinstance(parent, storage.LVMVolumeGroupDevice):
                if not isinstance(self.stripeGraph, LVMStripeGraph):
                    self.stripeGraph.shutDown()
                    self.stripeGraph = LVMStripeGraph(self.storage,
                            vg = parent, cCB = self.tree.selectRowFromObj,
                            dcCB = self.barviewActivateCB)
                self.stripeGraph.setDisplayed(parent)

        elif isinstance(device, storage.DiskDevice):
            if not isinstance(self.stripeGraph, DiskStripeGraph):
                self.stripeGraph.shutDown()
                self.stripeGraph = DiskStripeGraph(self.storage,
                        drive = device,
                        cCB = self.tree.selectRowFromObj,
                        dcCB = self.barviewActivateCB)
            self.stripeGraph.setDisplayed(device)
            # this is deletable but not editable.
            self.deleteButton.set_sensitive(True)

        elif isinstance(device, storage.PartitionDevice):
            if not isinstance(self.stripeGraph, DiskStripeGraph):
                self.stripeGraph.shutDown()
                self.stripeGraph = DiskStripeGraph(self.storage,
                        drive = device.parents[0],
                        cCB = self.tree.selectRowFromObj,
                        dcCB = self.barviewActivateCB)
            self.stripeGraph.setDisplayed(device.parents[0])
            self.stripeGraph.selectSliceFromObj(device)
            if device.format.type == "lvmpv":
                self.deleteButton.set_sensitive(False)
                self.editButton.set_sensitive(False)
            elif device.format.type == "ntfs":
                self.deleteButton.set_sensitive(True)
            else:
                self.deleteButton.set_sensitive(True)
                self.editButton.set_sensitive(True)

        elif isinstance(device, storage.LVMVolumeGroupDevice):
            if not isinstance(self.stripeGraph, LVMStripeGraph):
                self.stripeGraph.shutDown()
                self.stripeGraph = LVMStripeGraph(self.storage, vg = device,
                        cCB = self.tree.selectRowFromObj,
                        dcCB = self.barviewActivateCB)
            self.stripeGraph.setDisplayed(device)
            self.deleteButton.set_sensitive(False)
            self.editButton.set_sensitive(False)

        elif isinstance(device, storage.LVMLogicalVolumeDevice):
            if not isinstance(self.stripeGraph, LVMStripeGraph):
                self.stripeGraph.shutDown()
                self.stripeGraph = LVMStripeGraph(self.storage, vg = device.vg,
                        cCB = self.tree.selectRowFromObj,
                        dcCB = self.barviewActivateCB)
            self.stripeGraph.setDisplayed(device.vg)
            self.stripeGraph.selectSliceFromObj(device)
            self.deleteButton.set_sensitive(False)
            self.editButton.set_sensitive(False)

        elif isinstance(device, storage.MDRaidArrayDevice):
            if not isinstance(self.stripeGraph, MDRaidArrayStripeGraph):
                self.stripeGraph.shutDown()
                self.stripeGraph = MDRaidArrayStripeGraph(self.storage,
                        md = device,
                        cCB = self.tree.selectRowFromObj,
                        dcCB = self.barviewActivateCB)
            self.stripeGraph.setDisplayed(device)
            self.deleteButton.set_sensitive(False)
            self.editButton.set_sensitive(False)

        else:
            # This means that the user selected something that is not showable
            # in the bar view.  Just show the information message.
            self.stripeGraph.shutDown()
            self.messageGraph.display()
            self.deleteButton.set_sensitive(False)
            self.editButton.set_sensitive(False)

    def deleteCB(self, widget):
        """ Right now we can say that if the device is partitioned we
            want to delete all of the devices it contains. At some point
            we will want to support creation and removal of partitionable
            devices. This will need some work when that time comes.
        """
        device = self.tree.getCurrentDevice()
        if device.format.type == "disklabel":
            if doClearPartitionedDevice(self.intf,
                                        self.storage,
                                        device):
                self.refresh()
        elif doDeleteDevice(self.intf,
                            self.storage,
                            device):
            if isinstance(device, storage.devices.DiskDevice) or \
               isinstance(device, storage.devices.PartitionDevice):
                justRedraw = False
            else:
                justRedraw = True
                if device.type == "lvmlv" and device in device.vg.lvs:
                    device.vg._removeLogVol(device)

            self.refresh(justRedraw=justRedraw)

    def createCB(self, *args):
        activate_create_partition = False
        free_part_available = hasFreeDiskSpace(self.storage)
        if free_part_available:
            activate_create_partition = True

        # Must check if all the possibilities are False.  In this case tell the
        # user that he can't create anything and the reasons.
        if (not activate_create_partition):
            self.intf.messageWindow(_("Cannot perform any creation action"),
                        _("Note that the creation action requires free space in one of the hard drives."),
                        custom_icon="warning")
            return

        tempformat = self.storage.defaultFSType
        print tempformat
        device = self.storage.newPartition(fmt_type=tempformat, size=200)
        self.editPartition(device, isNew = True)
        return

    def resetCB(self, *args):
        if not confirmResetPartitionState(self.intf):
            return

        self.stripeGraph.shutDown()
        self.storage.reset()
        self.tree.clear()
        self.populate()

    def refresh(self, justRedraw=None):
        log.debug("refresh: justRedraw=%s" % justRedraw)
        self.stripeGraph.shutDown()
        self.tree.clear()

        if justRedraw:
            rc = 0
        else:
            try:
                doPartitioning(self.storage)
                rc = 0
            except PartitioningError, msg:
                self.intf.messageWindow(_("Error Partitioning"),
                       _("Could not allocate requested partitions: %s.") % (msg),
                                        custom_icon="error")
                rc = -1
            except PartitioningWarning, msg:
                # XXX somebody other than me should make this look better
                # XXX this doesn't handle the 'delete /boot partition spec' case
                #     (it says 'add anyway')
                dialog = gtk.MessageDialog(self.parent, 0, gtk.MESSAGE_WARNING,
                                           gtk.BUTTONS_NONE,
                                           _("Warning: %s.") % (msg))
                gui.addFrame(dialog)
                button = gtk.Button(_("_Modify Partition"))
                dialog.add_action_widget(button, 1)
                button = gtk.Button(_("_Continue"))
                dialog.add_action_widget(button, 2)
                dialog.set_position(gtk.WIN_POS_CENTER)

                dialog.show_all()
                rc = dialog.run()
                dialog.destroy()
                
                if rc == 1:
                    rc = -1
                else:
                    rc = 0
                    all_devices = self.storage.devicetree.devices
                    bootDevs = [d for d in all_devices if d.bootable]
                    #if reqs:
                    #    for req in reqs:
                    #        req.ignoreBootConstraints = 1

	if not rc == -1:
	    self.populate()

        return rc

    def editCB(self, *args):
        device = self.tree.getCurrentDevice()
        reason = self.storage.deviceImmutable(device, ignoreProtected=True)
        if reason:
            self.intf.messageWindow(_("Unable To Edit"),
                                    _("You cannot edit this device:\n\n%s")
                                    % reason,
                                    custom_icon="error")
            return

        if device.type == "mdarray":
            self.editRaidArray(device)
        elif device.type == "lvmvg":
            self.editLVMVolumeGroup(device)
        elif device.type == "lvmlv":
            self.editLVMLogicalVolume(lv = device)
        elif isinstance(device, storage.devices.PartitionDevice):
            self.editPartition(device)

    # isNew implies that this request has never been successfully used before
    def editRaidArray(self, raiddev, isNew = False):
        # r_d_g -> raid_dialog_gui
        raideditor = r_d_g.RaidEditor(self.storage, self.intf, self.parent,
                raiddev, isNew)

        while True:
            actions = raideditor.run()

            for action in actions:
                # FIXME: this needs to handle exceptions
                self.storage.devicetree.registerAction(action)

	    if self.refresh(justRedraw=True):
                actions.reverse()
                for action in actions:
                    self.storage.devicetree.cancelAction(action)
                    if self.refresh():
                        raise RuntimeError, ("Returning partitions to state "
                                             "prior to RAID edit failed")
                continue
	    else:
		break

	raideditor.destroy()		


    def editPartition(self, device, isNew = False, restrictfs = None):
        # p_d_g -> partition_dialog_gui
        parteditor = p_d_g.PartitionEditor(self.anaconda, self.parent, device,
                isNew = isNew, restrictfs = restrictfs)

        while True:
            orig_device = copy.copy(device)
            actions = parteditor.run()

            for action in actions:
                # XXX we should handle exceptions here
                self.anaconda.id.storage.devicetree.registerAction(action)

            if self.refresh(justRedraw=not actions):
                # autopart failed -- cancel the actions and try to get
                # back to previous state
                actions.reverse()
                for action in actions:
                    self.anaconda.id.storage.devicetree.cancelAction(action)

                # FIXME: proper action/device management would be better
                if not isNew:
                    device.req_size = orig_device.req_size
                    device.req_base_size = orig_device.req_base_size
                    device.req_grow = orig_device.req_grow
                    device.req_max_size = orig_device.req_max_size
                    device.req_primary = orig_device.req_primary
                    device.req_disks = orig_device.req_disks

                if self.refresh():
                    # this worked before and doesn't now...
                    raise RuntimeError, ("Returning partitions to state "
                                         "prior to edit failed")
            else:
		break

	parteditor.destroy()
	return 1

    def editLVMVolumeGroup(self, device, isNew = False):
        # l_d_g -> lvm_dialog_gui
        vgeditor = l_d_g.VolumeGroupEditor(self.anaconda, self.intf, self.parent,
                device, isNew)

        while True:
            actions = vgeditor.run()

            for action in actions:
                # FIXME: handle exceptions
                self.storage.devicetree.registerAction(action)

	    if self.refresh(justRedraw=True):
                actions.reverse()
                for action in actions:
                    self.storage.devicetree.cancelAction(action)

                if self.refresh():
                    raise RuntimeError, ("Returning partitions to state "
                                         "prior to edit failed")
		continue
	    else:
		break

	vgeditor.destroy()

    def editLVMLogicalVolume (self, lv = None, vg = None):
        """Will be consistent with the state of things and use this funciton
        for creating and editing LVs.

        lv -- the logical volume to edit.  If this is set there is no need
              for the other two arguments.
        vg -- the volume group where the new lv is going to be created. This
              will only be relevant when we are createing an LV.
        """

        if lv != None:
            # l_d_g -> lvm_dialog_gui
            vgeditor = l_d_g.VolumeGroupEditor(self.anaconda, self.intf, self.parent,
                    lv.vg, isNew = False)
            lv = vgeditor.lvs[lv.lvname]
            isNew = False

        elif vg != None:
            # l_d_g -> lvm_dialog_gui
            vgeditor = l_d_g.VolumeGroupEditor(self.anaconda, self.intf, self.parent,
                    vg, isNew = False)
            tempvg = vgeditor.getTempVG()
            name = self.storage.createSuggestedLVName(tempvg)
            vgeditor.lvs[name] = {'name': name,
                              'size': vg.freeSpace,
                              'format': getFormat(self.storage.defaultFSType),
                              'stripes': 1,
                              'logSize': 0,
                              'snapshotSpace': 0,
                              'exists': False}
            lv = vgeditor.lvs[name]
            isNew = True

        else:
            # This is non-sense.
            return


        while True:
            vgeditor.editLogicalVolume(lv, isNew = isNew)
            actions = vgeditor.convertToActions();

            for action in actions:
                # FIXME: handle exceptions
                self.storage.devicetree.registerAction(action)

            if self.refresh(justRedraw=True):
                actions.reverse()
                for action in actions:
                    self.storage.devicetree.cancelAction(action)

                if self.refresh():
                    raise RuntimeError, ("Returning partitions to state "
                                         "prior to edit failed")
                continue
            else:
                break

        vgeditor.destroy()

    def getScreen(self, anaconda):
        self.anaconda = anaconda
        self.storage = anaconda.id.storage
        self.intf = anaconda.intf
        self.checkmark_pixbuf = gui.getPixbuf("checkMark.png")
        self.lock_pixbuf = gui.getPixbuf("gnome-lock.png")

        checkForSwapNoMatch(anaconda)

        # Beginning of the GTK stuff.
        # create the operational buttons
        buttonBox = gtk.HButtonBox()
        buttonBox.set_spacing(6)
        buttonBox.set_layout(gtk.BUTTONBOX_END)

        ops = ((_("_Create"), self.createCB),
               (_("_Edit"), self.editCB),
               (_("_Delete"), self.deleteCB),
               (_("Re_set"), self.resetCB))

        for label, cb in ops:
            button = gtk.Button(label)
            buttonBox.add (button)
            button.connect ("clicked", cb)

            # We need these to control their sensitivity.
            if label == _("_Edit"):
                self.editButton = button
                self.editButton.set_sensitive(False)
            elif label == _("_Delete"):
                self.deleteButton = button
                self.deleteButton.set_sensitive(False)

        # Create the disk tree (Fills the tree and the Bar View)
        self.tree = DiskTreeModel()
        self.treeView = self.tree.getTreeView()
        self.treeView.connect('row-activated', self.treeActivateCB)
        self.treeViewSelection = self.treeView.get_selection()
        self.treeViewSelection.connect("changed", self.treeSelectCB)
        self.stripeGraph = StripeGraph()
        self.messageGraph = MessageGraph(self.stripeGraph.getCanvas(),
                _("Please Select A Device"))
        self.populate(initial = 1)

        # Create the top scroll window
        # We don't actually need a *scroll* window but nuthing else worked.
        hadj = gtk.Adjustment(step_incr = 5.0)
        vadj = gtk.Adjustment(step_incr = 5.0)
        swt = gtk.ScrolledWindow(hadjustment = hadj, vadjustment = vadj)
        swt.add(self.stripeGraph.getCanvas())
        swt.set_policy(gtk.POLICY_AUTOMATIC, gtk.POLICY_AUTOMATIC)
        swt.set_shadow_type(gtk.SHADOW_IN)

        # Create the bottom scroll window
        swb = gtk.ScrolledWindow()
        swb.add(self.treeView)
        swb.set_policy(gtk.POLICY_AUTOMATIC, gtk.POLICY_AUTOMATIC)
        swb.set_shadow_type(gtk.SHADOW_IN)

        # Create main vertical box and add everything.
        MVbox = gtk.VBox(False, 5)
        MVbox.pack_start(swt, False, False)
        MVbox.pack_start(swb, True)
        MVbox.pack_start(buttonBox, False, False)
        MVbox.pack_start(gtk.HSeparator(), False)

        return MVbox
