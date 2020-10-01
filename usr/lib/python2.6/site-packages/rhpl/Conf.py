# Copyright (C) 1996-2002 Red Hat, Inc.
# Use of this software is subject to the terms of the GNU General
# Public License

# This module manages standard configuration file handling
# These classes are available:
# Conf:
#  This is the base class.  This is good for working with just about
#  any line-oriented configuration file.
#  Currently does not deal with newline escaping; may never...
# ConfShellVar(Conf):
#  This is a derived class which implements a dictionary for standard
#  VARIABLE=value
#  shell variable setting.
#  Limitations:
#    o one variable per line
#    o assumes everything on the line after the '=' is the value
# ConfShellVarClone(ConfShellVar):
#  Takes a ConfShellVar instance and records in another ConfShellVar
#  "difference file" only those settings which conflict with the
#  original instance.  The delete operator does delete the variable
#  text in the cloned instance file, but that will not really delete
#  the shell variable that occurs, because it does not put an "unset"
#  command in the file.
# ConfESNetwork(ConfShellVar):
#  This is a derived class specifically intended for /etc/sysconfig/network
#  It is another dictionary, but magically fixes /etc/HOSTNAME when the
#  hostname is changed.
# ConfEHosts(Conf):
#  Yet another dictionary, this one for /etc/hosts
#  Dictionary keys are numeric IP addresses in string form, values are
#  2-item lists, the first item of which is the canonical hostname,
#  and the second of which is a list of nicknames.
# ConfEResolv(Conf):
#  Yet another dictionary, this one for /etc/resolv.conf
#  This ugly file has two different kinds of entries.  All but one
#  take the form "key list of arguments", but one entry (nameserver)
#  instead takes multiple lines of "key argument" pairs.
#  In this dictionary, all keys have the same name as the keys in
#  the file, EXCEPT that the multiple nameserver entries are all
#  stored under 'nameservers'.  Each value (even singleton values)
#  is a list.
# ConfESStaticRoutes(Conf):
#  Yet another dictionary, this one for /etc/sysconfig/static-routes
#  This file has a syntax similar to that of /etc/gateways;
#  the interface name is added and active/passive is deleted:
#  <interface> net <netaddr> netmask <netmask> gw <gateway>
#  The key is the interface, the value is a list of
#  [<netaddr>, <netmask>, <gateway>] lists
# ConfChat(Conf):
#  Not a dictionary!
#  This reads chat files, and writes a subset of chat files that
#  has all items enclosed in '' and has one expect/send pair on
#  each line.
#  Uses a list of two-element tuples.
# ConfChatFile(ConfChat):
#  This class is a ConfChat which it interprets as a netcfg-written
#  chat file with a certain amount of structure.  It interprets it
#  relative to information in an "ifcfg-" file (devconf) and has a
#  set of abortstrings that can be turned on and off.
#  It exports the following data items:
#    abortstrings   list of standard strings on which to abort
#    abortlist      list of alternative strings on which to abort
#    defabort       boolean: use the default abort strings or not
#    dialcmd        string containing dial command (ATDT, for instance)
#    phonenum       string containing phone number
#    chatlist       list containing chat script after CONNECT
#    chatfile       ConfChat instance
# ConfChatFileClone(ConfChatFile):
#  Creates a chatfile, then removes it if it is identical to the chat
#  file it clones.
# ConfDIP:
#  This reads chat files, and writes a dip file based on that chat script.
#  Takes three arguments:
#   o The chatfile
#   o The name of the dipfile
#   o The ConfSHellVar instance from which to take variables in the dipfile
# ConfModules(Conf)
#  This reads /etc/modprobe.conf into a dictionary keyed on device type,
#  holding dictionaries: cm['eth0']['alias'] --> 'smc-ultra'
#                        cm['eth0']['options'] --> {'io':'0x300', 'irq':'10'}
#                        cm['eth0']['post-install'] --> ['/bin/foo','arg1','arg2']
#  path[*] entries are ignored (but not removed)
#  New entries are added at the end to make sure that they
#  come after any path[*] entries.
#  Comments are delimited by initial '#'
# ConfModInfo(Conf)
#  This READ-ONLY class reads /boot/module-info.
#  The first line of /boot/module-info is "Version = <version>";
#  this class reads versions 0 and 1 module-info files.
# ConfPw(Conf)
#  This class implements a dictionary based on a :-separated file.
#  It takes as arguments the filename and the field number to key on;
#  The data provided is a list including all fields including the key.
#  Has its own write method to keep files sane.
# ConfPasswd(ConfPw)
#  This class presents a data-oriented class for making changes
#  to the /etc/passwd file.
# ConfShadow(ConfPw)
#  This class presents a data-oriented class for making changes
#  to the /etc/shadow file.
# ConfGroup(ConfPw)
#  This class presents a data-oriented class for making changes
#  to the /etc/group file.
#  May be replaced by a pwdb-based module, we hope.
# ConfUnix()
#  This class presents a data-oriented class which uses the ConfPasswd
#  and ConfShadow classes (if /etc/shadow exists) to hold data.
#  Designed to be replaced by a pwdb module eventually, we hope.
# ConfPAP(Conf):
#  Yet another dictionary, this one for /etc/ppp/pap-secrets
#  The key is the remotename, the value is a list of
#  [<user>, <secret>] lists
# ConfCHAP(ConfPAP):
#  Yet another dictionary, this one for /etc/ppp/chap-secrets
#  The key is the remotename, the value is a list of
#  [<local>, <secret>] lists
# ConfSecrets:
#  Has-a ConfPAP and ConfCHAP
#  Yet another dictionary, which reads from pap-secrets and
#  chap-secrets, and writes to both when an entry is set.
#  When conflicts occur while reading, the pap version is
#  used in preference to the chap version (this is arbitrary).
# ConfSysctl:
#  Guess what?  A dictionary, this time with key/value pairs for sysctl vars.
#  Duplicate keys get appended to existing values, and broken out again when
#  the file is written (does that even work?)

# This library exports several Errors, including
# FileMissing
#   Conf raises this error if create_if_missing == 0 and the file does not
#   exist
# IndexError
#   ConfShVar raises this error if unbalanced quotes are found
# BadFile
#   Raised to indicate improperly formatted files
# WrongMethod
#   Raised to indicate that the wrong method is being called.  May indicate
#   that a dictionary class should be written to through methods rather
#   than assignment.
# VersionMismatch
#   An unsupported file version was found.
# SystemFull
#   No more UIDs or GIDs are available

class FileMissing(Exception):
    def __init__(self, filename):
        self.filename = filename

    def __str__(self):
        return self.filename + " does not exist."

class IndexError(Exception):
    def __init__(self, filename, var):
        self.filename = filename
        self.var = var

    def __str__(self):
        return "end quote not found in %s: %s" % (self.filename, self.var[0])

class BadFile(Exception):
    def __init__(self, msg):
        self.msg = msg

    def __str__(self):
        return self.msg

WrongMethod = BadFile
VersionMismatch = BadFile
SystemFull = BadFile

from string import *
from UserDict import UserDict
import re
import os
import types
# Implementation:
# A configuration file is a list of lines.
# a line is a string.

