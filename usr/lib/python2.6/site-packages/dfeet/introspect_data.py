import gtk
import gobject
import dbus_utils
import dbus
import _util

class Node:
    def __init__(self, model, parent = None):
        self.child_list = []
        self.parent = parent
        self.model = model
        self.expanded = False
        self.valid = True

        # default markup for signatures
        self.sig_props = 'foreground="#2E8B57" size="smaller"'
        self.name_props = 'foreground="#000000" size="smaller"'

    def on_selected(self, busname):
        # do nothing here but this is called whenever
        # a node is selected in the model so can be 
        # overridden (see Property class for example)
        pass

    def mark_tree_invalid(self):
        self.valid = False
        for child in self.child_list:
            child.mark_tree_invalid()

    def mark_valid(self):
        self.valid = True

    def reap_ivalid(self):
        for child in self.child_list:
            if child.reap_invalid():
                pass
        # FIXME - we need to reap items that are no longer valid
        return not self.valid

    def set_expanded(self, expanded):
        self.expanded = expanded

    def is_expanded(self):
        expanded = False
        if self.child_list:
            expanded = self.expanded

        return expanded

    def index(self, child):
        return self.child_list.index(child)

    def on_get_iter(self, path):
        op = self.child_list[path[0]]
        if len(path) == 1:
            return op
        else:
            return op.on_get_iter(path[1:])

    def get_path_pos(self):
        pos = 0
        if self.parent:
            pos = self.parent.index(self)

        return pos

    def get_next(self):
        next = None
        if self.parent:
            next = self.parent.get_next_child(self)

        return next

    def get_next_child(self, child):
        i = self.index(child)
        try:
            return self.child_list[i+1]
        except IndexError:
            return None

    def get_first_child(self):
        if self.child_list:
            return self.child_list[0]
        else:
            return None

    def get_nth_child(self, n):
        try:
            return self.child_list[n]
        except IndexError:
            return None

    def count_children(self):
        c = len(self.child_list)
        return c

    def _row_changed(self, path):
        iter = self.model.get_iter(path)
        self.model.row_changed(path, iter)

    def _row_inserted(self, path):
        iter = self.model.get_iter(path)
        self.model.row_inserted(path, iter)

    def _calculate_path(self, *append_args):
        p = [self.get_path_pos()]
        parent = self.parent
        while parent:
            p.insert(0, parent.get_path_pos())
            parent = parent.parent

        for pos in append_args:
            p.append(pos)

        return p

    def append(self, child):
        self.insert(-1, child)

    def insert(self, i, child):
        if i == -1:
            self.child_list.append(child)
            i = len(self.child_list) - 1
        else:
            self.child_list.insert(i, child)

        child_path = self._calculate_path(i)
        self._row_inserted(tuple(child_path))

        #my_path = tuple(child_path[0:-1])
        #my_iter = None
        #if my_path:
        #    my_iter = self.model.get_iter(my_path)

        #l = len(self.child_list)
        #reorder_list = range(l)
        #self.model.rows_reordered(my_path, my_iter, reorder_list)
        

        #if i < l - 1:
        #    last_path_item = len(path) - 1
        #    for n in range(i + 1, l):
        #        path[last_path_item] = n
        #        self._row_changed(tuple(path)) 

    def find(self, node):
        i = 0
        for path in self.child_list:
            spath = str(path)
            if spath >= node:
                return i 

            i+=1

        return -1

    def add(self, data):
        # every node needs to figure this out for themselves 
        pass

    def _add_child(self, child, data):
        child_path = None

        i = self.find(str(child))
        if i == -1:
            self.append(child)
        else:
            objpath = self.child_list[i]
            if str(objpath) == str(child):
                child = objpath
                child.mark_valid()
                child_path = tuple(self._calculate_path(i))
            else:
                self.insert(i, child)

        child.add(data)
        if child_path:
            child._row_changed(child_path)

    def get_icon_name(self):
        return None 

    def to_markup_str(self):
        return gobject.markup_escape_text(str(self))

    def _sig_list_to_string(self, sig_list):
        result = ''

        for sig in sig_list:
            if sig == []: 
                print sig_list
                return ''
            result += sig['type']
            if sig['name']:
                result += ' ' + sig['name']

            result += ', '

        # get rid of the last comma and space before returning 
        return result[0:-2]
        
    def _sig_list_to_markup(self, sig_list):
        result = ''

        for sig in sig_list:
            result += dbus_utils.sig_to_markup(sig['type'], self.sig_props)
            if sig['name']:
                result += ' <span ' + self.name_props + '>' + sig['name'] + '</span>'
            result += ', '

        # get rid of the last comma and space before returning 
        return result[0:-2]


