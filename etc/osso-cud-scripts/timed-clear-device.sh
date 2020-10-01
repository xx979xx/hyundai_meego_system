#!/bin/sh

dbus-send --system --print-reply --dest=com.nokia.time /com/nokia/time com.nokia.time.halt string:clear-device

# vim:tw=0:
