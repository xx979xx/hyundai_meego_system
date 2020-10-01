#!/bin/sh

# Install PAM module for MeeGo
# install-pam-module.sh 
# Version 20100805
#
# Yan Li <yan.i.li@intel.com>, <yanli@gnome.org>
# Copyright (C) 2010 Intel Corporation
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
# 02111-1307, USA.

set -e -u

# Consts
SYSTEM_AUTH_FILE=/etc/pam.d/system-auth
UNINSTALL=0
TEST_MODE=0

# Functions
error()
{
    1>&2 echo "$@"
}

usage()
{
    cat <<EOF
Install PAM module for MeeGo
$0 [-u] module_name new_line

-u     To uninstall
-h     Print this help

Sample:
$0 auth "auth optional pam_ecryptfs.so unwrap"
The new_line will be inserted to $SYSTEM_AUTH_FILE after the last
module line.
EOF
}

# Insert a new line after all lines that contain $1 to SYSTEM_AUTH_FILE
# $1: an expression, the new lines will be inserted after all lines
#     with $1
# $2: the new line to insert
insert_line()
{
    PATTERN=$1
    NEW_LINE=$2
    # don't insert if the NEW_LINE is already there
    if grep -q "$NEW_LINE" "$SYSTEM_AUTH_FILE"; then
        return
    fi

    # get the last line with PATTERN
    LAST_LINE=`grep --color=never "$PATTERN" "$SYSTEM_AUTH_FILE" | tail -1`
    # insert the new line after the LAST_LINE
    sed -i -e "/${LAST_LINE}/a\
${NEW_LINE}" "$SYSTEM_AUTH_FILE"
}

#### ARGS ####
if [ $# -gt 0 ]; then
    if [ "$1" = "-h" ]; then
        usage
        exit 2
    fi
    if [ "$1" = "-u" ]; then
        UNINSTALL=1
        shift
    fi

    if [ $# -lt 2 ]; then
        error "Not enough arguments"
        usage
        exit 2
    fi

    MODULE=$1
    NEW_LINE=$2
fi


#### SANITY CHECK ####
# Am I root? (no need to check in TEST_MODE)
if [ `id -u` -ne 0 -a $TEST_MODE -ne 1 ]; then
    error "Install PAM module for MeeGo"
    error "Must be run as root, exiting..."
    exit 2
fi

if [ ! -f "$SYSTEM_AUTH_FILE" ]; then
    error "$SYSTEM_AUTH_FILE doesn't exists, can't proceed, exiting..."
    exit 2
fi

#### DO THE WORK ####
if [ $UNINSTALL -eq 0 ]; then
    # do install
    insert_line "$MODULE" "$NEW_LINE"
else
    # do uninstall
    sed -i -e "/$NEW_LINE/d" "$SYSTEM_AUTH_FILE"
fi
