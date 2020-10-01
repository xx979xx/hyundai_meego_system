import dbus
import dbus.bus
import dbus.mainloop.glib
import gobject
import gtk
import _util
import _introspect_parser 
import os
import _ui.wnck_utils

from introspect_data import IntrospectData

SESSION_BUS = 1
SYSTEM_BUS = 2
ADDRESS_BUS = 3

dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)

class Error(Exception):
    pass

class BusAddressError(Error):
    def __init__(self, address):
        self.address = address

    def __str__(self):
        return repr('Bus address \'%s\' is not a valid bus address' % self.address)

class InvalidColumnError(Error):
    def __init__(self, col):
        self.column = col

    def __str__(self):
        return repr('Column number \'%i\' requested but is not valid' % self.column)

class CommonNameData(gobject.GObject):
    __gsignals__ = {
        'introspect_data_changed' : (gobject.SIGNAL_RUN_LAST, gobject.TYPE_NONE,())
                   }

    def __init__(self):
        super(CommonNameData, self).__init__()

        self.unique_name = None
        self.bus = None
        self.process_id = None
        self.process_path = None
        self.process_name = 'Unknown or Remote' 
        self._introspecting = False
        self._introspection_data = IntrospectData() 
        self._introspect_object_queue = []

    # there is a race condition here but D-Bus
    # doesn't have a signal for introspection data change
    # which would be impractical for some highly dynamic objects 
    def _introspect(self, name, node):
        self._introspecting = True
        obj = self.bus.get_object(name, node, follow_name_owner_changes=True)
        obj.Introspect(dbus_interface='org.freedesktop.DBus.Introspectable',
                       reply_handler=lambda xml: self._query_introspect_data_cb(name, node, xml),
                       error_handler=self._query_introspect_data_error_cb)

    def _query_introspect_data_error_cb(self, error):
        print error
        self._introspecting = False
        # errors are expected

    def _query_introspect_data_cb(self, name, parent_node, xml):
        self._introspecting = False
        data = _introspect_parser.process_introspection_data(xml)
        for node in data['child_nodes']:
            cnode = ''
            if parent_node != '/':
                cnode = parent_node
                
            cnode += '/' + node 
            self._introspect_object_queue.append(cnode)            

        if self._introspect_object_queue:
            obj = self._introspect_object_queue.pop(0)
            self._introspect(name, obj)

        if data['interfaces']:
            self._introspection_data.append(parent_node, data)
        
             
        self.emit('introspect_data_changed')
        
class BusName(gobject.GObject):
    __gsignals__ = {
        'changed' : (gobject.SIGNAL_RUN_LAST, gobject.TYPE_NONE,())
                   }


    def __init__(self, unique_name, bus, common_name = None, clone_from_busname = None):

        super(BusName, self).__init__()

        if not clone_from_busname:
            self.common_data = CommonNameData()
        else:
            self.common_data = clone_from_busname.common_data

        if common_name:
            self.set_common_name(str(common_name))
        else:
            self.clear_common_name()

        self.common_data.bus = bus
        self.common_data.unique_name = str(unique_name)
        self.common_data.connect('introspect_data_changed', 
                                 self._introspect_data_changed_cb)

        self.busname_is_public = not (not common_name)

    def query_introspect(self, node = '/'):
        self.common_data._introspect(self.get_display_name(), node)

    def _introspect_data_changed_cb(self, data):
        '''
        print "*********************************************"
        print len(data._introspection_data.object_paths.object_path_list)
        i = 0
        for o in data._introspection_data.object_paths.object_path_list:
            print i, o
            i+=1
        print "*********************************************"'''
        self.emit('changed')

    def set_common_name(self, common_name):
        self.busname_is_public = True
        self.common_name = common_name
        self.emit('changed')

    def get_display_name(self):
        if self.is_public():
            result = self.get_common_name()
        else:
            result = self.get_unique_name()

        return result

    def get_icon(self):
        icon_table = _ui.wnck_utils.IconTable.get_instance()
        return icon_table.get_icon(self.get_process_id())    

    def get_bus(self):
        return self.common_data.bus

    def clear_common_name(self):
        self.busname_is_public = False
        self.common_name = None

    def is_public(self):
        return self.busname_is_public

    def set_process_info(self, id, path):
        self.common_data.process_id = id
        self.common_data.process_path = path
        if path:
            self.common_data.process_name = os.path.basename(path[0])

        self.emit('changed')

    def get_unique_name(self):
        return self.common_data.unique_name

    def get_common_name(self):
        return self.common_name
    
    def get_process_id(self):
        return self.common_data.process_id
    
    def get_process_path(self):
        return self.common_data.process_path
    
    def get_process_name(self):
        return self.common_data.process_name

    def __str__(self):
        result = self.common_data.unique_name
        result += '\n    Process ID: '
        if self.common_data.process_id:
            result += str(self.common_data.process_id)
        else:
            result += 'Unknown'

        result += '\n    Process Name: '
        if self.common_data.process_path:
            result += self.common_data.process_name
        else:
            result += 'Unknown'

        result += '\n    Well Known Name'
        if not self.common_name:
            result += ': None'
        else:
            result += ': '
            result += self.common_name

        return result 