class Conf:
    def __init__(self, filename, commenttype='#',
                 separators='\t ', separator='\t',
		 merge=1, create_if_missing=1):
        self.commenttype = commenttype
        self.separators = separators
        self.separator = separator
        self.codedict = {}
        self.splitdict = {}
	self.merge = merge
	self.create_if_missing = create_if_missing
        self.line = 0
	self.rcs = 0
        self.mode = -1
        # self.line is a "point" -- 0 is before the first line;
        # 1 is between the first and second lines, etc.
        # The "current" line is the line after the point.
        self.filename = filename
        self.read()
    def rewind(self):
        self.line = 0
    def fsf(self):
        self.line = len(self.lines)
    def tell(self):
        return self.line
    def seek(self, line):
        self.line = line
    def nextline(self):
        self.line = min([self.line + 1, len(self.lines)])
    def findnextline(self, regexp=None):
        # returns false if no more lines matching pattern
        while self.line < len(self.lines):
            if regexp:
                if hasattr(regexp, "search"):
                    if regexp.search(self.lines[self.line]):
                        return 1
                elif re.search(regexp, self.lines[self.line]):
                    return 1
            elif not regexp:
                return 1
            self.line = self.line + 1
        # if while loop terminated, pattern not found.
        return 0
    def findnextcodeline(self):
        # optional whitespace followed by non-comment character
        # defines a codeline.  blank lines, lines with only whitespace,
        # and comment lines do not count.
        if not self.codedict.has_key((self.separators, self.commenttype)):
            self.codedict[(self.separators, self.commenttype)] = \
                                           re.compile('^[' + self.separators \
                                                      + ']*' + '[^' + \
                                                      self.commenttype + \
                                                      self.separators + ']+')
        codereg = self.codedict[(self.separators, self.commenttype)]
        return self.findnextline(codereg)
    def findlinewithfield(self, fieldnum, value):
	if self.merge:
	    seps = '['+self.separators+']+'
	else:
	    seps = '['+self.separators+']'
	rx = '^'
	for i in range(fieldnum - 1):
	    rx = rx + '[^'+self.separators+']*' + seps
	rx = rx + value + '\(['+self.separators+']\|$\)'
	return self.findnextline(rx)
    def getline(self):
        if self.line >= len(self.lines):
            return ''        
        return self.lines[self.line]
    def getfields(self):
        # returns list of fields split by self.separators
        if self.line >= len(self.lines):
            return []
	if self.merge:
	    seps = '['+self.separators+']+'
	else:
	    seps = '['+self.separators+']'
        #print "re.split(%s, %s) = " % (self.lines[self.line], seps) + str(re.split(seps, self.lines[self.line]))

        if not self.splitdict.has_key(seps):
            self.splitdict[seps] = re.compile(seps)
        regexp = self.splitdict[seps]
        return regexp.split(self.lines[self.line])
    def setfields(self, list):
	# replaces current line with line built from list
	# appends if off the end of the array
	if self.line < len(self.lines):
	    self.deleteline()
	self.insertlinelist(list)
    def insertline(self, line=''):
        self.lines.insert(self.line, line)
    def insertlinelist(self, linelist):
        self.insertline(joinfields(linelist, self.separator))
    def sedline(self, pat, repl):
        if self.line < len(self.lines):
            self.lines[self.line] = re.sub(pat, repl, \
                                           self.lines[self.line])
    def changefield(self, fieldno, fieldtext):
        fields = self.getfields()
        fields[fieldno:fieldno+1] = [fieldtext]
        self.setfields(fields)
    def setline(self, line=[]):
        self.deleteline()
        self.insertline(line)
    def deleteline(self):
        self.lines[self.line:self.line+1] = []
    def chmod(self, mode=-1):
	self.mode = mode
    def read(self):
	file_exists = 0
        if os.path.isfile(self.filename):
	    file_exists = 1
	if not self.create_if_missing and not file_exists:
	    raise FileMissing, self.filename
	if file_exists and os.access(self.filename, os.R_OK):
            self.file = open(self.filename, 'r', -1)
            self.lines = self.file.readlines()
            # strip newlines
            for index in range(len(self.lines)):
                if len(self.lines[index]) and self.lines[index][-1] == '\n':
                    self.lines[index] = self.lines[index][:-1]
                if len(self.lines[index]) and self.lines[index][-1] == '\r':
                    self.lines[index] = self.lines[index][:-1]                
            self.file.close()
	else:
	    self.lines = []
    def write(self):
	# rcs checkout/checkin errors are thrown away, because they
	# aren't this tool's fault, and there's nothing much it could
	# do about them.  For example, if the file is already locked
	# by someone else, too bad!  This code is for keeping a trail,
	# not for managing contention.  Too many deadlocks that way...
	if self.rcs or os.path.exists(os.path.split(self.filename)[0]+'/RCS'):
	    self.rcs = 1
	    os.system('/usr/bin/co -l '+self.filename+' </dev/null >/dev/null 2>&1')
        self.file = open(self.filename, 'w', -1)
	if self.mode >= 0:
	    os.chmod(self.filename, self.mode)
        # add newlines
        for index in range(len(self.lines)):
            self.file.write(self.lines[index] + '\n')
        self.file.close()
	if self.rcs:
	    mode = os.stat(self.filename)[0]
	    os.system('/usr/bin/ci -u -m"control panel update" ' +
		      self.filename+' </dev/null >/dev/null 2>&1')
	    os.chmod(self.filename, mode)

class ConfShellVar(Conf):
    def __init__(self, filename):
        self.nextreg = re.compile('^[\t ]*[A-Za-z_][A-Za-z0-9_]*=')
        self.quotereg = re.compile('[ \t${}*@!~<>?;%^()#&=]')
        Conf.__init__(self, filename, commenttype='#',
                      separators='=', separator='=')
        
    def read(self):
        Conf.read(self)
        self.initvars()
    def initvars(self):
        self.vars = {}
        self.rewind()
        while self.findnextline(self.nextreg):
            # initialize dictionary of variable/name pairs
            var = self.getfields()
	    # fields 1..n are false separations on "=" character in string,
	    # so we need to join them back together.
	    var[1] = joinfields(var[1:len(var)], '=')
	    if len(var[1]) and var[1][0] in '\'"':
		# found quote; strip from beginning and end
		quote = var[1][0]
		var[1] = var[1][1:]
		p = -1
		try:
		    while cmp(var[1][p], quote):
			# ignore whitespace, etc.
			p = p - 1
		except:
                    raise IndexError (self.filename, var)
		var[1] = var[1][:p]
            else:
                var[1] = re.sub('#.*', '', var[1])
                
            self.vars[var[0]] = var[1]
            self.nextline()
        self.rewind()
    def __getitem__(self, varname):
        if self.vars.has_key(varname):
            return self.vars[varname]
        else:
            return ''
    def __setitem__(self, varname, value):
        # prevent tracebacks
        if not value:
            value=""
        # set *every* instance of varname to value to avoid surprises
        place=self.tell()
        self.rewind()
        missing=1
        while self.findnextline('^[\t ]*' + varname + '='):
            if self.quotereg.search(value):
        	self.sedline('=.*', "='" + value + "'")
	    else:
        	self.sedline('=.*', '=' + value)
            missing=0
            self.nextline()
        if missing:
            self.seek(place)
            if self.quotereg.search(value):
        	self.insertline(varname + "='" + value + "'")
	    else:
        	self.insertline(varname + '=' + value)
        
        self.vars[varname] = value

    def __delitem__(self, varname):
        # delete *every* instance...
        
        self.rewind()
        while self.findnextline('^[\t ]*' + varname + '='):
            self.deleteline()
	if self.vars.has_key(varname):
            del self.vars[varname]

    def has_key(self, key):
	if self.vars.has_key(key): return 1
	return 0
    def keys(self):
	return self.vars.keys()


# ConfShellVarClone(ConfShellVar):
#  Takes a ConfShellVar instance and records in another ConfShellVar
#  "difference file" only those settings which conflict with the
#  original instance.  The delete operator does delete the variable
#  text in the cloned instance file, but that will not really delete
#  the shell variable that occurs, because it does not put an "unset"
#  command in the file.
class ConfShellVarClone(ConfShellVar):
    def __init__(self, cloneInstance, filename):
        Conf.__init__(self, filename, commenttype='#',
                      separators='=', separator='=')
	self.ci = cloneInstance
    def __getitem__(self, varname):
        if self.vars.has_key(varname):
            return self.vars[varname]
        elif self.ci.has_key(varname):
	    return self.ci[varname]
	else:
            return ''
    def __setitem__(self, varname, value):
	if value != self.ci[varname]:
	    # differs from self.ci; save a local copy.
            ConfShellVar.__setitem__(self, varname, value)
	else:
	    # self.ci already has the variable with the same value,
	    # don't duplicate it
	    if self.vars.has_key(varname):
		del self[varname]
    # inherit delitem because we don't want to pass it through to self.ci
    def has_key(self, key):
	if self.vars.has_key(key): return 1
	if self.ci.has_key(key): return 1
	return 0
    # FIXME: should we implement keys()?


