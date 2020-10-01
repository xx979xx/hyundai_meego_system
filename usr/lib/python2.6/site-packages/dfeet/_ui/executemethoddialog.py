import gtk

from dfeet import _util

from uiloader import UILoader

class ExecuteMethodDialog:
    def __init__(self, busname, method):
        signal_dict = { 
                        'execute_dbus_method_cb' : self.execute_cb,
                        'execute_dialog_close_cb': self.close_cb
                      } 

        ui = UILoader(UILoader.UI_EXECUTEDIALOG)
        self.dialog = ui.get_root_widget()
        self.command_label = ui.get_widget('commandlabel1')
        self.notebook = ui.get_widget('notebook1')
        self.parameter_textview = ui.get_widget('parametertextview1')
        self.source_textview = ui.get_widget('sourcetextview1')
        self.notebook.set_tab_label_text(self.source_textview.get_parent(), 
                                         'Source')
        self.prettyprint_textview = ui.get_widget('prettyprinttextview1')
        self.notebook.set_tab_label_text(self.prettyprint_textview.get_parent(), 
                                         'Pretty Print')
        ui.connect_signals(signal_dict)

        self.busname = busname
        self.method = method

        # FIXME: get the interface and object path
        text = 'Execute ' + str(self.method) 
        self.command_label.set_text(text)

    def execute_cb(self, widget):
        # TODO: make call async, time it and add spinner to dialog 
        try:
            args = ()
            buf = self.parameter_textview.get_buffer()
            params = buf.get_text(buf.get_start_iter(), 
                                  buf.get_end_iter())
            if params:
                params = '(' + params + ',)'
                args = eval(params)

            result = self.method.dbus_call(self.busname.get_bus(), 
                              self.busname.get_display_name(),
                              *args)
        except Exception, e: # FIXME: treat D-Bus errors differently
                             #        from parameter errors?
            result = str(e) 

        if not result:
            result = 'This method did not return anything'
        else:
            result = str(result)

        # FIXME: Format results for pretty print
        self.prettyprint_textview.get_buffer().set_text(result)
        self.source_textview.get_buffer().set_text(result)

    def run(self):
        self.dialog.run()

    def close_cb(self, widget):
        self.dialog.destroy()