class BusWatch(gtk.GenericTreeModel):
    NUM_COL = 9 

    (BUSNAME_OBJ_COL, 
     UNIQUE_NAME_COL,
     COMMON_NAME_COL,
     IS_PUBLIC_COL,        # has a common name
     PROCESS_ID_COL,
     PROCESS_PATH_COL,
     PROCESS_NAME_COL,
     DISPLAY_COL,
     ICON_COL) = range(NUM_COL)

    COL_TYPES = (gobject.TYPE_PYOBJECT,
                 gobject.TYPE_STRING,
                 gobject.TYPE_STRING,
                 gobject.TYPE_BOOLEAN,
                 gobject.TYPE_STRING,
                 gobject.TYPE_PYOBJECT,
                 gobject.TYPE_STRING,
                 gobject.TYPE_STRING,
                 gtk.gdk.Pixbuf)

    def __init__(self, bus, address=None):
        self.bus = None
        self.unique_names = {}
        self.name_list = []
        self.bus_type = bus
        self.address = address
        #self.completion_model = gtk.ListStore()

        super(BusWatch, self).__init__()

        if bus == SESSION_BUS:
            self.bus = dbus.SessionBus()
        elif bus == SYSTEM_BUS:
            self.bus = dbus.SystemBus()
        else:
            if not address:
                raise BusAddressError(address)
            self.bus = dbus.bus.BusConnection(address)

            if not self.bus:
                raise BusAddressError(address)

        self.bus.add_signal_receiver(self.name_owner_changed_cb,
                                     dbus_interface='org.freedesktop.DBus',
                                     signal_name='NameOwnerChanged')

        bus_object = self.bus.get_object('org.freedesktop.DBus', 
                                         '/org/freedesktop/DBus')
        self.bus_interface = dbus.Interface(bus_object, 
                                            'org.freedesktop.DBus')

        self.bus_interface.ListNames(reply_handler=self.list_names_handler,
                                     error_handler=self.list_names_error_handler)

    def get_bus_name(self):
        if self.bus_type == SESSION_BUS:
            return "Session Bus"
        elif self.bus_type == SYSTEM_BUS:
            return "System Bus"
        else:
            return self.address

    def get_completion_model(self):
        return self.completion_model()

    def get_unix_process_id_cb(self, name, id):
        names = self.unique_names[name]
        if not names:
            return
        
        name = names[0]
        if not name:
            return

        process_path = _util.get_proc_from_pid(id)
        name.set_process_info(id, process_path)

    def get_unix_process_id_error_cb(self, name, error):
        print error

    # get the Unix process ID so we can associate the name
    # with a process (this will only work under Unix like OS's)
    def get_unix_process_id_async_helper(self, name):
         self.bus_interface.GetConnectionUnixProcessID(name, 
                reply_handler = lambda id: self.get_unix_process_id_cb(name, id),
                error_handler = lambda error: self.get_unix_process_id_error_cb(name, error))


    def name_changed_cb(self, name):
        path = (self.name_list.index(name,))
        iter = self.get_iter(path)
        self.row_changed(path, iter)

    # if name is not unique and owner is set add the name to the BusName object
    # else create a new BusName object
    def add_name(self, name, owner=None):
        if name[0] == ':':
            if self.unique_names.has_key(name):
                return

            busnameobj = BusName(name, self.bus)
            busnameobj.connect('changed', self.name_changed_cb)
            self.unique_names[name] = [busnameobj]
            self.get_unix_process_id_async_helper(name)
            self.name_list.append(busnameobj)
            path = (self.name_list.index(busnameobj),)
            iter = self.get_iter(path)
            self.row_inserted(path, iter) 
        else:
            if not owner:
                owner = self.bus_interface.GetNameOwner(name)
                if owner == 'org.freedesktop.DBus':
                    return 

            # if owner still does not exist then we move on
            if not owner:
                return

            if self.unique_names.has_key(owner):
                busnameobj = self.unique_names[owner][0]
                if busnameobj.is_public():
                    busnameobj = BusName(owner, self.bus, name, busnameobj)
                    self.unique_names[owner].append(busnameobj)
                    self.name_list.append(busnameobj)
                    path = (self.name_list.index(busnameobj),)
                    iter = self.get_iter(path)
                    self.row_inserted(path, iter)
                else:
                    busnameobj.set_common_name(name)

            else:
                busnameobj = BusName(owner, self.bus, name)
                self.unique_names[owner] = [busnameobj]
                self.name_list.append(busnameobj)
                self.get_unix_process_id_async_helper(owner)
                path = (self.name_list.index(busnameobj),)
                iter = self.get_iter(path)
                self.row_inserted(path, iter)

    def remove_name(self, name, owner=None):
        if not name:
            return

        if self.unique_names.has_key(name):
            busnames = self.unique_names[name]
            for n in busnames:
                self.remove_name(n.common_name, name)

            index = self.name_list.index(self.unique_names[name][0])
            self.name_list.pop(index)
            
            del(self.unique_names[name])
            self.row_deleted((index,))
        else:
            if not owner:
                return

            # names may have been deleted already
            if self.unique_names.has_key(owner):
                busnames = self.unique_names[owner]
                if len(busnames) == 1:
                    if busnames[0].common_name == name:
                        busnames[0].clear_common_name()
                        path = (self.name_list.index(busnames[0]),)
                        iter = self.get_iter(path)
                        self.row_changed(path, iter)
                else:
                    for n in busnames:
                        if n.common_name == name:
                            self.unique_names[owner].remove(n)
                            index = self.name_list.index(n)
                            self.name_list.pop(index)
                            self.row_deleted((index,))

    def name_owner_changed_cb(self, name, old_owner, new_owner):
        if name[0] == ':':
            if not old_owner:
                self.add_name(name)
            else:
                self.remove_name(name)

        else :
            if new_owner:
                self.add_name(name, new_owner)
            
            if old_owner:
                self.remove_name(name, old_owner)

    def list_names_handler(self, names):
        for n in names:
            self.add_name(n)

    def list_names_error_handler(self, error):
        print "error getting bus names - %s" % str(error)

    def get_name_list(self):
        return self.name_list

    def on_get_flags(self):
        return gtk.TREE_MODEL_ITERS_PERSIST

    def on_get_n_columns(self):
        return self.NUM_COL

    def on_get_column_type(self, n):
        return self.COL_TYPES[n]

    def on_get_iter(self, path):
        try:
            if len(path) == 1:
                return (self.name_list[path[0]],)
            else:
                return (self.name_list[path[0]],path[1])
        except IndexError:
            return None

    def on_get_path(self, rowref):
        index = self.files.index(rowref[0])
        if len(rowref) == 1:
            return (index,)
        else:
            return (index, rowref[1])

    def on_get_value(self, rowref, column):
        name = rowref[0]
        child = -1
        if len(rowref) > 1:
            child = rowref[1]

        if column == self.BUSNAME_OBJ_COL:
            return name 
        elif column == self.UNIQUE_NAME_COL:
            return name.get_unique_name()
        elif column == self.COMMON_NAME_COL:
            return name.get_common_name()
        elif column == self.IS_PUBLIC_COL:
            return name.is_public()
        elif column == self.PROCESS_ID_COL:
            return name.get_process_id()
        elif column == self.PROCESS_PATH_COL:
            return name.get_process_path()
        elif column == self.PROCESS_NAME_COL:
            return name.get_process_name()
        elif column == self.ICON_COL:
            return name.get_icon()
        elif column == self.DISPLAY_COL:
            if child == -1:
                return '<b>' + gobject.markup_escape_text(name.get_display_name()) + '</b>'
            elif child == 1:
                return '<b>Command Line: </b>' + gobject.markup_escape_text(name.get_process_name()) + ' (' + gobject.markup_escape_text(str(name.get_process_id())) + ')' 
            elif child == 0:
                return '<b>Unique Name: </b>'+ gobject.markup_escape_text(name.get_unique_name())
        else:
            raise InvalidColumnError(column) 

        return None

    def on_iter_next(self, rowref):
        try:
            name = rowref[0]
            child = -1
            if len(rowref) == 2:
                child = rowref[1]

            if child == 0:
                return (name, child +1)
            elif child == 1:
                return None
            else:
                i = self.name_list.index(rowref[0]) + 1
                return (self.name_list[i],)
        except IndexError:
            return None

    def on_iter_children(self, parent):
        if parent:
            if len(parent) == 1:
                return (parent[0], 0) 
            else:
                return None

        return (self.name_list[0],)

    def on_iter_has_child(self, rowref):
        return False
        if len(rowref) == 1:
            return True
        else:
            return False

    def on_iter_n_children(self, rowref):
        if rowref:
            if len(rowref) == 1:
                return 2
            else:
                return None

        return len(self.name_list)

    def on_iter_nth_child(self, parent, n):
        if parent:
            if n < 2:
                return (parent, n)
            else:
                return None
        try:
            return (self.name_list[n],)
        except IndexError:
            return None

    def on_iter_parent(self, child):
        return (child[0],) 