class ConfESNetwork(ConfShellVar):
    # explicitly for /etc/sysconfig/network: HOSTNAME is magical value
    # that writes /etc/HOSTNAME as well
    def __init__ (self):
	ConfShellVar.__init__(self, '/etc/sysconfig/network')
	self.writehostname = 0
    def __setitem__(self, varname, value):
	ConfShellVar.__setitem__(self, varname, value)
	if varname == 'HOSTNAME':
	    self.writehostname = 1
    def write(self):
	ConfShellVar.write(self)
	if self.writehostname:
	    file = open('/etc/HOSTNAME', 'w', -1)
	    file.write(self.vars['HOSTNAME'] + '\n')
	    file.close()
	    os.chmod('/etc/HOSTNAME', 0644)
    def keys(self):
	# There doesn't appear to be a need to return keys in order
	# here because we normally always have the same entries in this
	# file, and order isn't particularly important.
	return self.vars.keys()
    def has_key(self, key):
	return self.vars.has_key(key)


class ConfEHosts(Conf):
    # for /etc/hosts
    # implements a dictionary keyed by IP address, with values
    # consisting of a list: [ hostname, [list, of, nicknames] ]
    def __init__(self, filename = '/etc/hosts'):
        Conf.__init__(self, filename)

    def read(self):
        Conf.read(self)
        self.initvars()

    def initvars(self):
        self.vars = {}
        self.rewind()
        while self.findnextcodeline():
            # initialize dictionary of variable/name pairs
            var = self.getfields()
            if len(var) > 2:
		# has nicknames
                self.vars[var[0]] = [ var[1], var[2:] ]
	    elif len(var) > 1:
                self.vars[var[0]] = [ var[1], [] ]
	    else:
                pass
                # exception is a little bit hard.. just skip the line
		# raise BadFile, 'Malformed /etc/hosts file'
            self.nextline()
        self.rewind()

    def __getitem__(self, varname):
        if self.vars.has_key(varname):
            return self.vars[varname]
        else:
            return ''
        
    def __setitem__(self, varname, value):
        # set first (should be only) instance to values in list value
        place=self.tell()
        self.rewind()
        while self.findnextline('^\S*' + varname + '[' + \
                                self.separators + ']+'):
            self.deleteline()
            self.seek(place)

        self.insertlinelist([ varname, value[0],
                              joinfields(value[1], self.separator) ])
        self.vars[varname] = value
    def __delitem__(self, varname):
        # delete *every* instance...
        self.rewind()
        while self.findnextline('^\S*' + varname + '[' + \
                                self.separators + ']+'): 
            self.deleteline()
        del self.vars[varname]

    def keys(self):
	# It is rather important to return the keys in order here,
	# in order to maintain a consistent presentation in apps.
        place=self.tell()
        self.rewind()
        keys = []
        while self.findnextcodeline():
            # initialize dictionary of variable/name pairs
            var = self.getfields()
            if len(var) > 1:
                keys.append(var[0])
            self.nextline()
	self.seek(place)
	return keys

class ConfFHosts(Conf):
    # for /etc/hosts
    # implements a dictionary keyed by Hostname, with values
    # consisting of a list: [ IP-Adress, [list, of, nicknames] ]
    def __init__(self, filename = '/etc/hosts'):
        Conf.__init__(self, filename)

    def read(self):
        Conf.read(self)
        self.initvars()

    def initvars(self):
        self.vars = {}
        self.rewind()
        while self.findnextcodeline():
            # initialize dictionary of variable/name pairs
            var = self.getfields()
            if len(var) > 2:
		# has nicknames
                self.vars[var[1]] = [ var[0], var[2:] ]
	    elif len(var) > 1:
                self.vars[var[1]] = [ var[0], [] ]
	    else:
                # exception is a little bit hard.. just skip the line
		# raise BadFile, 'Malformed /etc/hosts file'
                pass
            self.nextline()
        self.rewind()

    def __getitem__(self, varname):
        if self.vars.has_key(varname):
            return self.vars[varname]
        else:
            return ''
        
    def __setitem__(self, varname, value):
        # set first (should be only) instance to values in list value
        place=self.tell()
        self.rewind()
        lastdel = place
        while self.findnextline('^\S*' + '[' + \
                                self.separators + ']+' + varname):
            self.deleteline()
            lastdel = self.tell()

        self.seek(lastdel)
        if type(value) != types.ListType and type(value) != types.TupleType:
            value = [ value, [] ]

        self.insertlinelist([ value[0], varname,
                              joinfields(value[1], self.separator) ])
        self.vars[varname] = value
        self.seek(place)

    def __delitem__(self, varname):
        # delete *every* instance...
        self.rewind()
        while self.findnextline('^\S*[' + self.separators + ']+' + varname): 
            self.deleteline()
        del self.vars[varname]

    def keys(self):
	# It is rather important to return the keys in order here,
	# in order to maintain a consistent presentation in apps.
        place=self.tell()
        self.rewind()
        keys = []
        while self.findnextcodeline():
            # initialize dictionary of variable/name pairs
            var = self.getfields()
            if len(var) > 1:
                keys.append(var[1])
            self.nextline()
	self.seek(place)
	return keys

class ConfEResolv(Conf):
    # /etc/resolv.conf
    def __init__(self):
	Conf.__init__(self, '/etc/resolv.conf', '#', '\t ', ' ')
    def read(self):
        Conf.read(self)
        self.initvars()
    def initvars(self):
        self.vars = {}
        self.rewind()
        while self.findnextcodeline():
            var = self.getfields()
	    if var[0] == 'nameserver':
		if self.vars.has_key('nameservers'):
		    self.vars['nameservers'].append(var[1])
		else:
		    self.vars['nameservers'] = [ var[1] ]
	    else:
		self.vars[var[0]] = var[1:]
            self.nextline()
        self.rewind()
    def __getitem__(self, varname):
        if self.vars.has_key(varname):
            return self.vars[varname]
        else:
            return []
    def __setitem__(self, varname, value):
        # set first (should be only) instance to values in list value
        place=self.tell()
        self.rewind()
	if varname == 'nameservers':
            if self.findnextline('^nameserver[' + self.separators + ']+'):
		# if there is a nameserver line, save the place,
		# remove all nameserver lines, then put in new ones in order
		placename=self.tell()
		while self.findnextline('^nameserver['+self.separators+']+'):
                    self.deleteline()
		self.seek(placename)
                for nameserver in value:
		    self.insertline('nameserver' + self.separator + nameserver)
		    self.nextline()
                self.seek(place)
            else:
		# no nameservers entries so far
                self.seek(place)
                for nameserver in value:
		    self.insertline('nameserver' + self.separator + nameserver)
	else:
	    # not a nameserver, so all items on one line...
            if self.findnextline('^' + varname + '[' + self.separators + ']+'):
                self.deleteline()
	        self.insertlinelist([ varname, 
                                      joinfields(value, self.separator) ])
                self.seek(place)
            else:
                self.seek(place)
	        self.insertlinelist([ varname,
                                      joinfields(value, self.separator) ])
	# no matter what, update our idea of the variable...
        self.vars[varname] = value

    def __delitem__(self, varname):
        # delete *every* instance...
        self.rewind()
        while self.findnextline('^[' + self.separators + ']*' + varname):
            self.deleteline()
        del self.vars[varname]

    def write(self):
	# Need to make sure __setitem__ is called for each item to
	# maintain consistancy, in case some did something like
	# resolv['nameservers'].append('123.123.123.123')
	# or
	# resolv['search'].append('another.domain')
	for key in self.vars.keys():
	    self[key] = self.vars[key]
            
        if self.filename != '/etc/resolv.conf':
            Conf.write(self)
        else:
            #  bug 125712: /etc/resolv.conf modifiers MUST use
            #  change_resolv_conf function to change resolv.conf
            import tempfile
            self.filename = tempfile.mktemp('','/tmp/')
            Conf.write(self)
            import commands
            commands.getstatusoutput("/bin/bash -c '. /etc/sysconfig/network-scripts/network-functions; change_resolv_conf "+self.filename+"'")
            self.filename="/etc/resolv.conf"
    def keys(self):
	# no need to return list in order here, I think.
	return self.vars.keys()
    def has_key(self, key):
	return self.vars.has_key(key)


