import gobject
import gtk

from dfeet.dbus_introspector import BusWatch

class BusNameView(gtk.TreeView):
    def __init__(self, watch):
        super(BusNameView, self).__init__()

        self.hide_private = False
        self.filter_string = None

        self.set_property('enable-search', True)
        self.set_property('enable-grid-lines', False)
        self.watch = watch
       
        self.filter_model = self.watch.filter_new()
        self.filter_model.set_visible_func(self._filter_cb)
        
        self.sort_model = gtk.TreeModelSort(self.filter_model)
        self.sort_model.set_sort_column_id(self.watch.COMMON_NAME_COL, gtk.SORT_ASCENDING)
        self.sort_model.set_sort_func(self.watch.COMMON_NAME_COL, self._sort_on_name, (self.watch.COMMON_NAME_COL, self.watch.UNIQUE_NAME_COL))

        renderer = gtk.CellRendererPixbuf()
        column = gtk.TreeViewColumn("", 
                                    renderer, 
                                    pixbuf=watch.ICON_COL
                                    )
        column.set_resizable(False)
        column.set_sort_column_id(watch.PROCESS_ID_COL)
        self.append_column(column)

        renderer = gtk.CellRendererText()
        column = gtk.TreeViewColumn("Bus Name", 
                                    renderer, 
                                    markup=watch.DISPLAY_COL
                                    )
        column.set_resizable(True)
        column.set_sort_column_id(watch.COMMON_NAME_COL)
        self.append_column(column)

        """
        column = gtk.TreeViewColumn("Unique Name", 
                                    renderer, 
                                    text=watch.UNIQUE_NAME_COL
                                    )
        column.set_resizable(True)
        column.set_sort_column_id(watch.UNIQUE_NAME_COL)
        self.append_column(column)
        """

        column = gtk.TreeViewColumn("Process", 
                                    renderer, 
                                    text=watch.PROCESS_NAME_COL
                                    )
        column.set_resizable(True)
        column.set_sort_column_id(watch.PROCESS_NAME_COL)
        self.append_column(column)

        """
        column = gtk.TreeViewColumn("PID", 
                                    renderer, 
                                    text=watch.PROCESS_ID_COL
                                    )
        column.set_resizable(True)
        column.set_sort_column_id(watch.PROCESS_ID_COL)
        self.append_column(column)
        """

        self.set_headers_clickable(True)
        self.set_reorderable(False)
        self.set_search_equal_func(self._search_cb)
        self.set_model(self.sort_model)

    def set_sort_column(self, col):
        self.sort_model.set_sort_column_id(col, gtk.SORT_ASCENDING)

    def set_hide_private(self, value):
        self.hide_private = value

    def set_filter_string(self, value):
        self.filter_string = value

    def refilter(self):
        self.filter_model.refilter()
        

    def _is_iter_equal(self, model, iter, key):
        (unique_name, 
         common_name, 
         process_id,
         process_path,
         is_public) = model.get(iter,
                                 BusWatch.UNIQUE_NAME_COL,
                                 BusWatch.COMMON_NAME_COL,
                                 BusWatch.PROCESS_ID_COL,
                                 BusWatch.PROCESS_PATH_COL,
                                 BusWatch.IS_PUBLIC_COL)

        if self.hide_private:
            if not is_public:
                return False

        # TODO: support filtering on introspect data
        if key:
            if (unique_name and unique_name.find(key)!=-1) or \
               (common_name and common_name.find(key)!=-1) or \
               str(process_id).startswith(key):
                return True
            
            if process_path:    
                for item in process_path:
                    if (item.find(key)!=-1):
                        return True

            return False

        return True


    def _search_cb(self, model, column, key, iter):
        return not self._is_iter_equal(model, iter, key)

    def _filter_cb(self, model, iter):
        return self._is_iter_equal(model, iter, self.filter_string)

    def _sort_on_name(self, model, iter1, iter2, cols):
        (col, alt_col) = cols

        un1 = model.get_value(iter1, col)
        un2 = model.get_value(iter2, col)

        if not un1:
            un1 = model.get_value(iter1, alt_col)
        
        if not un2:
            un2 = model.get_value(iter2, alt_col)

        # covert to integers if comparing two unique names        
        if un1[0] == ':' and un2[0] == ':':
           un1 = un1[1:].split('.')
           un1 = tuple(map(int, un1))

           un2 = un2[1:].split('.')
           un2 = tuple(map(int, un2))

        elif un1[0] == ':' and un2[0] != ':':
            return 1
        elif un1[0] != ':' and un2[0] == ':':
            return -1 
        else:
            un1 = un1.split('.')
            un2 = un2.split('.')

        if un1 == un2:
            return 0
        elif un1 > un2:
            return 1
        else:
            return -1


