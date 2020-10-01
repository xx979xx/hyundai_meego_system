## Copyright (C) 2001, 2002 Red Hat, Inc.
## Copyright (C) 2001, 2002 Than Ngo <than@redhat.com>
## Copyright (C) 2001, 2002 Harald Hoyer <harald@redhat.com>
## Copyright (C) 2001, 2002 Philipp Knirsch <pknirsch@redhat.com>

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

# This module manages SMB configuration file handling
# These classes are available:
# ConfSMB(Conf):
#  Implements a dictionary of dictionaries of bools, ints, and strings.
#  Toplevel key is a string representing a share
#  Second level keys are literals representing config options.
#  Booleans are set and stored as 0/1, but read in the file as any legal
#  value, including (case insensitive) 0/false/no and 1/true/yes
#  So: turn off browsing home directories with
#     smb['homes'] = [ 'browseable', 0 ]

import sys
if not "/usr/lib/rhs/python" in sys.path:
    sys.path.append("/usr/lib/rhs/python")
from string import *
from Conf import *
import re
import os
from UserDict import *

class ConfSMBSubDict(UserDict):
    def __init__(self, parent_conf, stanza, initdict=None):
        UserDict.__init__(self, initdict)
        self.conf = parent_conf
        self.stanza = stanza
        
    def __setitem__(self, varname, value):        
        self.conf.rewind()
        if not self.conf.find_stanza(self.stanza):
            raise Exception, "Unvalid stanza " + self.stanza

        if not value:
            return

        if self.conf.find_entry_in_current_stanza(varname):
            self.conf.sedline('=.*', '= ' + value)
        else:
            self.conf.insertline(varname + " = " + value)

        UserDict.__setitem__(self, varname, value)

    def __delitem__(self, varname):
        self.conf.rewind()
        if not self.conf.find_stanza(self.stanza):
            raise Exception, "Unvalid stanza " + self.stanza        
            
        if self.conf.find_entry_in_current_stanza(varname):
            self.conf.deleteline()
        else:
            raise Exception, "Unvalid entry " + varname + " in stanza " + self.stanza
        
        UserDict.__delitem__(self, varname)

# ConfSMB(Conf):
#  Implements a dictionary of dictionaries of bools, ints, and strings.
#  Toplevel key is a string representing a share
#  Second level keys are literals representing config options.
#  Booleans are set and stored as 0/1, but read in the file as any legal
#  value, including (case insensitive) 0/false/no and 1/true/yes
#  So: turn off browsing home directories with
#     smb['homes'][browseable] = 0
class ConfSMB(Conf):
    def __init__(self, filename='/etc/samba/smb.conf', create_if_missing=1):
        self.stanza_re = re.compile('^\s*\[(?P<stanza>[^\]]*)]\s*(?:;.*)?$', re.I)
        Conf.__init__(self, filename, '#;', '=', '=',
                      merge=1, create_if_missing = create_if_missing)
        
    def read(self):
        Conf.read(self)
        self.initvars()
        
    def initvars(self):
        self.vars = {}
        self.rewind()
        stanza = None
        while 1:
            stanza = self.next_stanza()
            if not stanza:
                break
            stanzavars = {}
            
            self.nextline()
            
            while self.findnextcodeline():
                #print "initvars: " + self.getline()
                vars = self.next_entry()
                if not vars:
                    break
                
                name = vars[0]
                value = vars[1]
                stanzavars[name] = value
                self.nextline()

            self.vars[stanza] = ConfSMBSubDict(self, stanza, stanzavars)
            
        self.rewind()

    def get_entry(self):
        vars = self.getfields()
            
        try:            
            vars = [vars[0], joinfields(vars[1:len(vars)], '=')]
        except(LookupError):
            return 0

        if not vars:
            return 0
      
        return [strip(vars[0]), strip(vars[1])]

    def next_entry(self):
        while self.findnextcodeline():
            #print "next_entry: " + self.getline()
            if self.is_stanza_decl():
                return 0
            
            vars = self.get_entry()
            
            if vars:
                return vars
            
            self.nextline()            
            
        return 0
                
    def findnextcodeline(self):
        return self.findnextline('^[\t ]*[\[A-Za-z_]+.*')
    
    def is_stanza_decl(self):
        # return true if the current line is of the form [...]
        if self.stanza_re.match(self.getline()):
            return 1
        return 0

    def find_stanza(self, stanza_name):
        # leave the current line at the first line of the stanza
        # (the first line after the [stanza_name] entry)
        self.rewind()
        while self.findnextline('^[\t ]*\[.*\]'):
            m = self.stanza_re.match(self.getline())

            if m and (stanza_name == m.group('stanza')):
                self.nextline()
                return 1
            
            self.nextline()
            
        self.rewind()
        return 0
                
    def next_stanza(self):
        # leave the current line at the first line of the stanza
        # (the first line after the [stanza_name] entry)
        while self.findnextline('^[\t ]*\[.*\]'):
            m = self.stanza_re.match(self.getline())
            if m:
                stanza = m.group('stanza')
                if stanza:
                    return stanza
                
            self.nextline()
            
        self.rewind()
        return 0
                
    def prevline(self):
        self.line = max([self.line - 1, 0])

    def find_entry_in_current_stanza(self, entry_name):
        # leave the current line at the entry_name line or before
        # the [...] line of the next stanza (or the end of the file)
        # if entry_name does not exist.
        while self.findnextcodeline():
            vars = self.next_entry()
            #print "find_entry_in_current_stanza: " + self.getline()
            if not vars:
                if self.is_stanza_decl():
                    #print "is stanza!"
                    self.line = self.line - 1
                    return 0
            else:
                name = vars[0]
                if name == entry_name:
                    return 1                
            self.nextline()
        return 0
        
    def __getitem__(self, stanza):
        if not self.has_key(stanza):
            self.rewind()
            if not self.find_stanza(stanza):
                self.fsf()
                self.insertline('[' + stanza + ']')
                self.nextline()
                self.vars[stanza] = ConfSMBSubDict(self, stanza)
                
        return self.vars[stanza]
        
    def __setitem__(self, stanza, value):
        if not self.has_key(stanza):
            self.rewind()
            if not self.find_stanza(stanza):
                self.fsf()
                self.insertline('[' + stanza + ']')
                self.nextline()
                
            if isinstance(value, ConfSMBSubDict):
                self.vars[stanza] = value
                return
            else:
                self.vars[stanza] = ConfSMBSubDict(self, stanza)
                    
        for i in value.keys():
            self.vars[stanza][i] = value[i]

    def __delitem__(self, stanza):
        del self.vars[stanza]
        self.rewind()
        if self.find_stanza(stanza):
            self.prevline()
            self.deleteline()
            while self.findnextcodeline():
                if self.is_stanza_decl():
                    break
                self.deleteline()

    def keys(self):
        # no need to return list in order here, I think.
        return self.vars.keys()
    
    def has_key(self, key):
        return self.vars.has_key(key)


if __name__ == '__main__':
    conf = ConfSMB(filename = '/etc/wvdial.conf')
    print conf.vars
    for confkey in conf.vars.keys():
        print "key:", confkey

    