# ConfESStaticRoutes(Conf):
#  Yet another dictionary, this one for /etc/sysconfig/static-routes
#  This file has a syntax similar to that of /etc/gateways;
#  the interface name is added and active/passive is deleted:
#  <interface> net <netaddr> netmask <netmask> gw <gateway>
#  The key is the interface, the value is a list of
#  [<netaddr>, <netmask>, <gateway>] lists
class ConfESStaticRoutes(Conf):
    def __init__(self):
	Conf.__init__(self, '/etc/sysconfig/static-routes', '#', '\t ', ' ')
    def read(self):
        Conf.read(self)
        self.initvars()
    def initvars(self):
        self.vars = {}
        self.rewind()
        while self.findnextcodeline():
            var = self.getfields()
	    if len(var) == 7:
		if not self.vars.has_key(var[0]):
		    self.vars[var[0]] = [[var[2], var[4], var[6]]]
		else:
		    self.vars[var[0]].append([var[2], var[4], var[6]])
	    elif len(var) == 5:
		if not self.vars.has_key(var[0]):
		    self.vars[var[0]] = [[var[2], var[4], '']]
		else:
		    self.vars[var[0]].append([var[2], var[4], ''])
            self.nextline()
        self.rewind()
    def __getitem__(self, varname):
        if self.vars.has_key(varname):
            return self.vars[varname]
        else:
            return [[]]
    def __setitem__(self, varname, value):
	raise WrongMethod, 'Delete or call addroute instead'
    def __delitem__(self, varname):
	# since we re-write the file completely on close, we don't
	# need to alter it piecemeal here.
        del self.vars[varname]
    def delroute(self, device, route):
	# deletes a route from a device if the route exists,
	# and if it is the only route for the device, removes
	# the device from the dictionary
	# Note: This could normally be optimized considerably,
	# except that our input may have come from the file,
	# which others may have hand-edited, and this makes it
	# possible for us to deal with hand-inserted multiple
	# identical routes in a reasonably correct way.
	if self.vars.has_key(device):
	    for i in range(len(self.vars[device])):
		if i < len(self.vars[device]) and \
		   not cmp(self.vars[device][i], route):
		    # need first comparison because list shrinks
		    self.vars[device][i:i+1] = []
		    if len(self.vars[device]) == 0:
			del self.vars[device]
    def addroute(self, device, route):
	# adds a route to a device, deleteing it first to avoid dups
	self.delroute(device, route)
	if self.vars.has_key(device):
	    self.vars[device].append(route)
	else:
	    self.vars[device] = [route]
    def write(self):
	# forget current version of file
	self.rewind()
	self.lines = []
	for device in self.vars.keys():
	    for route in self.vars[device]:
		if len(route) == 3:
		    if len(route[2]):
			self.insertlinelist((device, 'net', route[0],
                                             'netmask', route[1],
                                             'gw', route[2]))
		    else:
			self.insertlinelist((device, 'net', route[0],
                                             'netmask', route[1]))
	Conf.write(self)
    def keys(self):
	# no need to return list in order here, I think.
	return self.vars.keys()
    def has_key(self, key):
	return self.vars.has_key(key)



# ConfChat(Conf):
#  Not a dictionary!
#  This reads chat files, and writes a subset of chat files that
#  has all items enclosed in '' and has one expect/send pair on
#  each line.
#  Uses a list of two-element tuples.
class ConfChat(Conf):
    def __init__(self, filename):
	Conf.__init__(self, filename, '', '\t ', ' ')
    def read(self):
        Conf.read(self)
        self.initlist()
    def initlist(self):
	self.list = []
	i = 0
	hastick = 0
	s = '' 
	chatlist = []
	for line in self.lines:
	    s = s + line + ' '
	while i < len(s) and s[i] in " \t":
	    i = i + 1
	while i < len(s):
	    str = ''
	    # here i points to a new entry
	    if s[i] in "'":
		hastick = 1
		i = i + 1
		while i < len(s) and s[i] not in "'":
		    if s[i] in '\\':
			if not s[i+1] in " \t'":
			    str = str + '\\'
			i = i + 1
		    str = str + s[i]
		    i = i + 1
		# eat up the ending '
		i = i + 1
	    else:
		while i < len(s) and s[i] not in " \t":
		    str = str + s[i]
		    i = i + 1
	    chatlist.append(str)
	    # eat whitespace between strings
	    while i < len(s) and s[i] in ' \t':
		i = i + 1
	# now form self.list from chatlist
	if len(chatlist) % 2:
	    chatlist.append('')
	while chatlist:
	    self.list.append((chatlist[0], chatlist[1]))
	    chatlist[0:2] = []
    def getlist(self):
	return self.list
    def putlist(self, list):
	self.list = list
    def write(self):
	# create self.lines for Conf.write...
	self.lines = []
	for (p,q) in self.list:
	    p = re.sub("'", "\\'", p)
	    q = re.sub("'", "\\'", q)
	    self.lines.append("'"+p+"' '"+q+"'")
	Conf.write(self)



# ConfChatFile(ConfChat):
#  This class is a ConfChat which it interprets as a netcfg-written
#  chat file with a certain amount of structure.  It interprets it
#  relative to information in an "ifcfg-" file (devconf) and has a
#  set of abortstrings that can be turned on and off.
#  It exports the following data items:
#    abortstrings   list of standard strings on which to abort
#    abortlist      list of alternative strings on which to abort
#    defabort       boolean: use the default abort strings or not
#    dialcmd        string containing dial command (ATDT, for instance)
#    phonenum       string containing phone number
#    chatlist       list containing chat script after CONNECT
#    chatfile       ConfChat instance
class ConfChatFile(ConfChat):
    def __init__(self, filename, devconf, abortstrings=None):
	ConfChat.__init__(self, filename)
	self.abortstrings = abortstrings
	self.devconf = devconf
	self._initlist()
    def _initlist(self):
	self.abortlist = []
	self.defabort = 1
	self.dialcmd = ''
	self.phonenum = ''
	self.chatlist = []
	dialexp = re.compile('^ATD[TP]?[-0-9,. #*()+]+')
	if self.list:
	    for (p,q) in self.list:
        	if not cmp(p, 'ABORT'):
        	    if not q in self.abortstrings:
        		self.abortlist.append([p,q])
		elif not cmp(q, self.devconf['INITSTRING']):
		    # ignore INITSTRING
		    pass
                elif not self.dialcmd and dialexp.search(q):
                    #elif not self.dialcmd and tempmatch:
		    # First instance of something that looks like a dial
		    # command and a phone number we take as such.
		    tmp = re.search('[-0-9,. #*()+]+', q)
                    index=tmp.group(1)
		    self.dialcmd = q[:index]
		    self.phonenum = q[index:]
		elif not cmp(p, 'CONNECT'):
		    # ignore dial command
		    pass
		else:
		    self.chatlist.append([p,q])
    def _makelist(self):
	self.list = []
	if self.defabort:
	    for string in self.abortstrings:
		self.list.append(('ABORT', string))
	for string in self.abortlist:
	    self.list.append(('ABORT', string))
	self.list.append(('', self.devconf['INITSTRING']))
	self.list.append(('OK', self.dialcmd+self.phonenum))
	self.list.append(('CONNECT', ''))
	for pair in self.chatlist:
	    self.list.append(pair)
    def write(self):
	self._makelist()
	ConfChat.write(self)
 


# ConfChatFileClone(ConfChatFile):
#  Creates a chatfile, then removes it if it is identical to the chat
#  file it clones.
class ConfChatFileClone(ConfChatFile):
    def __init__(self, cloneInstance, filename, devconf, abortstrings=None):
	self.ci = cloneInstance
	ConfChatFile.__init__(self, filename, devconf, abortstrings)
	if not self.list:
	    self.list = []
	    for item in self.ci.list:
		self.list.append(item)
	    self._initlist()
    def write(self):
	self._makelist()
	if len(self.list) == len(self.ci.list):
	    for i in range(len(self.list)):
		if cmp(self.list[i], self.ci.list[i]):
		    # some element differs, so they are different
		    ConfChatFile.write(self)
		    return
	    # the loop completed, so they are the same
	    if os.path.isfile(self.filename): os.unlink(self.filename)
	else:
	    # lists are different lengths, so they are different
	    ConfChatFile.write(self)




