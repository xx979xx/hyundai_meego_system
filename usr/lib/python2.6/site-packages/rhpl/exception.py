# -*- coding: utf-8 -*-
## Copyright (C) 2001-2005 Red Hat, Inc.
## Copyright (C) 2001-2005 Harald Hoyer <harald@redhat.com>

## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.

## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.

## You should have received a copy of the GNU General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

"""Module for a userfriendly exception handling

Example code:

import sys

from rhpl.exception import action, error, exitcode, installExceptionHandler

installExceptionHandler("test", "1.0", gui=0, debug=0)

def exception_function():
    action("Trying to divide by zero")

    try:
        local_var_1 = 1
        local_var_2 = 0
        # test exception raised to show the effect
        local_var_3 = local_var_1 / local_var_2
    except:
        error("Does not seem to work!? :-)")
        exitcode(15)
        raise

if __name__ == '__main__':
    exception_function()
    sys.exit(0)

"""

import os, sys
from rhpl.translate import _

#
# __ExceptionWindow class
#
class __ExceptionWindow:
    def __init__ (self, text, component_name):
        import gtk
        win = gtk.Dialog(_("Exception Occurred"), None, gtk.DIALOG_MODAL)
        win.add_button(_("_Debug"), 0)
        win.add_button(_("_Save to file"), 1)
        win.add_button(gtk.STOCK_QUIT, 2)
        win.set_border_width(6)
        buffer = gtk.TextBuffer(None)
        buffer.set_text(text)
        textbox = gtk.TextView()
        textbox.set_buffer(buffer)
        textbox.set_property("editable", False)
        textbox.set_property("cursor_visible", False)
        sw = gtk.ScrolledWindow ()
        sw.set_shadow_type(gtk.SHADOW_IN)
        sw.add (textbox)
        sw.set_policy (gtk.POLICY_AUTOMATIC, gtk.POLICY_AUTOMATIC)
        hbox = gtk.HBox (False)
        hbox.set_border_width(6)
        txt = _("An unhandled exception has occurred.  This "
                          "is most likely a bug.  Please save the crash "
                          "dump and file a detailed bug "
                          "report against %s at "
                          "https://bugzilla.redhat.com/bugzilla") % \
                          component_name
        info = gtk.Label(txt)
        info.set_line_wrap(True)
        info.set_selectable(True)
        hbox.pack_start (sw, True)
        win.vbox.pack_start (info, False)
        win.vbox.pack_start (hbox, True)
        win.vbox.set_border_width(12)
        win.vbox.set_spacing(12)
        win.set_size_request (500, 300)
        win.set_position (gtk.WIN_POS_CENTER)
        contents = win.get_children()[0]
        win.show_all ()
        self.window = win
        self.rc = self.window.run ()
        self.window.destroy()

    def quit (self, dialog, button):
        self.rc = button

    def getrc (self):
        # I did it this way for future expantion
        # 0 is debug
        if self.rc == 0:
            return 1
        # 1 is save
        if self.rc == 1:
            return 2
        # 2 is OK
        elif self.rc == 2:
            return 0

__dumpHash = {}
# XXX do length limits on obj dumps.
def __dumpClass(instance, fd, level=0):
    import types
    global __dumpHash
    # protect from loops
    if not __dumpHash.has_key(instance):
        __dumpHash[instance] = None
    else:
        fd.write("Already dumped\n")
        return
    if (instance.__class__.__dict__.has_key("__str__") or
        instance.__class__.__dict__.has_key("__repr__")):
        fd.write("%s\n" % (instance,))
        return
    fd.write("%s instance, containing members:\n" %
             (instance.__class__.__name__))
    pad = ' ' * ((level) * 2)
    for key, value in instance.__dict__.items():
        if type(value) == types.ListType:
            fd.write("%s%s: [" % (pad, key))
            first = 1
            for item in value:
                if not first:
                    fd.write(", ")
                else:
                    first = 0
                if type(item) == types.InstanceType:
                    __dumpClass(item, fd, level + 1)
                else:
                    fd.write("%s" % (item,))
            fd.write("]\n")
        elif type(value) == types.DictType:
            fd.write("%s%s: {" % (pad, key))
            first = 1
            for k, v in value.items():
                if not first:
                    fd.write(", ")
                else:
                    first = 0
                if type(k) == types.StringType:
                    fd.write("'%s': " % (k,))
                else:
                    fd.write("%s: " % (k,))
                if type(v) == types.InstanceType:
                    __dumpClass(v, fd, level + 1)
                else:
                    fd.write("%s" % (v,))
            fd.write("}\n")
        elif type(value) == types.InstanceType:
            fd.write("%s%s: " % (pad, key))
            __dumpClass(value, fd, level + 1)
        else:
            fd.write("%s%s: %s\n" % (pad, key, value))

