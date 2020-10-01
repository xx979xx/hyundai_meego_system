import gobject 
import gtk
import gtk.glade

from dfeet import _util

from busnamebox import BusNameBox
from busnameinfobox import BusNameInfoBox
from uiloader import UILoader

class BusBox(gtk.VBox):
    __gsignals__ =  {
        'introspectnode-selected': (gobject.SIGNAL_RUN_LAST, gobject.TYPE_NONE,
                                   (gobject.TYPE_PYOBJECT,))
    }

    def __init__(self, watch):
        super(BusBox, self).__init__()

        # FilterBox
        signal_dict = { 
                        'hide_private_toggled' : self.hide_private_toggled_cb,
                        'filter_entry_changed': self.filter_entry_changed_cb
                      } 


        self.bus_watch = watch

        ui = UILoader(UILoader.UI_FILTERBOX)
        filter_box = ui.get_root_widget()
        filter_entry = ui.get_widget('filter_entry1')

        self.pack_start(filter_box, False, False)

        self.completion = gtk.EntryCompletion()
        self.completion.set_model(watch)
        self.completion.set_inline_completion(True)

        # older gtk+ does not support this method call
        # but it is not fatal
        try:
            self.completion.set_inline_selection(True)
        except:
            pass

        filter_entry.set_completion(self.completion)

        # Content
        self.paned = gtk.HPaned()
        self.busname_box = BusNameBox(watch)
        self.busname_info_box = BusNameInfoBox()

        self.busname_box.connect('busname-selected', self.busname_selected_cb)
        self.busname_info_box.connect('selected', self.busname_info_selected_cb)

        self.paned.pack1(self.busname_box)
        self.paned.pack2(self.busname_info_box)
        self.paned.set_position(200)
        self.pack_start(self.paned, True, True)

        ui.connect_signals(signal_dict)
        
    def busname_selected_cb(self, busname_box, busname):
        self.busname_info_box.set_busname(busname)

    def busname_info_selected_cb(self, busname_info_box, node):
        self.emit('introspectnode-selected', node)

    def get_selected_introspect_node(self):
        return self.busname_info_box.get_selected_node()

    def get_selected_busname(self):
        return self.busname_box.get_selected_busname()

    def filter_entry_changed_cb(self, entry, button):
        value = entry.get_text()
        if value == '':
            value = None

        self.busname_box.set_filter_string(value)

    def hide_private_toggled_cb(self, toggle):
        a = toggle.get_active()
        if a:
            toggle.set_label("Show Private")
        else:
            toggle.set_label("Hide Private")

        self.busname_box.set_hide_private(a)

    def sort_combo_changed_cb(self, combo):
        value = combo.get_active_text()
        self.busname_box.set_sort_col(value)

    def get_bus_watch(self):
        return self.bus_watch