# ConfDIP:
#  This reads chat files, and writes a dip file based on that chat script.
#  Takes three arguments:
#   o The chatfile
#   o The name of the dipfile
#   o The ConfSHellVar instance from which to take variables in the dipfile
class ConfDIP:
    def __init__(self, chatfile, dipfilename, configfile):
	self.dipfilename = dipfilename
	self.chatfile = chatfile
	self.cf = configfile
    def write(self):
        self.file = open(self.dipfilename, 'w', -1)
	os.chmod(self.dipfilename, 0600)
	self.file.write('# dip script for interface '+self.cf['DEVICE']+'\n' +
	  '# DO NOT HAND-EDIT; ALL CHANGES *WILL* BE LOST BY THE netcfg PROGRAM\n' +
	  '# This file is created automatically from several other files by netcfg\n' +
	  '# Re-run netcfg to modify this file\n\n' +
	  'main:\n' +
	  '  get $local '+self.cf['IPADDR']+'\n' +
	  '  get $remote '+self.cf['REMIP']+'\n' +
	  '  port '+self.cf['MODEMPORT']+'\n' +
	  '  speed '+self.cf['LINESPEED']+'\n')
	if self.cf['MTU']:
	    self.file.write('  get $mtu '+self.cf['MTU']+'\n')
	for pair in self.chatfile.list:
	    if cmp(pair[0], 'ABORT') and cmp(pair[0], 'TIMEOUT'):
		if pair[0]:
		    self.file.write('  wait '+pair[0]+' 30\n' +
			    '  if $errlvl != 0 goto error\n')
		self.file.write('  send '+pair[1]+'\\r\\n\n' +
			'  if $errlvl != 0 goto error\n')
	if not cmp(self.cf['DEFROUTE'], 'yes'):
	    self.file.write('  default\n')
	self.file.write('  mode '+self.cf['MODE']+'\n' +
	  '  exit\n' +
	  'error:\n' +
	  '  print connection to $remote failed.\n')
        self.file.close()


class odict(UserDict):
    def __init__(self, dict = None):
        self._keys = []
        UserDict.__init__(self, dict)

    def __delitem__(self, key):
        UserDict.__delitem__(self, key)
        self._keys.remove(key)

    def __setitem__(self, key, item):
        #print "[%s] = %s" % (str(key), str(item))
        UserDict.__setitem__(self, key, item)
        if key not in self._keys: self._keys.append(key)

    def clear(self):
        UserDict.clear(self)
        self._keys = []

    def copy(self):
        dict = UserDict.copy(self)
        dict._keys = self._keys[:]
        return dict

    def items(self):
        return zip(self._keys, self.values())

    def keys(self):
        return self._keys

    def popitem(self):
        try:
            key = self._keys[-1]
        except IndexError:
            raise KeyError('dictionary is empty')

        val = self[key]
        del self[key]

        return (key, val)

    def setdefault(self, key, failobj = None):
        UserDict.setdefault(self, key, failobj)
        if key not in self._keys: self._keys.append(key)

    def update(self, dict):
        UserDict.update(self, dict)
        for key in dict.keys():
            if key not in self._keys: self._keys.append(key)

    def values(self):
        return map(self.get, self._keys)

# ConfModules(Conf)
#  This reads /etc/modprobe.conf into a dictionary keyed on device type,
#  holding dictionaries: cm['eth0']['alias'] --> 'smc-ultra'
#                        cm['eth0']['options'] --> {'io':'0x300', 'irq':'10'}
#                        cm['eth0']['post-install'] --> ['/bin/foo','arg1','arg2']
#  path[*] entries are ignored (but not removed)
#  New entries are added at the end to make sure that they
#  come after any path[*] entries.
#  Comments are delimited by initial '#'
class ConfModules(Conf):
    def __init__(self, filename = '/etc/modprobe.conf'):
	Conf.__init__(self, filename, '#', '\t ', ' ')
    def read(self):
        Conf.read(self)
        self.initvars()
    def initvars(self):
        self.vars = odict()
	keys = ('alias', 'options', 'install', 'remove')
        self.rewind()
        while self.findnextcodeline():
            var = self.getfields()
	    # assume no -k field
	    if len(var) > 2 and var[0] in keys:
		if not self.vars.has_key(var[1]):
		    self.vars[var[1]] = odict({'alias':'', 'options':odict(), 'install':[], 'remove':[]})
		if not cmp(var[0], 'alias'):
		    self.vars[var[1]]['alias'] = var[2]
		elif not cmp(var[0], 'options'):
		    self.vars[var[1]]['options'] = self.splitoptlist(var[2:])
		elif not cmp(var[0], 'install'):
		    self.vars[var[1]]['install'] = var[2:]
		elif not cmp(var[0], 'remove'):
		    self.vars[var[1]]['remove'] = var[2:]
            self.nextline()
        self.rewind()
    def splitoptlist(self, optlist):
	dict = odict()
	for opt in optlist:
	    optup = self.splitopt(opt)
	    if optup:
		dict[optup[0]] = optup[1]
	return dict
    def splitopt(self, opt):
	eq = find(opt, '=')
	if eq > 0:
	    return (opt[:eq], opt[eq+1:])
	else:
	    return ()
    def joinoptlist(self, dict):
	optstring = ''
	for key in dict.keys():
	    optstring = optstring + key + '=' + dict[key] + ' '
	return optstring
    def __getitem__(self, varname):
        if self.vars.has_key(varname):
            return self.vars[varname]
        else:
            return odict()
        
    def __setitem__(self, varname, value):
        # set *every* instance (should only be one, but...) to avoid surprises
        place=self.tell()
        self.vars[varname] = value
	for key in value.keys():
            self.rewind()
            missing=1
	    findexp = '^[\t ]*' + key + '[\t ]+' + varname + '[\t ]+'
	    if not cmp(key, 'alias'):
		endofline = value[key]
		replace = key + ' ' + varname + ' ' + endofline
	    elif not cmp(key, 'options'):
		endofline = self.joinoptlist(value[key])
		replace = key + ' ' + varname + ' ' + endofline
	    elif not cmp(key, 'install'):
		endofline = joinfields(value[key], ' ')
		replace = key + ' ' + varname + ' ' + endofline
	    elif not cmp(key, 'remove'):
		endofline = joinfields(value[key], ' ')
		replace = key + ' ' + varname + ' ' + endofline
	    else:
		# some idiot apparantly put an unrecognized key in
		# the dictionary; ignore it...
		continue
	    if endofline:
		# there's something to write...
        	while self.findnextline(findexp):
                    cl = split(self.getline(), '#')
                    if len(cl) >= 2:
                        comment = join(cl[1:], '#')
                        replace += ' #' + comment
        	    self.setline(replace)
        	    missing=0
        	    self.nextline()
        	if missing:
		    self.fsf()
        	    self.insertline(replace)
	    else:
		# delete any instances of this if they exist.
        	while self.findnextline(findexp):
        	    self.deleteline()
	self.seek(place)
    def __delitem__(self, varname):
        # delete *every* instance...
        place=self.tell()
	for key in self.vars[varname].keys():
            self.rewind()
            while self.findnextline('^[\t ]*' + key + '([\t ]-k)?[\t ]+' + varname):
        	self.deleteline()
        del self.vars[varname]
	self.seek(place)
    def write(self):
	# need to make sure everything is set, because program above may
	# well have done cm['eth0']['post-install'] = ['/bin/foo', '-f', '/tmp/bar']
	# which is completely reasonable, but won't invoke __setitem__
	for key in self.vars.keys():
	    self[key] = self.vars[key]
	Conf.write(self)
    def keys(self):
	return self.vars.keys()
    def has_key(self, key):
	return self.vars.has_key(key)


