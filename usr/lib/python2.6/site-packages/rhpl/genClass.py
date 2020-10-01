"""Generates classes with useful methods from xml data structure definition
file (alchemist style).
"""
## Copyright (C) 2001 - 2003 Red Hat, Inc.
## Copyright (C) 2001 - 2003 Harald Hoyer <harald@redhat.com>

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

__author__ = "Harald Hoyer"
__date__ = "$Date$"
__version__ = "$Revision$"

import new
from UserList import UserList
import sys
import traceback
from types import *
# first some defines
true = (1==1)
false = not true

Alchemist = None
LIST = "LIST"
STRING = "STRING"
INT = "INT"
BOOL = "BOOL"
FLOAT = "FLOAT"
BASE64 = "BASE64"

ANONYMOUS = "ANONYMOUS"
PROTECTED = "PROTECTED"
ATOMIC = "ATOMIC"
TYPE = "TYPE"
FLAGS = "FLAGS"
SELF = "SELF"
NAME= "NAME"
PARENT = "PARENT"
CHILDKEYS = "CHILDKEYS"
##PRIMARYKEY = "PRIMARYKEY"
##TYPEKEY = "TYPEKEY"
StrictType = None

class ParseError(Exception):
   def __init__(self, arg):
      Exception.__init__(self, arg)

