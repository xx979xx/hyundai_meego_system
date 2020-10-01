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
#exec 2>> /tmp/maddev-xterm.log; date >&2; pwd >&2; set -x; ::: "$@"

case ${1:-} in --launch)
	cd `dirname "$0"`
	exec ./devrootsh su - meego -c 'exec /bin/sh'
	exit 1
esac

exec ./devrootsh su user -c 'exec run-standalone.sh osso-xterm `pwd`/xterm-shell'