# ConfModInfo(Conf)
#  This READ-ONLY class reads /boot/module-info.
#  The first line of /boot/module-info is "Version <version>";
#  this class reads versions 0 and 1 module-info files.
class ConfModInfo(Conf):
    def __init__(self, filename = '/boot/module-info'):
	Conf.__init__(self, filename, '#', '\t ', ' ', create_if_missing=0)
    def read(self):
        Conf.read(self)
        self.initvars()
    def initvars(self):
        self.vars = {}
        self.rewind()
	device = 0
	modtype = 1
	description = 2
	arguments = 3
	lookingfor = device
	version = self.getfields()
        self.nextline()
	if not cmp(version[1], '0'):
	    # Version 0 file format
            while self.findnextcodeline():
        	line = self.getline()
		if not line[0] in self.separators:
		    curdev = line
		    self.vars[curdev] = {}
		    lookingfor = modtype
		elif lookingfor == modtype:
		    fields = self.getfields()
		    # first "field" is null (before separators)
		    self.vars[curdev]['type'] = fields[1]
		    if len(fields) > 2:
			self.vars[curdev]['typealias'] = fields[2]
		    lookingfor = description
		elif lookingfor == description:
		    self.vars[curdev]['description'] = re.sub(
			'^"', '', re.sub(
			    '^['+self.separators+']', '', re.sub(
				'"['+self.separators+']*$', '', line)))
		    lookingfor = arguments
		elif lookingfor == arguments:
		    if not self.vars[curdev].has_key('arguments'):
			self.vars[curdev]['arguments'] = {}
		    # get argument name (first "field" is null again)
		    thislist = []
		    # point at first character of argument description
		    p = find(line, '"')
		    while p != -1 and p < len(line):
			q = find(line[p+1:], '"')
			# deal with escaped quotes (\")
			while q != -1 and not cmp(line[p+q-1], '\\'):
			    q = find(line[p+q+1:], '"')
			if q == -1:
			    break
			thislist.append(line[p+1:p+q+1])
			# advance to beginning of next string, if any
			r = find(line[p+q+2:], '"')
			if r >= 0:
			    p = p+q+2+r
			else:
			    # end of the line
			    p = r
		    self.vars[curdev]['arguments'][self.getfields()[1]] = thislist
        	self.nextline()
	elif not cmp(version[1], '1'):
	    # Version 1 file format
	    # Version 1 format uses ' ' and ':' characters as field separators
	    # but only uses ' ' in one place, where we explicitly look for it.
            self.separators = ':'
            while self.findnextcodeline():
        	line = self.getline()
		fields = self.getfields()
		# pull out module and linetype from the first field...
        	(module, linetype) = re.split('[ \t]+', fields[0])
		if not cmp(linetype, 'type'):
		    pass
		elif not cmp(linetype, 'alias'):
		    pass
		elif not cmp(linetype, 'desc'):
		    pass
		elif not cmp(linetype, 'argument'):
		    pass
		elif not cmp(linetype, 'supports'):
		    pass
		elif not cmp(linetype, 'arch'):
		    pass
		elif not cmp(linetype, 'pcimagic'):
		    pass
		else:
		    # error: unknown flag...
		    raise BadFile, 'unknown flag' + linetype
	else:
	    print 'Only versions 0 and 1 module-info files are supported'
	    raise VersionMismatch, 'Only versions 0 and 1 module-info files are supported'
        self.rewind()
    def __getitem__(self, varname):
        if self.vars.has_key(varname):
            return self.vars[varname]
        else:
            return {}
    def keys(self):
	return self.vars.keys()
    def has_key(self, key):
	return self.vars.has_key(key)
    def write(self):
	pass


# ConfPw(Conf)
#  This class implements a dictionary based on a :-separated file.
#  It takes as arguments the filename and the field number to key on;
#  The data provided is a list including all fields including the key.
#  Has its own write method to keep files sane.
class ConfPw(Conf):
    def __init__(self, filename, keyfield, numfields):
	self.keyfield = keyfield
	self.numfields = numfields
	Conf.__init__(self, filename, '', ':', ':', 0)
    def read(self):
	Conf.read(self)
	self.initvars()
    def initvars(self):
	self.vars = {}
	# need to be able to return the keys in order to keep
	# things consistent...
	self.ordered_keys = []
	self.rewind()
	while self.findnextcodeline():
	    fields = self.getfields()
	    self.vars[fields[self.keyfield]] = fields
	    self.ordered_keys.append(fields[self.keyfield])
            self.nextline()
	self.rewind()
    def __setitem__(self, key, value):
	if not self.findlinewithfield(self.keyfield, key):
	    self.fsf()
	    self.ordered_keys.append(key)
	self.setfields(value)
	self.vars[key] = value
    def __getitem__(self, key):
	if self.vars.has_key(key):
	    return self.vars[key]
	return []
    def __delitem__(self, key):
	place = self.tell()
	self.rewind()
	if self.findlinewithfield(self.keyfield, key):
	    self.deleteline()
	if self.vars.has_key(key):
	    del self.vars[key]
	for i in range(len(self.ordered_keys)):
	    if key in self.ordered_keys[i:i+1]:
		self.ordered_keys[i:i+1] = []
		break
	self.seek(place)
    def keys(self):
	return self.ordered_keys
    def has_key(self, key):
	return self.vars.has_key(key)
    def write(self):
        self.file = open(self.filename + '.new', 'w', -1)
	# change the mode of the new file to that of the old one
        if os.path.isfile(self.filename) and self.mode == -1:
	    os.chmod(self.filename + '.new', os.stat(self.filename)[0])
	if self.mode >= 0:
	    os.chmod(self.filename + '.new', self.mode)
        # add newlines while writing
        for index in range(len(self.lines)):
            self.file.write(self.lines[index] + '\n')
        self.file.close()
	os.rename(self.filename + '.new', self.filename)
    def changefield(self, key, fieldno, fieldtext):
	self.rewind()
	self.findlinewithfield(self.keyfield, key)
	Conf.changefield(self, fieldno, fieldtext)
	self.vars[key][fieldno:fieldno+1] = [fieldtext]

# ConfPwO
#  This class presents a data-oriented meta-class for making
#  changes to ConfPw-managed files.  Applications should not
#  instantiate this class directly.
class ConfPwO(ConfPw):
    def __init__(self, filename, keyfield, numfields, reflector):
	ConfPw.__init__(self, filename, keyfield, numfields)
	self.reflector = reflector
    def __getitem__(self, key):
	if self.vars.has_key(key):
	    return self.reflector(self, key)
	else:
	    return None
    def __setitem__(self, key):
	# items are objects which the higher-level code can't touch
	raise AttributeError, 'Object ' + self + ' is immutable'
    # __delitem__ is inherited from ConfPw
    # Do *not* use setitem for this; adding an entry should be
    # a much different action than accessing an entry or changing
    # fields in an entry.
    def addentry(self, key, list):
	if self.vars.has_key(key):
	    raise AttributeError, key + ' exists'
	ConfPw.__setitem__(self, key, list)
    def getfreeid(self, fieldnum):
	freeid = 500
	# first, we try not to re-use id's that have already been assigned.
	for item in self.vars.keys():
	    id = atoi(self.vars[item][fieldnum])
	    if id >= freeid and id < 65533: # ignore nobody on some systems
		freeid = id + 1
	if freeid > 65533:
	    # if that didn't work, we go back and find any free id over 500
	    ids = {}
	    for item in self.vars.keys():
		ids[atoi(self.vars[item][fieldnum])] = 1
	    i = 500
	    while i < 65535 and ids.has_key(i):
		i = i + 1
	if freeid > 65533:
	    raise SystemFull, 'No IDs available'
	return freeid

