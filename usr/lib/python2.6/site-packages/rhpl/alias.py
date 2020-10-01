#!/usr/bin/python
# alias.py: matches pci identifiers against kernel-style alias files
#
# Copyright 2008 Red Hat, Inc.
#
# This software may be freely redistributed under the terms of the GNU
# library public license.
#
# You should have received a copy of the GNU Library Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

import os
import fnmatch

class Alias:
    def __init__ (self):
	self.aliases = []

    def addAliases(self, aliases):
	for alias in aliases:
	    (alias, foo, bar) = alias.partition('#')
	    if alias.split() == []:
		continue
	    (a, pat, mod) = alias.split()
	    (foo, bar, pat) = pat.partition(':')
	    if pat != '' and mod != '':
		self.aliases.append([pat, mod])

    def addAliasFile(self, filename):
	file = open(filename, 'r')
	lines = file.readlines()
	file.close()
	self.addAliases(lines)

    def addAliasDir(self, directory, pattern = None):
	files = os.listdir(directory)
	files = fnmatch.filter(files, pattern or '*.alias');
	map(lambda x: self.addAliasFile(directory + '/' + x), files)

    def betterMatch(self, a, b):
	if a[0].count('*') < b[0].count('*'):
	    return a
	return b

    def matchDevice(self, v = 0xffff, d = 0xffff, sv = 0xffff, sd = 0xffff, bc = 0xff, sc = 0xff, i = 0xff):
	str = "v%.8Xd%.8Xsv%.8Xsd%.8Xbc%.2Xsc%.2Xi%.2X" % (v, d, sv, sd, bc, sc, i)
	matches = [x for x in self.aliases if fnmatch.fnmatch(str, x[0])]
	if len(matches) == 0:
	    return None
	match = reduce(self.betterMatch, matches)
	return match[1]

if __name__ == "__main__":
    alias = Alias()
    alias.addAliasDir("/usr/share/hwdata/videoaliases", "*.xinf")
    print alias.matchDevice(0x8086, 0x7121)
