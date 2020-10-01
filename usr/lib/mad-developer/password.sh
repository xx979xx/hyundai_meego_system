#!/bin/sh

# This file is part of MADDE
#
# Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
#
# Contact: Riku Voipio <riku.voipio@nokia.com>
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public License
# version 2.1 as published by the Free Software Foundation.
#
# This library is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
# 02110-1301 USA

# Input parameters:
#    action - add    genrate password and set to developer user
#             remove remove the password from developer user
# Return codes:
#    0        success
#    1        error

set -eu
#exec 2>> /tmp/maddev-pwd.log; date >&2; pwd >&2; set -x; : ::: "$@"

LC_ALL=C LANG=C
export LC_ALL LANG
PATH=$HOME/bin:/bin:/sbin:/usr/bin:/usr/sbin
export PATH

die () { echo "$@" >&2; exit 1; }

if [ $# -lt 1 ] ; then
	die "Input parameter missing"
fi

case $1 in

	add)
		# Generate password
		passwd=`perl -e 'open I, "/dev/random"; read I, $c, 6; close I;
			print qw( a c e f h j k m n s u v w x y z )[$_ & 15]
				foreach (unpack("c6", $c)); print "\n";'`
		# Set password to developer user
		echo developer:$passwd | devrootsh chpasswd
                if [ $? != 0 ] ; then
			die "Setting password failed"
                fi
		echo $passwd
		;;
	remove)
		# Remove password from developer user
		devrootsh usermod -p '*' developer
		;;
esac