class GenClass:   
   """ this basic class will be common for all genClass generated classes
   and imported from a seperate module
   """
   def __init__(self, list = None, parent = None):
      """Constructor with the parent list and optional the Alchemist list."""
      self._attributes = self.__class__.Attributes
      self._parent = parent
      self.changed = false
      self._dead = 0

      # initialize all variables with None
      self._doClear()

      # Constructor with object
      if list != None and (parent == None) and isinstance(list, GenClass):
         self.apply(list)
         return

      if isinstance(list, Alchemist.Context):
         self.fromContext(list.getDataRoot().getChildByIndex(0))
         self.commit(changed = false)
         
      if isinstance(list, Alchemist.Data):
         self.fromContext(list)
         self.commit(changed = false)
      
   def commit(self, changed=true):
      """Stub"""
      raise NotImplemented

   def apply(self, other):
      """Stub"""
      raise NotImplemented

   def _doClear(self):
      """Stub"""
      raise NotImplemented

   def _addAttr(self):
      """Stub"""
      raise NotImplemented

   def _createAttr(self):
      """Stub"""
      raise NotImplemented

   def checkType(self, child, value):
      """Check the type of the value passed to an assignment"""
      if not StrictType:
         return

      type = self._attributes[child][TYPE]

      if type == BOOL:
         if value != None and value != true and value != false:
            raise TypeError

      elif value == None:
         return
      
      elif type == LIST:
         if (ANONYMOUS in self._attributes[child][FLAGS]) \
            and not isinstance(value, GenAClassList):
            raise TypeError
         elif not isinstance(value, GenClassList):
            raise TypeError
         
      elif type == STRING:
         if not isinstance(value, StringType) and not isinstance(value, unicode):
            raise TypeError
         
      elif type == BASE64:
         if not isinstance(value, StringType) and not isinstance(value, unicode):
            raise TypeError
         
      elif type == INT:
         if not isinstance(value, IntType):
            raise TypeError

      elif type == FLOAT:
         if not isinstance(value, FloatType):
            raise TypeError
      
   
   #
   # @brief returns the parent of this object
   # @return the parent of this object
   #
   def getParent(self):
      """Get the parent list"""
      return self._parent

   def _setParent(self, parent):
      """Set the parent list (private)"""
      self._parent = parent			
      
   def toContext(self, list):
      """Convert this list to the internal Alchemist representation."""
      if list == None:
         return
      if isinstance(list, Alchemist.Context):
         dr = list.getDataRoot()
         if dr.getNumChildren() == 0:
            dr.addChild(self._attributes[SELF][TYPE],
                        self._attributes[SELF][NAME])
         list = list.getDataRoot().getChildByIndex(0)

      if ANONYMOUS in self._attributes[SELF][FLAGS]:
         list.setAnonymous(1)
      if ATOMIC in self._attributes[SELF][FLAGS]:
         list.setAtomic(1)
      if PROTECTED in self._attributes[SELF][FLAGS]:
         list.setProtected(1)      

      return list

   def __str__(self):
      """String representation."""
      parentStr = self._attributes[SELF][NAME]
      return self._objToStr(parentStr)
      
   def _objToStr(self, parentStr = None):
      """Internal recursive object to string method."""
      retstr = ""
      if self._attributes[SELF][TYPE] == LIST \
             and (ANONYMOUS in self._attributes[SELF][FLAGS]) and len(self):
         # print numbers
         num = 1
         ckey = self._attributes[SELF][CHILDKEYS][0]
         attr = self._attributes[ckey]
         if attr[TYPE] == LIST:
            for child in self:
               retstr += child._objToStr("%s.%d" % (parentStr, num))
               num += 1
         else:
            for val in self:
               if val:
                  if attr[TYPE] != BOOL:
                     retstr += "%s.%d=%s\n" % (parentStr, num, str(val))
                  else:
                     if val: retstr += "%s.%d=true\n" % (parentStr, num)
                     else: retstr += "%s.%d=false\n" % (parentStr, num)
                  num += 1
            
         return retstr

      for child, attr in self._attributes.items():
         if child == SELF: continue

         val = None
         
         if hasattr(self, child):
            val = getattr(self, child)
            
         if attr[TYPE] != LIST:
            if val != None:
               if attr[TYPE] != BOOL:
                  retstr += "%s.%s=%s\n" % (parentStr, child, str(val))
               else:
                  if val: retstr += "%s.%s=true\n" % (parentStr, child)
                  else: retstr += "%s.%s=false\n" % (parentStr, child)
                
         else:
            if val != None:
               retstr += val._objToStr("%s.%s" % (parentStr, child))

      return retstr
      
   def _parseLine(self, vals, value):
      """Internal import method, which parses an snmp style assignment."""
      if len(vals) == 0:
         return
         
      key = vals[0]
      try:
         key = int(key)
      except:
         pass

      if len(vals) == 1:
         if (ANONYMOUS in self._attributes[SELF][FLAGS]):
            cname = self._attributes[SELF][CHILDKEYS][0]
            if isinstance(key, int) and len(self) >= int(key) :
               self[int(key)-1] = value
               return
            else:
               num = self._addAttr(cname)
               self[num] = value
               return
         else:
            if self._attributes[key][TYPE] == INT:
               setattr(self, key, int(value))
            elif self._attributes[key][TYPE] == BOOL:
               if value == "true":
                  setattr(self, key, true)
               elif value == "false":
                  setattr(self, key, false)
            else:
               setattr(self, key, value)            
         return
      else:
         if key == self._attributes[SELF][NAME]:
            self._parseLine(vals[1:], value)
            return

         if (ANONYMOUS in self._attributes[SELF][FLAGS]):
            cname = self._attributes[SELF][CHILDKEYS][0]
            if isinstance(key, int) and len(self) >= int(key) :
               self[int(key)-1]._parseLine(vals[1:], value)
               return
            else:
               num = self._addAttr(cname)
               self[num]._parseLine(vals[1:], value)
               return
         else:
            if hasattr(self, key) and getattr(self, key):
               getattr(self, key)._parseLine(vals[1:], value)
               return
            else:
               self._createAttr(key)._parseLine(vals[1:], value)

   def load(self, filename = None):
      import string
      if filename:
         file = open(filename, "r")
      else:
         file = sys.stdin
         
      lines = file.readlines()
      
      for line in lines:
         try:
            line = line[:-1]
            vals = string.split(line, "=")
            if len(vals) <= 1:
               continue
            key = vals[0]
            value = string.join(vals[1:], "=")
          
            vals = string.split(key, ".")
            self._parseLine(vals, value)
         except StandardException, e:
            pe = ParseError(_("Error parsing line: %s") % line)
            pe.args += e.args
            raise pe

   def save(self, filename = None):
      if filename:
         file = open(filename, "w")
      else:
         file = sys.stdout
      file.write(str(self))
   
   def fromContext(self, list):
      pass

   #
   # @brief deletes this object
   #
   def unlink(self):
      if self._dead:
         return
      self._dead = 1
      if self._parent != None and self._parent._dead:
         return
      parent = self._parent
      del self._parent
         
      self._doClear()
      if parent and hasattr(parent, "remove" + self._attributes[SELF][NAME]):
         getattr(parent, "remove" + self._attributes[SELF][NAME])(self)

   def modified(self):
      return self.changed
			
   def setChanged(self, val):
      self.changed = val
      if self._parent != None and val:
         self._parent.setChanged(val)
         
   def copy(self):
      # create new instance of ourselves
      n = self.newClass(self._attributes[SELF][NAME], None, None)
      n.apply(self)
      return n

