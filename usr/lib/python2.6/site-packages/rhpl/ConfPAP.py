## Copyright (C) 2001, 2002 Red Hat, Inc.
## Copyright (C) 2001, 2002 Harald Hoyer <harald@redhat.com>

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
import sys
from types import *

if not "/usr/lib/rhs/python" in sys.path:
    sys.path.append("/usr/lib/rhs/python")

import Conf

class ConfPAP(Conf.Conf):
    beginline = '####### redhat-config-network will overwrite this part!!! (begin) ##########'
    endline = '####### redhat-config-network will overwrite this part!!! (end) ############'
    
    def __init__(self, filename):
        self.beginlineplace = 0
        self.endlineplace = 0
        Conf.Conf.__init__(self, filename, '#', ' \t', ' \t')
        self.chmod(0600)

    def read(self):
        Conf.Conf.read(self)
        self.initvars()
        self.chmod(0600)

    def findline(self, val):
        # returns false if no more lines matching pattern
        while self.line < len(self.lines):
            if self.lines[self.line] == val:
                return 1
            self.line = self.line + 1
        # if while loop terminated, pattern not found.
        return 0

    def real_rewind(self):
        self.line = 0

    def rewind(self):
        self.line = self.beginlineplace

    def initvars(self):
        self.vars = {}
        self.beginlineplace = 0
        self.endlineplace = 0
        self.real_rewind()

        if not self.findline(self.beginline):
            self.insertline(self.beginline)

        self.beginlineplace = self.tell()
        
        if not self.findline(self.endline):
            self.seek(self.beginlineplace)
            self.nextline()
            self.insertline(self.endline)
        
        self.endlineplace = self.tell()
        
        self.real_rewind()

        while self.findnextcodeline():
            if self.tell() >= self.endlineplace:
                break
            # initialize dictionary of variable/name pairs
            # print self.getline()
            var = self.getfields()
                
            if var and (len(var) >= 3):
                if not self.vars.has_key(var[0]):
                    self.vars[var[0]] = {}
            self.vars[var[0]][var[1]] = var[2]
            
            self.nextline()
            
        self.rewind()

    def getfields(self):
        var = Conf.Conf.getfields(self)
        if len(var) and len(var[0]) and var[0][0] in '\'"':
            # found quote; strip from beginning and end
            quote = var[0][0]
            if var[0][-1] == quote:
                var[0] = var[0][1:-1]

        if len(var) >= 2 and len(var[1]) and var[1][0] in '\'"':
            # found quote; strip from beginning and end
            quote = var[1][0]
            if var[1][-1] == quote:
                var[1] = var[1][1:-1]

        if len(var) >= 3 and len(var[2]) and var[2][0] in '\'"':
            # found quote; strip from beginning and end
            quote = var[2][0]
            if var[2][-1] == quote:
                var[2] = var[2][1:-1]
        return var

    def insertline(self, line=''):
        place = self.tell()
        if place < self.beginlineplace:
            self.beginlineplace = self.beginlineplace + 1
            
        if place < self.endlineplace:
            self.endlineplace = self.endlineplace + 1
            
        self.lines.insert(self.line, line)

    def deleteline(self):
        place = self.tell()
        self.lines[self.line:self.line+1] = []
        
        if place < self.beginlineplace:
            self.beginlineplace = self.beginlineplace -1
            
        if place < self.endlineplace:
            self.endlineplace = self.endlineplace - 1

    def __getitem__(self, varname):
        if self.vars.has_key(varname):
            return self.vars[varname]
        else:
            return ''

    def __setitem__(self, varname, svalue):
        place=self.tell()
        self.rewind()
        missing=1

        if isinstance(varname, ListType):
            login = '\"' + varname[0] + '\"'
            server = '\"' + varname[1] + '\"'
        else:
            login = '\"' + varname + '\"'
            server = '*'

        value = '\"' + svalue + '\"'
            
        while self.findnextcodeline():
            if self.tell() >= self.endlineplace:
                break

            var = self.getfields()
            
            if var and (len(var) >= 3):                
                if login == var[0] and server == var[1]:
                        self.setfields([ login, server, value ] )
                        missing=0
            self.nextline()
            
        if missing:
            self.delallitem(varname)
            self.seek(self.endlineplace)
            self.insertlinelist([ login, server, value ] )
                

        if isinstance(varname, ListType):
            if not self.vars.has_key(varname[0]):
                self.vars[varname[0]] = {}
            self.vars[varname[0]][varname[1]] = svalue
        else:
            if not self.vars.has_key(varname):
                self.vars[varname] = {}
            self.vars[varname]["*"] = svalue

        self.seek(place)
        
    def __delitem__(self, varname):
        place=self.tell()
        self.rewind()
        if isinstance(varname, ListType):
            login = varname[0]
            server = varname[1]
        else:
            login = varname
            server = "*"        

        while self.findnextcodeline():
            if self.tell() >= self.endlineplace:
                break

            var = self.getfields()
            
            if var and (len(var) >= 3):                
                if login == var[0] and server == var[1]:
                    self.deleteline()
            self.nextline()
                    
        if self.vars.has_key(login):
            if self.vars[login].has_key(server):
                del self.vars[login][server]
            if not len(self.vars[login]):
                del self.vars[login]
        self.seek(place)

    def delallitem(self, varname):
        place=self.tell()
        self.rewind()
        # delete *every* instance...
        if isinstance(varname, ListType):
            login = varname[0]
            server = varname[1]
        else:
            login = varname
            server = "*"

        while self.findnextcodeline():
            var = self.getfields()
            
            if var and (len(var) >= 3):                
                if login == var[0] and server == var[1]:
                    self.deleteline()

            self.nextline()
                    
        if self.vars.has_key(login):
            if self.vars[login].has_key(server):
                del self.vars[login][server]
            if not len(self.vars[login]):
                del self.vars[login]

        self.seek(place)

    def has_key(self, key):
        if self.vars.has_key(key): return 1
        return 0
    
    def keys(self):
        return self.vars.keys()        

if __name__ == '__main__':
    pap = ConfPAP("/etc/ppp/pap-secrets")
    for key in pap.keys():
        print key + ' ' + str(pap[key])
        del pap[key]
        
    pap['test1'] = 'pappasswd1'
    pap['test2'] = 'pappasswd2'
    pap['test3'] = 'pappasswd3'
    pap[['test3', 'testserver']] = 'pappasswd3'


    print pap.lines

    pap.write()

