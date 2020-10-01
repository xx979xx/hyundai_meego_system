import gtk
from uiloader import UILoader

class AddConnectionDialog:
    def __init__(self, parent):
        ui = UILoader(UILoader.UI_ADDCONNECTIONDIALOG) 

        self.dialog = ui.get_root_widget()
        self.combo_entry = ui.get_widget('address_comboentry1')
        
        self.dialog.add_button('gtk-cancel', -1)
        self.dialog.add_button('gtk-connect', 1)

    def get_address(self):
        return self.combo_entry.get_active_text()

    def run(self):
        return self.dialog.run()

    def destroy(self):
        self.dialog.destroy()