def _install_funcs(baseclass):
   for i in baseclass.Attributes[SELF][CHILDKEYS]:
      val = baseclass.Attributes[i]
      funcs, allfuncs = baseclass.Attributes[SELF]['install_func'](baseclass, val)
      for func in funcs:
         f = getattr(baseclass, '_%sAttr' % func)         
         f = f.im_func
         defArgs = f.func_defaults[:-1]
         if defArgs != None and defArgs != ():
            defArgs = defArgs + (i,)
         else: 
            defArgs = (i,)
         nfunc = new.function(f.func_code, f.func_globals,
                              func + i, defArgs)
         setattr(baseclass, func + i,
                 new.instancemethod(nfunc, None, baseclass))

   #install_funcs = classmethod(install_funcs)

#
# Non-Anonymous List
#
class GenClassList(GenClass):
   def __init__(self, list = None, parent = None):
      GenClass.__init__(self, list, parent)

   def _doClear(self):
      for i in self._attributes[SELF][CHILDKEYS]:
         val = self._attributes[i]
         self.__dict__[i] = None
         self.__dict__['__' + i + '_bak'] = None
			      
   def test(self):
      for i in self._attributes[SELF][CHILDKEYS]:
         val = self._attributes[i]
         if val[TYPE] == LIST:
            if self.__dict__[i]:
               self.__dict__[i].test()
         else:
            getattr(self, "test" + i)(self.__dict__[i])

   def commit(self, changed=true):
      for i in self._attributes[SELF][CHILDKEYS]:
         val = self._attributes[i]
         if hasattr(self, "commit" + i):
            getattr(self, "commit" + i)(changed)
	
   def rollback(self):
      #print "----------- rollback %s -------" % self._attributes[SELF][NAME]
      for i in self._attributes[SELF][CHILDKEYS]:
         getattr(self, "rollback" + i)()

   def __str__(self):
      return GenClass.__str__(self)
      
   def apply(self, other):
      if other == None:
         self.unlink()
         return

      for i in self._attributes[SELF][CHILDKEYS]:
         val = self._attributes[i]
         if val[TYPE] != LIST:
            getattr(self, "set" + i)(getattr(other, "get" + i)())
         else:
            child = getattr(self, "create" + i)()
            if child != None:
               child.apply(getattr(other, "get" + i)())            
            
   def _testAttr(self, value, child=None):
      return 0

   def _getAttr(self, child=None):
      return self.__dict__[child]

   def _delAttr(self, child=None):
      self.__dict__[child] = None
	
   def __setattr__(self, name, value):
      if hasattr(self, "set" + name):
         getattr(self, "set" + name)(value)
      else:
         self.__dict__[name] = value

   def toContext(self, list):
      list = GenClass.toContext(self, list)
      if list == None: return
      
      for child in self._attributes[SELF][CHILDKEYS]:
         val = getattr(self, child)
         if self._attributes[child][TYPE] == LIST:
            if val != None:
               achild = list.addChild(self._attributes[child][TYPE],
                                      self._attributes[child][NAME])
               val.toContext(achild)
         else:
            if val != None:
               try:
                  achild = list.getChildByName(self._attributes[child][NAME])
               except KeyError:                  
                  achild = list.addChild(self._attributes[child][TYPE],
                                                self._attributes[child][NAME])
                  achild.setValue(val)
            else:
               if list.hasChildNamed(self._attributes[child][NAME]):
                  list.getChildByName(self._attributes[child][NAME]).unlink()

   def fromContext(self, list):
      if not list: return      
      if isinstance(list, Alchemist.Context):
         list = list.getDataRoot().getChildByIndex(0)

      GenClass.fromContext(self, list)
         
      for child in self._attributes[SELF][CHILDKEYS]:
         if self._attributes[child][TYPE] != LIST:
            setattr(self, child,
                    list.getChildByName(self._attributes[child][NAME]).getValue())
         else:
            achild = list.getChildByName(self._attributes[child][NAME])
            nchild = self.newClass(self._attributes[child][NAME],
                                   achild, self)
            setattr(self, child, nchild)

   def _commitAttr(self, changed=true, child=None):
      cd = getattr(self, child)
      
      if self._attributes[child][TYPE] == LIST:
         if hasattr(cd, "commit"):
            getattr(cd, "commit")(changed)

      if getattr(self, '__' + child + '_bak') != cd:
         #print "%s changed" % child
         self.setChanged(changed)			

      setattr(self, '__' + child + '_bak', cd)      

   def _rollbackAttr(self, child=None):
      if hasattr(self, '__' + child + '_bak'):
         setattr(self, child, getattr(self, '__' + child + '_bak'))

         if self._attributes[child][TYPE] == LIST:
            co = getattr(self, child)
            if hasattr(co, "rollback"):
               getattr(co, "rollback")()
      else:
         setattr(self, child, None)
      
   #
   # Non-List-Child functions
   #
   def _setAttr(self, value, child=None):
      self.checkType(child, value)
      self.__dict__[child] = value
      if isinstance(list, GenClass):
         value.setParent(self)

   #
   # List-Child functions
   #
   def _createAttr(self, child=None):
      val = getattr(self, child)
      if val == None:
         val = self.newClass(self._attributes[child][NAME], None, self)
         setattr(self, child, val)
      return val

   def _removeAttr(self, child, childname=None):
      val = getattr(self, childname)
      if child == val:
         child = val
         setattr(self, childname, None)
         child.unlink()

