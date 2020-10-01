#!/bin/bash
# dist.sh
# Author: Tom "spot" Callaway <tcallawa@redhat.com>
# License: GPL
# This is a script to output the value for the %{dist}
# tag. The dist tag takes the following format: .$type$num
# Where $type is one of: el, fc, rh
# (for RHEL, Fedora Core, and RHL, respectively)
# And $num is the version number of the distribution.
# NOTE: We can't detect Rawhide or Fedora Test builds properly.
# If we successfully detect the version number, we output the
# dist tag. Otherwise, we exit with no output.

RELEASEFILE=/etc/meego-release

function check_num {
    MAINVER=`cut -d "(" -f 1 < $RELEASEFILE | \
	sed -e "s/[^0-9.]//g" -e "s/$//g" | cut -d "." -f 1`

    echo $MAINVER | grep -q '[0-9]' && echo $MAINVER
}


function check_meego {
    grep -q MeeGo $RELEASEFILE && echo $DISTNUM
}

DISTNUM=`check_num`
DISTMOB=`check_meego`
if [ -n "$DISTNUM" ]; then
    if [ -n "$DISTMOB" ]; then
	DISTTYPE=meego
    fi
fi
[ -n "$DISTTYPE" -a -n "$DISTNUM" ] && DISTTAG=".${DISTTYPE}${DISTNUM}"

case "$1" in
    --meego) echo -n "$DISTMOB" ;;
    --distnum) echo -n "$DISTNUM" ;;
    --disttype) echo -n "$DISTTYPE" ;;
    --help)
	printf "Usage: $0 [OPTIONS]\n"
	printf " Default mode is --dist. Possible options:\n"
	printf " --meego\t\tfor MeeGo version\n"
	printf " --dist\t\tfor distribution tag\n"
	printf " --distnum\tfor distribution number (major)\n"
	printf " --disttype\tfor distribution type\n" ;;
    *) echo -n "$DISTTAG" ;;
esac
