import gtk

from dfeet import _util

class UILoader:
    instance = None
    
    UI_COUNT = 5 

    (UI_MAINWINDOW,
     UI_FILTERBOX,
     UI_INTROSPECTVIEW,
     UI_EXECUTEDIALOG,
     UI_ADDCONNECTIONDIALOG
    ) = range(UI_COUNT)

    # {ui_id: ((files,...), root widget)}
    _ui_map = {UI_MAINWINDOW     : (('default-actiongroup.ui','mainwindow.ui'), 
                                    'appwindow1'),
               UI_FILTERBOX      : (('filterbox.ui',),
                                    'filterbox_table1'),
               UI_INTROSPECTVIEW : (('introspectview.ui',),
                                    'introspectview_table1'),
               UI_EXECUTEDIALOG  : (('executedialog.ui',),
                                    'executedialog1'),
               UI_ADDCONNECTIONDIALOG  : (('addconnectiondialog.ui',),
                                          'add_connection_dialog1')
              }

    def __init__(self, ui):
        ui_dir = _util.get_ui_dir()
       
        ui_info = self._ui_map[ui]
        self.ui = gtk.Builder()

        #load ui files
        for file in ui_info[0]:
            self.ui.add_from_file(ui_dir + '/' + file)

        self.root_widget_name = ui_info[1]

    def get_widget(self, name):
        return self.ui.get_object(name)

    def get_root_widget(self):
        return self.get_widget(self.root_widget_name)

    def connect_signals(self, obj_or_map):
        self.ui.connect_signals(obj_or_map)

