#
# discid.py - reads discid files from cd-rom drives and puts them in a class.
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

import os
import string

class DiscidException (Exception):
    pass

class discid:
    def __init__ (self):
        self.timestamp = None
        self.release_name = None
        self.arch = None
        self.disc_number = None
        self.comps_path = None
        self.rpms_path = None
        self.pixmap_path = None

    def setFromLines(self, lines):
        if len (lines) < 7:
            raise DiscidException
        self.timestamp = lines[0].strip ()
        self.release_name = lines[1].strip ()
        self.arch = lines[2].strip ()
        self.disc_number = lines[3].strip ()
        self.comps_path = lines[4].strip ()
        self.rpms_path = lines[5].strip ()
        self.pixmap_path = lines[6].strip ()

    def readFromFile(self, filename):
        file = open (filename, 'r')
        lines = file.readlines ()
        file.close ()

        return self.setFromLines(lines)

    def readFromBuffer(self, buf):
        lines = buf.split('\n')

        return self.setFromLines(lines)

    def read (self, filename):
        return self.readFromFile(filename)