# ConfPasswd(ConfPwO)
#  This class presents a data-oriented class for making changes
#  to the /etc/passwd file.
class _passwd_reflector:
    # first, we need a helper class...
    def __init__(self, pw, user):
	self.pw = pw
	self.user = user
    def setgecos(self, oldgecos, fieldnum, value):
	gecosfields = split(oldgecos, ',')
	# make sure that we have enough gecos fields
	for i in range(5-len(gecosfields)):
	    gecosfields.append('')
	gecosfields[fieldnum] = value
	return join(gecosfields[0:5], ',')
    def getgecos(self, oldgecos, fieldnum):
	gecosfields = split(oldgecos, ',')
	# make sure that we have enough gecos fields
	for i in range(5-len(gecosfields)):
	    gecosfields.append('')
	return gecosfields[fieldnum]
    def __getitem__(self, name):
	return self.__getattr__(name)
    def __setitem__(self, name, value):
	return self.__setattr__(name, value)
    def __getattr__(self, name):
	if not self.pw.has_key(self.user):
	    raise AttributeError, self.user + ' has been deleted'
	if not cmp(name,'username'):
	    return self.pw.vars[self.user][0]
	elif not cmp(name,'password'):
	    return self.pw.vars[self.user][1]
	elif not cmp(name,'uid'):
	    return self.pw.vars[self.user][2]
	elif not cmp(name,'gid'):
	    return self.pw.vars[self.user][3]
	elif not cmp(name,'gecos'):
	    return self.pw.vars[self.user][4]
	elif not cmp(name,'fullname'):
	    return self.getgecos(self.pw.vars[self.user][4], 0)
	elif not cmp(name,'office'):
	    return self.getgecos(self.pw.vars[self.user][4], 1)
	elif not cmp(name,'officephone'):
	    return self.getgecos(self.pw.vars[self.user][4], 2)
	elif not cmp(name,'homephone'):
	    return self.getgecos(self.pw.vars[self.user][4], 3)
	elif not cmp(name,'homedir'):
	    return self.pw.vars[self.user][5]
	elif not cmp(name,'shell'):
	    return self.pw.vars[self.user][6]
	else:
	    raise AttributeError, name
    def __setattr__(self, name, value):
	if not cmp(name, 'pw') or not cmp(name, 'user') \
                               or not cmp(name, 'setgecos') \
                               or not cmp(name, 'getgecos'):
	    self.__dict__[name] = value
	    return None
	if not self.pw.has_key(self.user):
	    raise AttributeError, self.user + ' has been deleted'
	if not cmp(name,'username'):
	    # username is not an lvalue...
	    raise AttributeError, name + ': key is immutable'
	elif not cmp(name,'password'):
	    self.pw.changefield(self.user, 1, value)
	elif not cmp(name,'uid'):
	    self.pw.changefield(self.user, 2, str(value))
	elif not cmp(name,'gid'):
	    self.pw.changefield(self.user, 3, str(value))
	elif not cmp(name,'gecos'):
	    self.pw.changefield(self.user, 4, value)
	elif not cmp(name,'fullname'):
	    self.pw.changefield(self.user, 4,
		self.setgecos(self.pw.vars[self.user][4], 0, value))
	elif not cmp(name,'office'):
	    self.pw.changefield(self.user, 4,
		self.setgecos(self.pw.vars[self.user][4], 1, value))
	elif not cmp(name,'officephone'):
	    self.pw.changefield(self.user, 4,
		self.setgecos(self.pw.vars[self.user][4], 2, value))
	elif not cmp(name,'homephone'):
	    self.pw.changefield(self.user, 4,
		self.setgecos(self.pw.vars[self.user][4], 3, value))
	elif not cmp(name,'homedir'):
	    self.pw.changefield(self.user, 5, value)
	elif not cmp(name,'shell'):
	    self.pw.changefield(self.user, 6, value)
	else:
	    raise AttributeError, name
class ConfPasswd(ConfPwO):
    def __init__(self):
	ConfPwO.__init__(self, '/etc/passwd', 0, 7, _passwd_reflector)
    def addentry(self, username, password, uid, gid, gecos, homedir, shell):
	ConfPwO.addentry(self, username, [username, password, uid, gid, gecos, homedir, shell])
    def addfullentry(self, username, password, uid, gid, fullname, office,
	officephone, homephone, homedir, shell):
	self.addentry(username, password, uid, gid, join([fullname,
	    office, officephone, homephone, ''], ','), homedir, shell)
    def getfreeuid(self):
	try:
	    return self.getfreeid(2)
	except:
	    raise SystemFull, 'No UIDs available'
	

# ConfShadow(ConfPwO)
#  This class presents a data-oriented class for making changes
#  to the /etc/shadow file.
class _shadow_reflector:
    # first, we need a helper class...
    def __init__(self, pw, user):
	self.pw = pw
	self.user = user
    def _readstr(self, fieldno):
	return self.pw.vars[self.user][fieldno]
    def _readint(self, fieldno):
	retval = self.pw.vars[self.user][fieldno]
	if len(retval): return atoi(retval)
	return -1
    def __getitem__(self, name):
	return self.__getattr__(name)
    def __setitem__(self, name, value):
	return self.__setattr__(name, value)
    def __getattr__(self, name):
	if not self.pw.has_key(self.user):
	    raise AttributeError, self.user + ' has been deleted'
	if not cmp(name,'username'):
	    return self._readstr(0)
	elif not cmp(name,'password'):
	    return self._readstr(1)
	elif not cmp(name,'lastchanged'):
	    return self._readint(2)
	elif not cmp(name,'mindays'):
	    return self._readint(3)
	elif not cmp(name,'maxdays'):
	    return self._readint(4)
	elif not cmp(name,'warndays'):
	    return self._readint(5)
	elif not cmp(name,'gracedays'):
	    return self._readint(6)
	elif not cmp(name,'expires'):
	    return self._readint(7)
	else:
	    raise AttributeError, name
    def __setattr__(self, name, value):
	if not cmp(name, 'pw') or not cmp(name, 'user'):
	    self.__dict__[name] = value
	    return None
	if not self.pw.has_key(self.user):
	    raise AttributeError, self.user + ' has been deleted'
	if not cmp(name,'username'):
	    # username is not an lvalue...
	    raise AttributeError, name + ': key is immutable'
	elif not cmp(name,'password'):
	    self.pw.changefield(self.user, 1, value)
	elif not cmp(name,'lastchanged'):
	    if not len(str(value)) or value == -1:
		raise AttributeError, 'illegal value for lastchanged'
	    self.pw.changefield(self.user, 2, str(value))
	elif not cmp(name,'mindays'):
	    if not len(str(value)) or value == -1:
		value = ''
	    self.pw.changefield(self.user, 3, str(value))
	elif not cmp(name,'maxdays'):
	    if not len(str(value)) or value == -1:
		value = ''
	    self.pw.changefield(self.user, 4, str(value))
	elif not cmp(name,'warndays'):
	    if not len(str(value)) or value == -1:
		value = ''
	    self.pw.changefield(self.user, 5, str(value))
	elif not cmp(name,'gracedays'):
	    if not len(str(value)) or value == -1:
		value = ''
	    self.pw.changefield(self.user, 6, str(value))
	elif not cmp(name,'expires'):
	    if not len(str(value)) or value == -1:
		value = ''
	    self.pw.changefield(self.user, 7, str(value))
	else:
	    raise AttributeError, name
class ConfShadow(ConfPwO):
    def __init__(self):
	ConfPwO.__init__(self, '/etc/shadow', 0, 9, _shadow_reflector)
    def addentry(self, username, password, lastchanged, mindays, maxdays, warndays, gracedays, expires):
	# we need that final '' so that the final : (delimited the
	# "reserved field" is preserved by ConfPwO.addentry())
	ConfPwO.addentry(self, username,
			 [username, password, self._intfield(lastchanged),
			  self._intfield(mindays), self._intfield(maxdays),
			  self._intfield(warndays), self._intfield(gracedays),
			  self._intfield(expires), ''])
    def _intfield(self, value):
	try:
	    atoi(value)
	    return value
	except:
	    if value == -1:
		return ''
	    else:
		return str(value)

# ConfGroup(ConfPwO)
#  This class presents a data-oriented class for making changes
#  to the /etc/group file.
#  May be replaced by a pwdb-based module, we hope.
class _group_reflector:
    # first, we need a helper class...
    def __init__(self, pw, group):
	self.pw = pw
	self.group = group
    def __getitem__(self, name):
	return self.__getattr__(name)
    def __setitem__(self, name, value):
	return self.__setattr__(name, value)
    def __getattr__(self, name):
	if not self.pw.has_key(self.group):
	    raise AttributeError, self.group + ' has been deleted'
	if not cmp(name,'name'):
	    return self.pw.vars[self.group][0]
	elif not cmp(name,'password'):
	    return self.pw.vars[self.group][1]
	elif not cmp(name,'gid'):
	    return self.pw.vars[self.group][2]
	elif not cmp(name,'userlist'):
	    return self.pw.vars[self.group][3]
	else:
	    raise AttributeError. name
    def __setattr__(self, name, value):
	if not cmp(name, 'pw') or not cmp(name, 'group'):
	    self.__dict__[name] = value
	    return None
	if not self.pw.has_key(self.group):
	    raise AttributeError, self.group + ' has been deleted'
	if not cmp(name,'name'):
	    # username is not an lvalue...
	    raise AttributeError, name + ': key is immutable'
	elif not cmp(name,'password'):
	    self.pw.changefield(self.group, 1, value)
	elif not cmp(name,'gid'):
	    self.pw.changefield(self.group, 2, str(value))
	elif not cmp(name,'userlist'):
	    self.pw.changefield(self.group, 3, value)
	else:
	    raise AttributeError, name