""" 
Leaf nodes are in a special class because they have special functionality
The LeafNode class is a helper class which provide common functionality that 
is only of interest to leaf nodes
"""
class LeafNode(Node):
    def get_proxy_interface(self, bus, name):
        # it is not strictly necisary to traverse the tree
        # but it future proofs things just in case we move
        # or remove node types
        iface = ''
        obj_path = ''
        node = self.parent
        
        while node is not None:
            if isinstance(node, Interface):
                iface = str(node)

            if isinstance(node, ObjectPath):
                obj_path = str(node)

            node = node.parent

        if not (iface and obj_path):
            raise Exception('introspection tree is corrupt')

        proxy = bus.get_object(name, obj_path)
        iface = dbus.Interface(proxy, iface)

        return (proxy, iface)  

class Method(LeafNode):
    # tree path = (0,x,0,y,0,z)
    def __init__(self, model, parent, method, insig, outsig):
        LeafNode.__init__(self, model, parent)

        self.method = method
        self.insig = insig
        self.outsig = outsig

    def dbus_call(self, bus, name, *args):
        (proxy, iface) = self.get_proxy_interface(bus, name)
        func = getattr(iface, self.method)
        
        return func(*args)

    def to_markup_str(self):
        sig_props = 'foreground="#2E8B57" size="smaller"'
        name_props = ''
        result = self.method + '<span foreground="#FF00FF">(</span>'
        result += self._sig_list_to_markup(self.insig)
        result += '<span foreground="#FF00FF">)</span>'

        if self.outsig:
            result += '<span foreground="#A52A2A">' + u' \u27A1 ' + '</span>'
            result += '<span foreground="#FF00FF">(</span>' 
            result += self._sig_list_to_markup(self.outsig)
            result += '<span foreground="#FF00FF">)</span>'

        return result

    def get_icon_name(self):
        return 'dfeet-method'

    def __str__(self):
        result = self.method + '('
        result += self._sig_list_to_string(self.insig) + ')'
        
        if self.outsig:
            result += u' \u27A1 (' +  self._sig_list_to_string(self.outsig) + ')'
            
        return result

class Signal(LeafNode):
    # tree path = (0,x,0,y,1,z)
    def __init__(self, model, parent, signal, insig):
        self.signal = signal
        self.insig = insig

        LeafNode.__init__(self, model, parent)

    def dbus_call(self, bus, name, *args):
        # for testing out signals
        # this actually isn't going to work since I
        # can't spoof the sender unless I can own the name
        pass

    def get_icon_name(self):
        return 'dfeet-signal'

    def to_markup_str(self):
        sig_props = 'foreground="#2E8B57" size="smaller"'
        result = self.signal + '<span foreground="#FF00FF">(</span>'
        result += self._sig_list_to_markup(self.insig)
        result += '<span foreground="#FF00FF">)</span>'

        return result

    def __str__(self):
        result = self.signal + '('
        result += self._sig_list_to_string(self.insig) + ')'

        return result