def GenClassList_get_install_funcs(klass, val):
   funcs = [ "get", "del", "test", "commit", "rollback" ]
   if val[TYPE] != LIST:
      funcs.append("set")
   else: 
      funcs.extend(["create" , "remove"])

   allfuncs = [ "get", "del", "test", "commit", "rollback",
                "set", "create" , "remove" ]

   return funcs, allfuncs
   #get_install_funcs = classmethod(get_install_funcs)

#
# Anonymous List
#
class GenClassAList(GenClass, UserList):
   def __init__(self, list = None, parent = None):
      UserList.__init__(self)
      GenClass.__init__(self, list, parent)

   def _doClear(self):
      self.data = []
      self.data_bak = []
			
   def test(self):
      for child in self.data:
         child.test()

   def __str__(self):
      return GenClass.__str__(self)

   def toContext(self, list):
      list = GenClass.toContext(self, list)
      if list == None: return
      
      for i in xrange(list.getNumChildren()):
         list.getChildByIndex(0).unlink()
         
      for i in self._attributes[SELF][CHILDKEYS]:
         val = self._attributes[i]         
         for child in self.data:
            nchild = list.addChild(self._attributes[i][TYPE],
                                   self._attributes[i][NAME])
            if val[TYPE] == LIST:
               child.toContext(nchild)
            else:
               nchild.setValue(child)
               
   def commit(self, changed=true):
      if self.data_bak != None and self.data == None:
         #print "%s changed" % self._attributes[SELF][NAME]
         self.setChanged(changed)
      elif self.data_bak == None and self.data != None:
         #print "%s changed" % self._attributes[SELF][NAME]
         self.setChanged(changed)
      elif len(self.data_bak) != len(self.data):
         #print "%s changed" % self._attributes[SELF][NAME]
         self.setChanged(changed)
      else:
         for i in xrange(0, len(self.data_bak)):
            if self.data_bak[i] != self.data[i]:
               #print "%s changed" % self._attributes[SELF][NAME]
               self.setChanged(changed)
               break
            
      for i in self._attributes[SELF][CHILDKEYS]:
         val = self._attributes[i]
               
         if val[TYPE] == LIST:
            for child in self.data:
               child.commit(changed)
         
      self.data_bak = self.data[:]
	
   def fromContext(self, list):
      if not list: return      
      if isinstance(list, Alchemist.Context):
         list = list.getDataRoot().getChildByIndex(0)

      GenClass.fromContext(self, list)
      for i in self._attributes[SELF][CHILDKEYS]:
         val = self._attributes[i]
         for pos in xrange(getattr(self, "getNum" + i)()):
            getattr(self, "del" + i)(0)

         if val[TYPE] == LIST:
            for j in xrange(list.getNumChildren()):
               child = self.newClass(self._attributes[i][NAME],
                                     list.getChildByIndex(j), self)
               self.data.append(child)
         else:
            for i in xrange(list.getNumChildren()):
               child = list.getChildByIndex(i)
               self.data.append(child.getValue())

   def rollback(self):
      for childkey in self._attributes[SELF][CHILDKEYS]:
         val = self._attributes[childkey]
         if val[TYPE] == LIST:               
            for child in self.data_bak:
               child.rollback()
      self.data = self.data_bak[:]
      
   def apply(self, other):
      if other == None:
         self.unlink()
         return

      for child in self._attributes[SELF][CHILDKEYS]:
         val = self._attributes[child]
         for pos in xrange(getattr(self, "getNum" + child)()):
            getattr(self, "del" + child)(0)

         if val[TYPE] != LIST:               
            for pos in xrange(getattr(other, "getNum" + child)()):
               getattr(self, "add" + child)()
               getattr(self, "set" + child)(pos,\
                                            getattr(other, "get" + child)(pos))
         else:
            for pos in xrange(getattr(other, "getNum" + child)()):
               getattr(self, "add" + child)()
               getattr(self, "get" + child)(pos).apply(\
                     getattr(other, "get" + child)(pos))

   def _getAttr(self, pos, child = None):
      return self.data[pos]

   def _delAttr(self, pos, child = None):
      self.data.pop(pos)
      return 0

   def _getNumAttr(self, child = None):
      return len(self.data)
   
   def _moveAttr(self, pos1, pos2, child = None):
      direct = 0
      if pos2 > pos1: direct = 1
      obj = self.data.pop(pos1)
      self.data.insert(obj, pos2 - direct)
      return 0

   def __setitem__(self, i, item):
      #print "------- %s::__setitem__  -------" % self._attributes[SELF][NAME]
      child = self._attributes[SELF][CHILDKEYS][0]
      self.checkType(child, item)
      if isinstance(item, GenClass):
         item._setParent(self)
      UserList.__setitem__(self, i, item)

   def __getslice__(self, i, j):
      return  UserList.__getslice__(self, i, j)

   def __setslice__(self, i, j, s):
      return UserList.__setslice__(self, i, j, s)
         
   def __delslice__(self, i, j):
      return UserList.__delslice__(self, i, j)

   def _addAttr(self, child = None):
      if self._attributes[child][TYPE] == LIST:
         nchild = self.newClass(self._attributes[child][NAME], None, self)
         self.data.append(nchild)
      else:
         self.data.append(None)         
      return len(self.data)-1

   #
   # List-Child functions
   #
   def _removeAttr(self, val, child = None):
      try: self.remove(val)
      except ValueError: pass

   def append(self, item):
      #print "------- %s::append()  -------" % self._attributes[SELF][NAME]
      UserList.append(self, item)
      if isinstance(item, GenClass):
         item._setParent(self)
		
   def insert(self, i, item):
      UserList.insert(self, i, item)
      item._setParent(self)

   #
   # Non-List-Child functions
   #
   def _setAttr(self, pos, value, child = None):
      #print "_setAttr"
      self.checkType(child, value)
      self.data[pos] = value
      return 0
         
