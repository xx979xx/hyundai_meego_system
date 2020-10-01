#!/bin/sh
##############################################################################
#  This file is part of libresourceqt                                        #
#                                                                            #
#  Copyright (C) 2010 Nokia Corporation.                                     #
#                                                                            #
#  This library is free software; you can redistribute                       #
#  it and/or modify it under the terms of the GNU Lesser General Public      #
#  License as published by the Free Software Foundation                      #
#  version 2.1 of the License.                                               #
#                                                                            #
#  This library is distributed in the hope that it will be useful,           #
#  but WITHOUT ANY WARRANTY; without even the implied warranty of            #
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU          #
#  Lesser General Public License for more details.                           #
#                                                                            #
#  You should have received a copy of the GNU Lesser General Public          #
#  License along with this library; if not, write to the Free Software       #
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  #
#  USA.                                                                      #
##############################################################################

# Source and export D-Bus session info 
. /tmp/session_bus_address.user 

# Run pong server on system bus
/usr/lib/libresourceqt-tests/test-dbus-pong &

# Run pong server on system bus
/usr/lib/libresourceqt-tests/test-dbus-pong --session &

sleep 2

# do the testing!
/usr/lib/libresourceqt-tests/test-dbus-qeventloop
