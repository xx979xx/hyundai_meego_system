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
#    action - status          which usb module is loaded
#             g_ether         load g_ether module
#	      g_file_storage  load g_file_storage module
#             g_nokia         load g_nokia module
#
# Return codes:
#    0        success
#    1        error

set -eu
#exec 2>> /tmp/maddev-usbmodule.log; date >&2; pwd >&2; set -x; : ::: "$@"

LC_ALL=C LANG=C
export LC_ALL LANG
PATH=$HOME/bin:/bin:/sbin:/usr/bin:/usr/sbin
export PATH

die () { echo "$@" >&2; exit 1; }

if [ $# -lt 1 ] ; then
	die "Input parameter missing"
fi

load_status ()
{
	g_nokia=false g_file_storage=false g_ether=false
	eval `lsmod | tr -cd 'a-z0-9_ \\n' | sed -n '/^g_/ s/ .*/=true/p'`
	: g_nokia=$g_nokia g_file_storage=$g_file_storage g_ether=$g_ether
}

unload_file_storage ()
{
	if $g_file_storage
	then
		devrootsh initctl emit G_FILE_STORAGE_REMOVE
		devrootsh rmmod g_file_storage
		sleep 1
		devrootsh osso-usb-mass-storage-disable.sh /dev/mmcblk0p1
		devrootsh osso-mmc-mount.sh /dev/mmcblk0p1 /home/user/MyDocs/
	fi
}

unload_nokia ()
{
	if $g_nokia
	then
		devrootsh initctl emit G_NOKIA_REMOVE
		devrootsh killall pnatd obexd syncd || true
		sleep 1
		devrootsh rmmod g_nokia
		devrootsh pcsuite-disable.sh
		sleep 1
	fi
}

unload_ether ()
{
	devrootsh initctl emit G_ETHER_REMOVE
	$g_ether && devrootsh rmmod g_ether || true
}

load_status

# some command emit stuff to stdout...
exec 3>&1
exec 1>&2

show_status0 ()
{
	exec 1>&3
	$g_nokia && { echo unix network; exit 0; } ||
	$g_file_storage && { echo mass storage; exit 0; } ||
	$g_ether && { echo windows network; exit 0; } ||
	echo none
}

show_status ()
{
	sleep 1
	load_status
	show_status0
	exit 1
}

case $1 in status) show_status0; exit 1 ;; esac

trap show_status 0

case $1 in
	g_ether)
		$g_ether || {
			kernel=`uname -r`
			module=`find /lib/modules/$kernel -name g_ether.ko`
			case $module in
			'') die "Cannot find g_ether module" ;;
			*' '*) die "More than one matching module ('$module')" ;;
			esac
			unload_file_storage
			unload_nokia
			devrootsh insmod $module && sleep 1 &&
				initctl emit --no-wait G_ETHER_READY
		}
		;;
	g_file_storage)
		$g_file_storage || {
			unload_nokia
			unload_ether
			devrootsh osso-mmc-umount.sh /dev/mmcblk0p1
			devrootsh osso-usb-mass-storage-enable.sh /dev/mmcblk0p1
		}
		;;
	g_nokia)
		$g_nokia || {
			unload_file_storage
			unload_ether
			devrootsh pcsuite-enable.sh
		}
		;;
	*) die "'$1': unknown action"
 		;;
esac