def GenClassAList_get_install_funcs(klass, val):
   funcs = [ "get", "del", "move", "getNum" , "add", "set" ]

   allfuncs = [ "get", "del", "move", "getNum" , "add",
                "set", "remove" ]

   return funcs, allfuncs
   #get_install_funcs = classmethod(get_install_funcs)

def GenClass_new_class(attributes, myglobals):
   classname = attributes[SELF][NAME]
   if attributes[SELF][TYPE] != LIST:
      raise AttributeError
   
   if ANONYMOUS in attributes[SELF][FLAGS]:
      listtype = GenClassAList
      attributes[SELF]['install_func'] = GenClassAList_get_install_funcs
   else:
      listtype = GenClassList
      attributes[SELF]['install_func'] = GenClassList_get_install_funcs

   def GenClass_init_func(self, list=None, parent=None):
      if hasattr(self.__class__, "_ListClass"):
         self.__class__._ListClass.__init__(self, list, parent)

   def GenClass_newClass_func(self, classname, list=None, parent=None):
      klass = self.__class__._Globals[classname]
      if klass:
         return klass(list, parent)
      else: return None

   newclass = new.classobj(classname + '_base', (listtype,),
                           {'Attributes' : attributes,
                            '__init__' : GenClass_init_func,
                            '_ListClass' : listtype,
                            '_Globals' : myglobals,
                            'newClass' : GenClass_newClass_func})
   
   _install_funcs(newclass)


   implclass = new.classobj(classname, (newclass,),
                            {})
   return (newclass, implclass)