def __dumpException(out, text, tb):    
    from cPickle import Pickler
    p = Pickler(out)

    out.write(text)

    trace = tb
    while trace.tb_next:
        trace = trace.tb_next
    frame = trace.tb_frame
    out.write ("\nLocal variables in innermost frame:\n")
    try:
        for (key, value) in frame.f_locals.items():
            out.write ("%s: %s\n" % (key, value))
    except:
        pass


def __exceptionWindow(title, text, name):
    import gtk
    #print text
    win = __ExceptionWindow (text, name)
    
    return win.getrc ()


def __generic_error_dialog (message, parent_dialog,
                          message_type=None,
                          widget=None, page=0, broken_widget=None):
    import gtk
    if message_type == None:
        message_type = gtk.MESSAGE_ERROR
        
    dialog = gtk.MessageDialog(parent_dialog,
                               gtk.DIALOG_MODAL|gtk.DIALOG_DESTROY_WITH_PARENT,
                               message_type, gtk.BUTTONS_OK,
                               message)
    
    if widget != None:
        if isinstance (widget, gtk.CList):
            widget.select_row (page, 0)
        elif isinstance (widget, gtk.Notebook):
            widget.set_current_page (page)
    if broken_widget != None:
        broken_widget.grab_focus ()
        if isinstance (broken_widget, gtk.Entry):
            broken_widget.select_region (0, -1)

    if parent_dialog:
        dialog.set_position (gtk.WIN_POS_CENTER_ON_PARENT)
        dialog.set_transient_for(parent_dialog)
    else:
        dialog.set_position (gtk.WIN_POS_CENTER)

    ret = dialog.run ()
    dialog.destroy()
    return ret

__action_str = ""
def action(what):
    """Describe what you want to do actually.
    what - string
    """
    global __action_str
    __action_str = what

__error_str = ""
def error(what):
    """Describe what went wrong with a userfriendly text.
    what - string
    """
    global __error_str
    __error_str = what

__exitcode = 10
def exitcode(num):
    """The exitcode, with which the exception handling routine should call
    sys.exit().
    num - int(exitcode)
    """
    global __exitcode
    __exitcode = int(num)

def installExceptionHandler(progname, version, gui = 1, debug = 1):
    """
    Install the exception handling function.
    
    progname - the name of the application
    version  - the version of the application
    gui      - display a gtk dialog (0,1) to show the error message
    debug    - show the full traceback (with "Save to file" in GUI)    
    """
    sys.excepthook = lambda type, value, tb: handleException((type, value, tb), progname, version, gui, debug)
    
