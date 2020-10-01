import gtk

TYPE_ERROR='error'
TYPE_INFO='info'
TYPE_QUESTION='question'
TYPE_WARNING='message'
TYPE_YES_NO='yesno'
TYPE_CUSTOM_QUESTION='customquestion'

class GenericError (gtk.MessageDialog):
    TYPE_ERROR='error'
    TYPE_INFO='info'
    TYPE_QUESTION='question'
    TYPE_WARNING='message'
    TYPE_YES_NO='yesno'
    TYPE_CUSTOM_QUESTION='customquestion'
    
    def __init__ (self, type, primary_text, secondary_text, parent_dialog=None, broken_widget=None):
        buttons = gtk.BUTTONS_OK
        if type == TYPE_CUSTOM_QUESTION:
            real_type = gtk.MESSAGE_QUESTION
            buttons = gtk.BUTTONS_NONE
        elif type == TYPE_ERROR:
            real_type = gtk.MESSAGE_ERROR
        elif type == TYPE_INFO:
            real_type = gtk.MESSAGE_INFO
        elif type == TYPE_QUESTION:
            real_type = gtk.MESSAGE_QUESTION
        elif type == TYPE_WARNING:
            real_type = gtk.MESSAGE_WARNING
        elif type == TYPE_YES_NO:
            real_type = gtk.MESSAGE_QUESTION
            buttons = gtk.BUTTONS_YES_NO
        else:
            raise TypeError

        message = "<span size=\"larger\" weight=\"bold\">%s</span>\n\n%s" % (primary_text, secondary_text)
        gtk.MessageDialog.__init__ (self, parent_dialog,
                                    gtk.DIALOG_MODAL|gtk.DIALOG_DESTROY_WITH_PARENT,
                                    real_type,
                                    buttons,
                                    message)
        self.set_title ('')
        self.label.set_use_markup (True)
        if broken_widget != None:
            broken_widget.grab_focus ()
            if isinstance (broken_widget, gtk.Entry):
                broken_widget.select_region (0, -1)
        if parent_dialog:
            self.set_transient_for (parent_dialog)
        else:
            self.set_position (gtk.WIN_POS_MOUSE)

    def display (self):
        ret = self.run ()
        self.destroy ()
        return ret


class GenericQuestionError (GenericError):
    def __init__ (self, question_buttons, primary_text, secondary_text, parent_dialog=None, broken_widget=None):
        GenericError.__init__ (self, TYPE_CUSTOM_QUESTION, primary_text, secondary_text, parent_dialog, broken_widget)
        for (label, response_id) in question_buttons:
            self.add_button (label, response_id)

### Examples of Use:
###
### from GenericError import *
###
### GenericError (TYPE_ERROR, _("Computer on fire."), _("Your computer has accidentally lit itself on fire.  Please try using a fire extinguisher!")).display ()
### ---
### print GenericQuestionError ([(gtk.STOCK_CANCEL, gtk.RESPONSE_CANCEL), ('Foo', 1)], _("Foo?"), _("Do you want to <i>foo</i>???")).display ()
### ---
### w = gtk.Window (gtk.WINDOW_TOPLEVEL)
### w.set_default_size (300, 300)
### e = gtk.Entry ()
### e.insert_text ('foo')
### w.add (e)
### w.show_all ()
### 
### GenericError (TYPE_ERROR, _("Some Error"), _("Error text!"), w, e).display ()