class ConfGroup(ConfPwO):
    def __init__(self):
	ConfPwO.__init__(self, '/etc/group', 0, 4, _group_reflector)
    def addentry(self, group, password, gid, userlist):
	ConfPwO.addentry(self, group, [group, password, gid, userlist])
    def getfreegid(self):
	try:
	    return self.getfreeid(2)
	except:
	    raise SystemFull, 'No GIDs available'

    def nameofgid(self, gid):
	try: gid = atoi(gid)
	except: return ''
	for group in self.vars.keys():
	    id = atoi(self.vars[group][2])
	    if id == gid:
		return self.vars[group][0]
	return ''


# ConfUnix()
#  This class presents a data-oriented class which uses the ConfPasswd
#  and ConfShadow classes (if /etc/shadow exists) to hold data.
#  Designed to be replaced by a pwdb module eventually, we hope.
class _unix_reflector:
    # first, we need a helper class...
    def __init__(self, pw, user):
	self.pw = pw
	self.user = user
    def __getitem__(self, name):
	return self.__getattr__(name)
    def __setitem__(self, name, value):
	return self.__setattr__(name, value)
    def __getattr__(self, name):
	if not self.pw.passwd.has_key(self.user):
	    raise AttributeError, self.user + ' has been deleted'
	if not cmp(name,'username'):
	    if self.pw.shadow:
		return self.pw.shadow[self.user].username
	    else:
		return self.pw.passwd[self.user].username
	elif not cmp(name,'password'):
	    if self.pw.shadow:
		return self.pw.shadow[self.user].password
	    else:
		return self.pw.passwd[self.user].password
	elif not cmp(name,'uid'):
	    return self.pw.passwd[self.user].uid
	elif not cmp(name,'gid'):
	    return self.pw.passwd[self.user].gid
	elif not cmp(name,'gecos'):
	    return self.pw.passwd[self.user].gecos
	elif not cmp(name,'fullname'):
	    return self.pw.passwd[self.user].fullname
	elif not cmp(name,'office'):
	    return self.pw.passwd[self.user].office
	elif not cmp(name,'officephone'):
	    return self.pw.passwd[self.user].officephone
	elif not cmp(name,'homephone'):
	    return self.pw.passwd[self.user].homephone
	elif not cmp(name,'homedir'):
	    return self.pw.passwd[self.user].homedir
	elif not cmp(name,'shell'):
	    return self.pw.passwd[self.user].shell
	elif not cmp(name,'lastchanged'):
	    if self.pw.shadowexists():
		return self.pw.shadow[self.user].lastchanged
	    else:
		return -1
	elif not cmp(name,'mindays'):
	    if self.pw.shadowexists():
		return self.pw.shadow[self.user].mindays
	    else:
		return -1
	elif not cmp(name,'maxdays'):
	    if self.pw.shadowexists():
		return self.pw.shadow[self.user].maxdays
	    else:
		return -1
	elif not cmp(name,'warndays'):
	    if self.pw.shadowexists():
		return self.pw.shadow[self.user].warndays
	    else:
		return -1
	elif not cmp(name,'gracedays'):
	    if self.pw.shadowexists():
		return self.pw.shadow[self.user].gracedays
	    else:
		return -1
	elif not cmp(name,'expires'):
	    if self.pw.shadowexists():
		return self.pw.shadow[self.user].expires
	    else:
		return -1
	else:
	    raise AttributeError, name
    def __setattr__(self, name, value):
	if not cmp(name, 'pw') or not cmp(name, 'user'):
	    self.__dict__[name] = value
	    return None
	if not self.pw.passwd.has_key(self.user):
	    raise AttributeError, self.user + ' has been deleted'
	if not cmp(name,'username'):
	    # username is not an lvalue...
	    raise AttributeError, name + ': key is immutable'
	elif not cmp(name,'password'):
	    if self.pw.shadow:
		self.pw.shadow[self.user].password = value
	    else:
		self.pw.passwd[self.user].password = value
	elif not cmp(name,'uid'):
	    self.pw.passwd[self.user].uid = value
	elif not cmp(name,'gid'):
	    self.pw.passwd[self.user].gid = value
	elif not cmp(name,'gecos'):
	    self.pw.passwd[self.user].gecos = value
	elif not cmp(name,'fullname'):
	    self.pw.passwd[self.user].fullname = value
	elif not cmp(name,'office'):
	    self.pw.passwd[self.user].office = value
	elif not cmp(name,'officephone'):
	    self.pw.passwd[self.user].officephone = value
	elif not cmp(name,'homephone'):
	    self.pw.passwd[self.user].homephone = value
	elif not cmp(name,'homedir'):
	    self.pw.passwd[self.user].homedir = value
	elif not cmp(name,'shell'):
	    self.pw.passwd[self.user].shell = value
	elif not cmp(name,'lastchanged'):
	    if self.pw.shadowexists():
		self.pw.shadow[self.user].lastchanged = value
	elif not cmp(name,'mindays'):
	    if self.pw.shadowexists():
		self.pw.shadow[self.user].mindays = value
	elif not cmp(name,'maxdays'):
	    if self.pw.shadowexists():
		self.pw.shadow[self.user].maxdays = value
	elif not cmp(name,'warndays'):
	    if self.pw.shadowexists():
		self.pw.shadow[self.user].warndays = value
	elif not cmp(name,'gracedays'):
	    if self.pw.shadowexists():
		self.pw.shadow[self.user].gracedays = value
	elif not cmp(name,'expires'):
	    if self.pw.shadowexists():
		self.pw.shadow[self.user].expires = value
	else:
	    raise AttributeError, name

class ConfSysctl(Conf):
    def __init__(self, filename):
        Conf.__init__(self, filename, commenttype='#',
                      separators='=', separator='=')
    def read(self):
        Conf.read(self)
        Conf.sedline(self, '\n', '')
        Conf.sedline(self, '  ', ' ')
        self.initvars()
    def initvars(self):
        self.vars = {}
        self.rewind()
        while self.findnextcodeline():
            var = self.getfields()
	    # fields 1..n are false matches on "=" character in string,
            # which is messed up, but try to deal with it
	    var[1] = joinfields(var[1:len(var)], '=')
	    # snip off leading and trailing spaces, which are legal (it's
            # how sysctl(1) prints them) but can be confusing, and tend to
	    # screw up Python's dictionaries
	    var[0] = strip(var[0])
	    var[1] = strip(var[1])
            if self.vars.has_key(var[0]):
                self.deleteline()
                self.vars[var[0]] = var[1]
            else:
                self.vars[var[0]] = var[1]
                self.line = self.line + 1
        self.rewind()
    def __setitem__(self, varname, value):
        # set it in the line list
        self.rewind()
        foundit = 0
        while self.findnextcodeline():
            var = self.getfields()
	    # snip off leading and trailing spaces, which are legal (it's
            # how sysctl(1) prints them) but can be confusing, and tend to
	    # screw up Python's dictionaries
	    if(strip(var[0]) == varname):
	        while(strip(var[0]) == varname):
                    self.deleteline()
                    var = self.getfields()
                for part in split(value, '\n'):
                    self.insertline(varname + ' = ' + part)
                    self.line = self.line + 1
                foundit = 1
            self.line = self.line + 1
        if(foundit == 0):
            for part in split(value, '\n'):
                self.lines.append(varname + ' = ' + part)
        self.rewind()
        # re-read the file, sort of
        self.initvars()
    def __getitem__(self, varname):
        if self.vars.has_key(varname):
            return self.vars[varname]
        else:
            return ''
    def write(self):
        self.file = open(self.filename, 'w', -1)
	if self.mode >= 0:
	    os.chmod(self.filename, self.mode)
        # add newlines
        for index in range(len(self.lines)):
            self.file.write(self.lines[index] + '\n');
        self.file.close()