#
# handleException function
#
def handleException((type, value, tb), progname, version, gui = 1, debug = 1):
    """
    The exception handling function.

    progname - the name of the application
    version  - the version of the application
    gui      - display a gtk dialog (0,1) to show the error message
    debug    - show the full traceback (with "Save to file" in GUI)
    """
    global __action_str
    global __error_str
    global __exitcode
    if not debug:
        if not gui:
            print _("Error: %s: %s") % (__action_str, __error_str)
        else:
            import gtk
            text = _("%s\n\n%s:\n%s") % (progname, __action_str, __error_str)
            __generic_error_dialog(text, None)
            
        sys.exit(__exitcode)        

    # restore original exception handler
    sys.excepthook = sys.__excepthook__
            
    import os.path
    import md5
    from string import joinfields
    import traceback

    list = traceback.format_exception (type, value, tb)
    tblast = traceback.extract_tb(tb, limit=None)
    if len(tblast):
        tblast = tblast[len(tblast)-1]
    extxt = traceback.format_exception_only(type, value)
    if progname:
        text = "Component: %s\n" % progname
    if version:
        text = text + "Version: %s\n" % version
    text = text + "Summary: TB"
    if tblast and len(tblast) > 3:
        ll = []
        ll.extend(tblast[:3])
        ll[0] = os.path.basename(tblast[0])
        tblast = ll

    m = md5.new()
    ntext = ""
    for t in tblast:        
        ntext += str(t) + ":"
        m.update(str(t))


    text += str(m.hexdigest())[:8] + " " + ntext
    
    text += extxt[0]
    text += "\n"
    text += joinfields(list, "")

    trace = tb
    while trace.tb_next:
        trace = trace.tb_next
    frame = trace.tb_frame
    text += ("\nLocal variables in innermost frame:\n")
    try:
        for (key, value) in frame.f_locals.items():
            text += "%s: %s\n" % (key, value)
    except:
        pass

    if not gui:
        print text
        sys.exit(__exitcode)

    import gtk
    if not debug:
        __generic_error_dialog(text, None)
        sys.exit(__exitcode)        

    while 1:
        rc = __exceptionWindow (_("Exception Occurred"), text, progname)
        print text

        if rc == 1 and tb:
            import pdb
            import signal
            pdb.post_mortem (tb)
            os.kill(os.getpid(), signal.SIGKILL)
        elif not rc:
            sys.exit(__exitcode)
        else:
            d = gtk.FileChooserDialog(_("Specify a file to save the dump"),
                                      None, gtk.FILE_CHOOSER_ACTION_SAVE,
                                      (gtk.STOCK_CANCEL, gtk.RESPONSE_CANCEL,
                                       gtk.STOCK_SAVE, gtk.RESPONSE_OK))
            d.set_default_response(gtk.RESPONSE_OK)
            rc = d.run()
            if rc == gtk.RESPONSE_OK:
                file = d.get_filename()
                d.destroy()
                
                if not file or file=="":
                    file = "/tmp/dump"

                try:
                    out = open(file, "w")
                    out.write(text)
                    out.close()

                except IOError:
                    __generic_error_dialog(_("Failed to write to file %s.") \
                                         % (file), None)
                else:
                    __generic_error_dialog(
                        _("The application's state has been successfully "
                          "written to the file '%s'.\n\n"
                          "You can now attach this file to a bug report at "
                          "https://bugzilla.redhat.com/bugzilla") % (file), None,
                        message_type = "info")
                    sys.exit(__exitcode)
            else:
                d.destroy()
                continue

    sys.exit(__exitcode)



if __name__ == '__main__':
    def __exception_function():
        action("Trying to divide by zero")
        
        try:
            local_var_1 = 1
            local_var_2 = 0
            # test exception raised to show the effect
            local_var_3 = local_var_1 / local_var_2
        except:
            error("Does not seem to work!? :-)")
            exitcode(15)
            raise
        
    def __usage():
        print """%s [-dgh] [--debug] [--gui] [--help]
    -d, --debug
        Show the whole backtrace
        
    -g, --gui
        Display a gtk error dialog

    -h, --help
        Display this message""" % (sys.argv[0])

    import sys
    import getopt
    debug = 1
    gui = 0
    
    installExceptionHandler("test", "1.0", gui, debug)

    debug = 0

    class BadUsage: pass

    try:
        opts, args = getopt.getopt(sys.argv[1:], "dgh",
                                   [
                                    "debug", 
                                    "help",
                                    "gui",
                                    ])
    
        for opt, val in opts:
            if opt == '-d' or opt == '--debug':
                debug = 1
                continue

            if opt == '-g' or opt == '--gui':
                gui = 1
                continue

            if opt == '-h' or opt == '--help':
                __usage()
                sys.exit(0)
            
    except (getopt.error, BadUsage):
        __usage()
        sys.exit(1)    
    
    installExceptionHandler("test", "1.0", gui, debug)

    __exception_function()
    sys.exit(0)

__author__ = "Harald Hoyer <harald@redhat.com>"