class Property(LeafNode):
    # tree path = (0,x,0,y,2,z)
    def __init__(self, model, parent, property, sig, access):
        self.property = property
        self.sig = sig
        self.access = access
        self.value = None

        LeafNode.__init__(self, model, parent)

    def on_selected(self, busname):
        # when selected use the properties interface
        # to read a value if this is a read or
        # readwrite property
        if self.access.startswith('read'):
            bus = busname.get_bus()
            (proxy, iface) = self.get_proxy_interface(bus, busname.get_display_name())

            proxy.Get(iface.dbus_interface, 
                      self.property, 
                      dbus_interface='org.freedesktop.DBus.Properties',
                      reply_handler=self.property_get_handler,
                      error_handler=self.property_get_error_handler)


            
    def property_get_handler(self, value):
        self.value = value

        path =  tuple(self._calculate_path())
        self._row_changed(path)

    def property_get_error_handler(self, e):
        print e

    def dbus_call(self, bus, name, *args):
        # for testing out properties
        # this is not implemented yet
        pass

    def get_icon_name(self):
        icon = 'dfeet-property'
        if self.access == 'read':
            icon = 'dfeet-read-property'
        elif self.access == 'write':
            icon = 'dfeet-write-property'
        elif self.access == 'readwrite':
            icon = 'dfeet-readwrite-property'

        return icon

    def to_markup_str(self):
        self.sig_props = 'foreground="#2E8B57" size="smaller"'
        self.name_props = ''
        result = self._sig_list_to_markup(self.sig)

        if self.value:
            result += ' = ' + str(self.value)

        return result

    def __str__(self):
        result = self._sig_list_to_string(self.sig)
        if self.value:
            result += ' = ' + str(self.value)

        return result

class MethodLabel(Node):
    # tree path = (0,x,0,y,0)
    def __init__(self, model, parent):
        Node.__init__(self, model, parent)
        self.set_expanded(True)
        self._label = 'Methods'

    def add(self, data):
        method_list = data.keys()
        method_list.sort()
        for method_name in method_list:
            method = Method(self.model, self, method_name, data[method_name][0], data[method_name][1])
            self._add_child(method, None)

    def get_icon_name(self):
        return 'dfeet-method-category'


    def to_markup_str(self):
        return '<b>' + gobject.markup_escape_text(self._label) + '</b>'

    def __str__(self):
        return self._label

class SignalLabel(Node):
    # tree path = (0,x,0,y,1)
    def __init__(self, model, parent):
        Node.__init__(self, model, parent)
        self.set_expanded(True)
        self._label = 'Signals'

    def add(self, data):
        signal_list = data.keys()
        signal_list.sort()
        for signal_name in signal_list:
            signal = Signal(self.model, self, signal_name, data[signal_name][0])
            self._add_child(signal, None)

    def get_icon_name(self):
        return 'dfeet-signal-category'

    def to_markup_str(self):
        return '<b>' + gobject.markup_escape_text(self._label) + '</b>' 

    def __str__(self):
        return self._label

class PropertyLabel(Node):
    # tree path = (0,x,0,y,2)
    def __init__(self, model, parent):
        Node.__init__(self, model, parent)
        self.set_expanded(True)
        self._label = 'Properties'

    def add(self, data):
        property_list = data.keys()
        property_list.sort()
        for property_name in property_list:
            property = Property(self.model, self, property_name, data[property_name][0], data[property_name][1])
            self._add_child(property, None)

    def get_icon_name(self):
        return 'dfeet-property-category'

    def to_markup_str(self):
        return '<b>' + gobject.markup_escape_text(self._label) + '</b>'

    def __str__(self):
        return self._label

class Interface(Node):
    # tree path = (0,x,0,y)
    def __init__(self, model, parent, interface):
        self.iface = interface
        Node.__init__(self, model, parent)

    def add(self, data):
        method_data = data['methods']
        signal_data = data['signals']
        property_data = data['properties']

        if method_data:
            methods = MethodLabel(self.model, self)
            self._add_child(methods, method_data)

        if signal_data:
            signals = SignalLabel(self.model, self)
            self._add_child(signals, signal_data)

        if property_data:
            properties = PropertyLabel(self.model, self)
            self._add_child(properties, property_data)

    def __str__(self):
        return self.iface

class InterfaceLabel(Node):
    # tree path = (0,x,0)
    def __init__(self, model, parent):
        Node.__init__(self, model, parent)
        self.set_expanded(True)

        self._label='Interfaces'

    def add(self, data):
        iface_list = data.keys()
        iface_list.sort()
        for iface in iface_list:
            interface = Interface(self.model, self, iface)
            self._add_child(interface, data[iface])

    def to_markup_str(self):
        return '<b>' + gobject.markup_escape_text(self._label) + '</b>' 

    def __str__(self):
        return self._label

