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

set -eu
#exec 2>> /tmp/maddev-start.log; date >&2; set -x; : "$@"

libdir=/usr/lib/mad-developer

LC_ALL=C LANG=C
export LC_ALL LANG
PATH=/bin:/sbin:/usr/bin:/usr/sbin:$libdir
export PATH

devown ()
{
	# busybox ls do not support -H, let's not make HOME symlink...
	# ... and busybox stat unusable.
	case `ls -ld "$1" | awk '{print $3}'` in develop*) ;;
		*) $libdir/devrootsh chown 500:500 "$1" ;;
	esac
}

test -d $HOME || $libdir/devrootsh mkdir $HOME
devown $HOME

test -f $HOME/.profile || cp $libdir/dot-profile $HOME/.profile
devown $HOME/.profile

# Share user MyDocs -- FAT32 permissions 777 on N900

test -d $HOME/bin || mkdir $HOME/bin
devown $HOME/bin

for b in devrootsh remote-wrapper.sh utfs-client
do
    test -f $HOME/bin/$b || ln -s $libdir/$b $HOME/bin
done

exec "$@"