def __generateClassAlchemist(list, parent = None, optlower = false, myglobals = None):
   import Alchemist
    
   if myglobals.has_key(list.getName()):
      return 

   myglobals[list.getName()] = None

   attributes = { SELF: { NAME : list.getName(),
                          TYPE : LIST,                          
                          FLAGS : [],
                          PARENT : parent,
                          CHILDKEYS : []}}

   if list.isAnonymous():
      attributes[SELF][FLAGS].append(ANONYMOUS)

   if list.isAtomic():
      attributes[SELF][FLAGS].append(ATOMIC)
       
   if list.isProtected():
      attributes[SELF][FLAGS].append(PROTECTED)

   num = list.getNumChildren()
   retval = {}

   if parent: pname = parent + "." + attributes[SELF][NAME]
   else: pname = attributes[SELF][NAME]

   for i in xrange(num):
      child = list.getChildByIndex(i)

      if child.getType() == Alchemist.Data.ADM_TYPE_LIST:
         __generateClassAlchemist(child, pname, myglobals = myglobals)

   for i in xrange(num):
      child = list.getChildByIndex(i)
      cname = child.getName()
      if cname in attributes[SELF][CHILDKEYS]:
         continue

      if optlower: clname = str.lower(cname)
      else: clname = cname

      ctype = child.getType()

      attributes[cname] = { NAME : clname, TYPE : ctype, FLAGS : [] }
      attributes[SELF][CHILDKEYS].append(cname)
      
      if child.getType() == Alchemist.Data.ADM_TYPE_LIST:
         if child.isAnonymous():
            attributes[cname][FLAGS].append(ANONYMOUS)
            
         if child.isAtomic():
            attributes[cname][FLAGS].append(ATOMIC)

         if child.isProtected():
            attributes[cname][FLAGS].append(PROTECTED)

   baseclass, implclass = GenClass_new_class(attributes, myglobals)
   myglobals[list.getName() + '_base' ] = baseclass
   myglobals[list.getName() ] = implclass

