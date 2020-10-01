#
# timezone.py - timezone install data
#
# Copyright (C) 2001  Red Hat, Inc.  All rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

import shutil
import iutil
import os
from flags import flags

import logging
log = logging.getLogger("anaconda")

class Timezone:
    def writeKS(self, f):
        f.write("timezone")
        if self.utc:
            f.write(" --utc")
        f.write(" %s\n" % self.tz)

    def write(self, instPath):
        # dont do this in test mode!
        if flags.test:
            return
        timezone = self.tz.replace(" ", "_");
        fromFile = instPath + "/usr/share/zoneinfo/" + timezone

        if not os.access(fromFile, os.R_OK):
            log.error("Timezone to be copied (%s) doesn't exist" % fromFile)
        else:
            try:
                shutil.copyfile(fromFile, instPath + "/etc/localtime")
            except OSError, (errno, msg):
                log.error("Error copying timezone (from %s): %s" % (fromFile, msg))

        f = open(instPath + "/etc/sysconfig/clock", "w")

        f.write('ZONE="%s"\n' % timezone)
        f.close()

        try:
            f = open(instPath + "/etc/adjtime", "r")
            lines = f.readlines()
            f.close()
        except:
            lines = [ "0.0 0 0.0\n", "0\n" ]

        f = open(instPath + "/etc/adjtime", "w")
        f.write(lines[0])
        f.write(lines[1])
        if self.utc:
            f.write("UTC\n")
        else:
            f.write("LOCAL\n")
        f.close()

    def getTimezoneInfo(self):
        return (self.tz, self.utc)

    def setTimezoneInfo(self, timezone, asUtc = 1):
        self.tz = timezone
        self.utc = asUtc

    def __init__(self):
        self.tz = "America/New_York"
        self.utc = 1
