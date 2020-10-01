#!/bin/sh

if [ -x /usr/bin/cmp ] ; then
    /usr/bin/cmp -s "$1" "$2"
else
    sha1=`sha1sum -b "$1" | cut -d' ' -f 1`
    sha2=`sha1sum -b "$2" | cut -d' ' -f 1`
    [ -f "$1" -a -f "$2" -a "$sha1" = "$sha2" ]
fi