def __GenClass_read_classfile_Alchemist(boxpath, mod = None, OptLower = false):
   bbc = Alchemist.Context(name = 'FileBlackBox', serial = 1)
   broot = bbc.getDataRoot()
   list = broot.addChild(Alchemist.Data.ADM_TYPE_LIST, 'box_cfg')
   list.addChild(Alchemist.Data.ADM_TYPE_STRING, 'path').setValue(boxpath)
   list.addChild(Alchemist.Data.ADM_TYPE_STRING,
                 'box_type').setValue('FileBlackBox')
   list.addChild(Alchemist.Data.ADM_TYPE_BOOL, 'readable').setValue(true)
   list.addChild(Alchemist.Data.ADM_TYPE_BOOL, 'writable').setValue(false)
   bb = FileBlackBox.FileBlackBox(list)

   if bb.errNo():
      print 'Error creating FileBlackBox: ' + bb.strError()
      sys.exit(10)

   if bb.isReadable():
      con = bb.read() 
      if con == None:
         if bb.errNo():
            print 'Error reading ' + boxpath +': ' + bb.strError()
            sys.exit(10)

   else:
      print 'Error: ' + boxpath + ' is not readable!'
      sys.exit(10)

   dr = con.getDataRoot().getChildByIndex(0)

   __generateClassAlchemist(dr, myglobals = mod.__dict__)

def __generateClass(list, parent = None, optlower = false, myglobals = None):
   listname = list.nodeName.encode()
   if myglobals.has_key(listname):
      return
    
   myglobals[listname] = None

   attributes = { SELF: { NAME : listname,
                          TYPE : LIST,                          
                          FLAGS : [],
                          PARENT : parent,
                          CHILDKEYS : []}}
    
   if "ANONYMOUS" in list.attributes.keys() and \
          unicode.upper(list.attributes["ANONYMOUS"].value) == "TRUE":
      attributes[SELF][FLAGS].append(ANONYMOUS)

   if "ATOMIC" in list.attributes.keys() and \
          unicode.upper(list.attributes["ATOMIC"].value) == "TRUE":
      attributes[SELF][FLAGS].append(ATOMIC)
      
   if "PROTECTED" in list.attributes.keys() and \
          unicode.upper(list.attributes["PROTECTED"].value) == "TRUE":
      attributes[SELF][FLAGS].append(PROTECTED)
      
   retval = {}

   if parent: pname = parent + "." + attributes[SELF][NAME]
   else: pname = attributes[SELF][NAME]

   for child in list.childNodes:
      if child.nodeType != child.ELEMENT_NODE:
         continue

      if "TYPE" in child.attributes.keys() and \
             unicode.upper(child.attributes["TYPE"].value) == "LIST":
         __generateClass(child, pname, myglobals = myglobals)

   childnum = 0
   
   for child in list.childNodes:
      if child.nodeType != child.ELEMENT_NODE:
         continue
      
      cname = child.nodeName.encode()
      if cname in attributes[SELF][CHILDKEYS]:
         continue

      childnum += 1

      if optlower: clname = str.OptLower(cname)
      else: clname = cname

      if "TYPE" in child.attributes.keys():
         ctype = unicode.upper(child.attributes["TYPE"].value)
         if ctype == "LIST": ctype = Alchemist.Data.ADM_TYPE_LIST
         elif ctype == "STRING": ctype = Alchemist.Data.ADM_TYPE_STRING
         elif ctype == "INT": ctype = Alchemist.Data.ADM_TYPE_INT
         elif ctype == "BOOL": ctype = Alchemist.Data.ADM_TYPE_BOOL
         elif ctype == "FLOAT": ctype = Alchemist.Data.ADM_TYPE_FLOAT
         elif ctype == "BASE64": ctype = Alchemist.Data.ADM_TYPE_BASE64
      else: raise NOCHILDATTR
         
      attributes[cname] = { NAME : clname, TYPE : ctype, FLAGS : [] }
      attributes[SELF][CHILDKEYS].append(cname)

      if ctype == Alchemist.Data.ADM_TYPE_LIST:
         if "ANONYMOUS" in child.attributes.keys() and \
                unicode.upper(child.attributes["ANONYMOUS"].value) == "TRUE":
            attributes[cname][FLAGS].append(ANONYMOUS)

         if "ATOMIC" in child.attributes.keys() and \
                unicode.upper(child.attributes["ATOMIC"].value) == "TRUE":
            attributes[cname][FLAGS].append(ATOMIC)
             
         if "PROTECTED" in child.attributes.keys() and \
                unicode.upper(child.attributes["PROTECTED"].value) == "TRUE":
            attributes[cname][FLAGS].append(PROTECTED)
