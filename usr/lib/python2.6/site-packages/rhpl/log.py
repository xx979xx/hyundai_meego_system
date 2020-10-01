#
# log.py - debugging log service
#
# Alexander Larsson <alexl@redhat.com>
# Matt Wilson <msw@redhat.com>
#
# Copyright 2002 Red Hat, Inc.
#
# This software may be freely redistributed under the terms of the GNU
# library public license.
#
# You should have received a copy of the GNU Library Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#

import sys

import warnings
warnings.warn ("rhpl.log is deprecated and will be removed; use python's logging instead",
               DeprecationWarning, stacklevel=2)

class LogFile:
    def __init__ (self, level = 0, filename = None):
	self.handler = self.default_handler
        self.level = level
        self.logFile = None
        self.open(filename)

    def close (self):
        try:
            self.logFile.close ()
        except:
            pass        

    def open (self, file = None):
	if type(file) == type("hello"):
            try:
                self.logFile = open(file, "w")
            except:
                self.logFile = sys.stderr
	elif file:
	    self.logFile = file
	else:
            self.logFile = sys.stderr
        
    def getFile (self):
        return self.logFile.fileno ()

    def __call__(self, format, *args):
	self.handler (format % args)

    def default_handler (self, string):
	self.logFile.write ("* %s\n" % (string))

    def set_loglevel(self, level):
        self.level = level

    def log(self, level, message):
        if self.level >= level:
            self.handler(message)

    def ladd(self, level, file, message):
        if self.level >= level:
            self.handler("++ %s \t%s" % (file, message))

    def ldel(self, level, file, message):
        if self.level >= level:
            self.handler("-- %s \t%s" % (file, message))

    def lch(self, level, file, message):
        if self.level >= level:
            self.handler("-+ %s \t%s" % (file, message))

log = LogFile()