class ObjectPath(Node):
    # tree path = (0,x)
    def __init__(self, model, parent, path):
        self.path = path

        Node.__init__(self, model, parent)

    def add(self, data):
        iface_data = data['interfaces']

        interfaces = InterfaceLabel(self.model, self)
        self._add_child(interfaces, iface_data)

    def get_icon_name(self):
        return 'dfeet-object'

    def __str__(self):
        return self.path

class ObjectPathLabel(Node):
    # tree path = (0,)
    def __init__(self, model):
        #super(Node, self).__init__(model)
        Node.__init__(self, model)
        self.set_expanded(True)

        self._label='Object Paths'

    def add(self, data, node):
        obj_path = ObjectPath(self.model, self, node)

        self._add_child(obj_path, data)

    def to_markup_str(self):
        return '<b>' + gobject.markup_escape_text(self._label) + '</b>'

    def __str__(self):
        return self._label

class IntrospectData(gtk.GenericTreeModel):
    NUM_COL = 3 

    (SUBTREE_COL, 
     DISPLAY_COL,
     ICON_NAME_COL) = range(NUM_COL)

    COL_TYPES = (gobject.TYPE_PYOBJECT,
                 gobject.TYPE_STRING,
                 gobject.TYPE_STRING)

    """
    Path Values:
        (0,)          - "Object Paths"
        (0,x)         - object path
        (0,x,0)       - "Interfaces"
        (0,x,0,y)     - interface
        (0,x,0,y,0)   - "Methods"
        (0,x,0,y,1)   - "Signals"
        (0,x,0,y,2)   - "Properties"
        (0,x,0,y,0,z) - method signature
        (0,x,0,y,1,z) - signal signature
        (0,x,0,y,1,z) - property signature
    
    """ 
    
    def __init__(self):
        super(IntrospectData, self).__init__()

        self.object_paths = ObjectPathLabel(self)

    def append(self, parent_node, data):
        # mark the object path tree invalid if it already
        # exists so we can keep track of state and reap
        # any branches which are not in the new introspect
        # data
        i = self.object_paths.find(parent_node)
        if i >= 0:
            objpath = self.object_paths.child_list[i]
            if str(objpath) == parent_node:
                objpath.mark_tree_invalid()

        self.object_paths.add(data, parent_node)
        del(data)

    def on_get_flags(self):
        return gtk.TREE_MODEL_ITERS_PERSIST

    def on_get_n_columns(self):
        return self.NUM_COL

    def on_get_column_type(self, n):
        return self.COL_TYPES[n]

    def on_get_iter(self, path):
        if len(path) == 1:
            if path[0] > 0:
                return None
            return self.object_paths
        else:
            return self.object_paths.on_get_iter(path[1:])

    def on_get_path(self, rowref):
        pl = [rowref.get_path_pos()]
        parent = rowref.parent
        while parent:
            pl.insert(0, parent.get_path_pos())
            parent = parent.parent

        return tuple(pl)

    def on_get_value(self, rowref, column):
        if column == self.SUBTREE_COL:
            return rowref
        elif column == self.DISPLAY_COL:
            return rowref.to_markup_str()
        elif column == self.ICON_NAME_COL:
            return rowref.get_icon_name()
        else:
            raise InvalidColumnError(column) 

        return None

    def on_iter_next(self, rowref):
        try:
            return rowref.get_next()
        except:
            return None

    def on_iter_children(self, parent):
        if parent:
            return parent.get_first_child()

        return self.object_paths

    def on_iter_has_child(self, rowref):
        if rowref.get_first_child():
            return True
        else:
            return False

    def on_iter_n_children(self, rowref):
        if rowref:
            return rowref.count_children()

        return 1 

    def on_iter_nth_child(self, parent, n):
        if parent:
            return parent.get_nth_child(n)
        
        if n == 0:
            return self.object_paths
        else:
            return None
    
    def on_iter_parent(self, child):
        return child.parent

    def _node_to_str(self, node, prefix=''):
        if not node:
            return ""

        if prefix == None:
            prefix = ""

        result = prefix + str(node) + '\n'
        for child in node.child_list:
            result += self._node_to_str(child, prefix + '\t')
            
        return result 

    def __str__(self):

        return self._node_to_str(self.object_paths)