##       else:
##          if "PRIMARYKEY" in child.attributes.keys():
##             attributes[cname][FLAGS].append(PRIMARYKEY)
##          if "TYPEKEY" in child.attributes.keys():
##             attributes[cname][FLAGS].append(TYPEKEY)

   baseclass, implclass = GenClass_new_class(attributes, myglobals)
   myglobals[listname + '_base' ] = baseclass
   myglobals[listname] = implclass

def __GenClass_read_classfile(boxpath, mod = None, OptLower = false):
   import xml.dom.minidom

   doc = xml.dom.minidom.parse(boxpath)
   dt = doc.childNodes[0].getElementsByTagName("datatree")[0]
   dr = None
   for e in dt.childNodes:
      if e.nodeType != e.ELEMENT_NODE:
         continue
      dr = e
      break
      
   __generateClass(dr, myglobals = mod.__dict__)

def GenClass_read_classfile(boxpath, mod, OptLower = false):
   """Load the classfile and use the Alchemist, if Use_Alchemist is set in the module"""
   global Alchemist
   global LIST
   global STRING
   global INT
   global BOOL
   global FLOAT
   global BASE64
   use_Alchemist = None
   if hasattr(mod, "Use_Alchemist"):
      use_Alchemist = getattr(mod, "Use_Alchemist")
      
   if use_Alchemist:
      import Alchemist
      LIST = Alchemist.Data.ADM_TYPE_LIST
      STRING = Alchemist.Data.ADM_TYPE_STRING
      INT = Alchemist.Data.ADM_TYPE_INT
      BOOL = Alchemist.Data.ADM_TYPE_BOOL
      FLOAT = Alchemist.Data.ADM_TYPE_FLOAT
      BASE64 = Alchemist.Data.ADM_TYPE_BASE64      
      __GenClass_read_classfile_Alchemist(boxpath, mod, OptLower)
   else:
      class Alchemist:
         class Data:
            ADM_TYPE_LIST = LIST
            ADM_TYPE_STRING = STRING
            ADM_TYPE_INT = INT
            ADM_TYPE_BOOL = BOOL
            ADM_TYPE_FLOAT = FLOAT
            ADM_TYPE_BASE64 = BASE64
            pass
      
         class Context:
            pass      

      __GenClass_read_classfile(boxpath, mod, OptLower)


__credits__ = """
Changelog:
$Log$
Revision 1.20  2006/07/25 09:26:03  harald
correctly parse bool values

Revision 1.19  2005/12/14 21:18:33  clumens
Stop using rhpl.log.

Revision 1.18  2003/04/29 10:39:23  harald
some restructuring and documentation

"""
      
