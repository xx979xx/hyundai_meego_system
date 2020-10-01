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
#exec 2>> /tmp/maddev-if.log; date >&2; pwd >&2; set -x; : ::: "$@"

LC_ALL=C LANG=C
export LC_ALL LANG
PATH=$HOME/bin:/bin:/sbin:/usr/bin:/usr/sbin
export PATH

USB_IF=usb0
WLAN_IF=wlan0
GPRS_IF=gprs0
UDHCPC_SCRIPT=/etc/udhcpc/libicd_network_ipv4.script

# 1. If no input parameters, return information about
#    usb0, wlan0 and gprs0 interfaces
# 2. If more than one input parameter, the args are interface
#    (usb0, wlan0, gprs0) and it's configuration mode, which are:
#    dhcp, static and dhcpd.
#
#    In case of 'dhcp' No other parameters are given; the IP address is
#    set dynamically using dhcp
#
#    In case of 'static', rest input parameters are:
#    <IP address>     IPv4 address
#    <IP mask>        in dotted decimal format
#    <default gw>     optional parameter:
#                     IPv4 address of default gateway,
#                     if missing default route is not set
#
#    In case of 'dhcpd', rest input parameters are:
#    <IP address>     IPv4 address
#    <IP mask>        in dotted decimal format
#    <Peer IP>        IPv4 address given to peer via dhcp
#
#
#  Return codes:
#    0 - success
#    1 - error

warn () { echo "$@" >&2; }
die () { warn "$@"; exit 1; }

kill_dhcpclients ()
{
	udhcpcpids=`ps ax | awk '/[u]dhcpc.*'"$1"'/ {print $1}'`
	case $udhcpcpids in '');; *)
		devrootsh kill -9 $udhcpcpids ;; esac
}

set_ip_and_mask ()
{
	set x `ifconfig $1 2>/dev/null \
		| /bin/sed -n 's/.*inet addr:\\([^ ]*\\).*Mask:\\([^ ]*\\).*/\\1 \\2/p'`
	ip=${2:-} mask=${3:-}
}

delete_defroute ()
{
        # Delete the default route for this interface if it exists
        defroute=`route -n | awk '$1 == "0.0.0.0" && $8 == "'"$1"'"'`
	case $defroute in '') ;; *)
		devrootsh route del default dev $1 ||
			die "Deleting default route for $1 failed!" ;;
	esac
}


if [ $# -gt 0 ]; then

  ifname=$1; shift
  case $ifname in
	$USB_IF | $WLAN_IF | $GPRS_IF)
		;;
	*)
		warn "Interface $ifname unknown!"
		die "Only following interfaces can be modified: $USB_IF, $WLAN_IF, $GPRS_IF"
		;;
  esac

  case $1 in
    dhcp)
	./usbdhcpd.sh stop # XXX
	kill_dhcpclients $ifname
	delete_defroute $ifname
	devrootsh /sbin/udhcpc -i $ifname -s $UDHCPC_SCRIPT >/dev/null 2>&1 &
	# DHCP client process exit is considered as a failure
	udhcpcpid=$!
	sleep 2
	devrootsh kill -0 $udhcpcpid 2>/dev/null ||
		wait $udhcpcpid || die "DHCP client exited with failure!"
	;;
    static)
	# Allocate static IP address to interface

	ip=$2 ipmask=$3 default_gw=${4:-}

	./usbdhcpd.sh stop # XXX
	kill_dhcpclients $ifname
	devrootsh ifconfig $ifname up $ip netmask $ipmask ||
		die "ifconfig failed to configure $ifname"
	delete_defroute $ifname
	case $default_gw in 0.0.0.0)
		devrootsh route add default dev $ifname >/dev/null 2>&1 ;;
	    '')	;;
	    *)	devrootsh route add default gw $default_gw dev $ifname >/dev/null 2>&1 ;;
	esac || die "Setting default gateway for $ifname failed!"
	;;
     dhcpd)
	ip=$2 ipmask=$3 peerip=$4
	kill_dhcpclients $ifname
	devrootsh ifconfig $ifname up $ip netmask $ipmask ||
		die "ifconfig failed to configure $ifname"
	delete_defroute $ifname
	./usbdhcpd.sh $peerip # XXX
	;;
   esac
fi

# Return interface information to standard output in following format:
# <interface name> <IP address> <IP mask> <flags>
#
#   <interface name> either 'usb0', wlan0' or 'gprs0'
#   <IP address>     IPv4 address, '-' if not defined
#   <IP mask>        in dotted decimal format, '-' if not defined
#   <flags>          'R' if default route
#                    'D' if IP address is allocated using DHCP
#                    '-' non of flags set

defroute=`route -n | awk '$1 == "0.0.0.0" { print $8; exit }'`

show_ifinfo ()
{
	set_ip_and_mask $1
	case $defroute in $1) flags=${flags}R ;; esac
	case $ip in '')
		if ps ax | grep "[u]dhcpc.*$1" >/dev/null 2>&1 ; then
			flags=${flags}D
		fi
	esac
	echo "$1" "${ip:--}" "${mask:--}" "${flags:--}"
}

p=`devrootsh cat /var/run/dnsmasq-maddev.pid 2>/dev/null || :`
case $p in [1-9]*)
	devrootsh fgrep -q dnsmasq /proc/$p/cmdline 2>/dev/null &&
        	flags=S || flags= ;; esac
show_ifinfo $USB_IF
flags=; show_ifinfo $WLAN_IF
flags=; show_ifinfo $GPRS_IF
