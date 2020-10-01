# no shebang! execute this with 'sh remote-wrapper.sh command [args...]

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

remote_parent=/home/developer
remote_dir=$remote_parent/madde
mnt_dir=mnt
verbose=false

#devrootsh () { /usr/sbin/devrootsh "$@"; }
#devrootsh () { /usr/lib/mad-developer/devrootsh "$@"; }
devrootsh () { bin/devrootsh "$@"; }

warn () { echo "$@" >&2; }
die () { warn "$@"; exit 1; }

usage () { die Usage: `basename "$0"` command [args...]; }

self_update ()
{
	warn Updating, in very verbose more.
	set -x
	rm -f "$0.new" "$0.old"
	cat > "$0.new"
	mv "$0" "$0.old"
	mv "$0.new" "$0" || { mv "$0.old" "$0"; die xxx; }
	chmod 755 "$0"
	rm -f "$0.old"
	exit 0
}

chkremotedir ()
{
	test -d $remote_dir || {
		test -d $remote_parent || {
			devrootsh mkdir $remote_parent
			devrootsh chown developer:developer $remote_parent
		}
		mkdir $remote_dir
	}
}

fix_env ()
{
	set +eu
	. /etc/profile >/dev/null 2>&1
	. /home/user/.profile >/dev/null 2>&1
	set -eu
	DISPLAY=:0.0
	PATH=$HOME/bin:/sbin:/usr/sbin:$PATH  # fixme: option to change path
	export DISPLAY PATH
}

# Where to find command -- execution working directory:
# 1st: $1 has path components: run verbatim -- wd: $HOME/$remote_dir (madde)
# 2st: try from $HOME/$mnt_dir (mnt) -- wd:  $HOME/$mnt_dir (mnt)
# 3rd: try the one in $HOME/$remote_dir (add +x if not) -- wd: $HOME/$remote_dir
# 4th: use the one in $PATH -- wd: $HOME/$remote_dir (madde)

get_runcommand ()
{
	cmd=$1 rwd=$remote_dir

	# 1st: run given verbatim if has absolute path
	case $cmd in /*) return ;; esac

	# 2st: try from $HOME/mnt
	if test -x "$mnt_dir/$cmd"
	then
		rwd=$mnt_dir cmd=./$cmd # 2.

	# 3rd: try the one in "remote_dir"
	elif test -x "$remote_dir/$cmd"
	then
		cmd=./$cmd; # 3.

	# 4th: use the one in $PATH
	else
		cmd=`env which $cmd 2>/dev/null || true`
		case $cmd in /*) ;;
			*) cmd=$1; die "Can not find '$1'..." ;;
		esac
	fi
}

cmd_poweroff ()
{
	verbose set -x
	devrootsh /sbin/telinit 0
}

cmd_run ()
{
	# FIXME setup environment -- and add option to set env vars (-e ?)
	fix_env
	get_runcommand "$1"
	shift
	chkremotedir
	cd "$rwd"
	$verbose && warn Current working directory: `pwd` || :
	verbose warn Executing $cmd ${1+"$@"}
	exec $cmd ${1+"$@"}
}

cmd_debug ()
{
	case $1 in
		gdbserver)
			case ${2:-} in '') die Connection arg missing. ;; esac
			gdb=gdbserver; hp=${2:-}; shift; shift ;;
		gdb)	gdb=gdb; hp=; shift ;;
		*)	die "'$1': unknown debugger program" ;;
	esac
	case ${1:-} in '') die No PROGRAM to run ;; esac
	fix_env
	get_runcommand "$1"
	shift
	chkremotedir
	cd "$rwd"
	warn Current working directory for debug session: `pwd`
	warn Executing $gdb $hp $cmd ${1+"$@"}
	exec $gdb $hp $cmd ${1+"$@"}
}

# hopefully this is short-lived !!!
fuse_me_harder ()
{
	if ! test -c /dev/fuse; then
		module=`find /lib/modules/\`uname -r\` -name fuse.ko`
		if test x"$module" = x; then
			echo 'fuse.ko module not found'
			exit 1
		fi

		devrootsh insmod $module
	fi

	# /dev/fuse might not been created yet so we have to poll
	for _ in 1 2 3 4 5; do
		if test -c /dev/fuse
		then
			test -r /dev/fuse -a -w /dev/fuse || devrootsh chmod a+rw /dev/fuse
			test -r /etc/fuse.conf || devrootsh chmod a+r /etc/fuse.conf
			break
		else
			sleep 1
		fi
	done

	# XXXX
	test -r /dev/null -a -w /dev/null || devrootsh chmod a+rw /dev/null
}

cmd_mount ()
{
	test -d mnt || mkdir mnt || exit 1
	fuse_me_harder
	verbose set -x
	./bin/utfs-client --detach -r $1 -l $2 -b 14168 mnt -f -o allow_root
}

cmd_umount ()
{
	verbose set -x
	fusermount -u mnt 2>/dev/null || devrootsh umount mnt
}

cmd_install ()
{
	verbose set -x
	devrootsh /bin/sh -c "cd '$remote_dir' && dpkg -i '$1'"
}

cmd_uninstall ()
{
	verbose set -x
	devrootsh /bin/sh -c "cd '$remote_dir' && dpkg -P '$1'"
}

cmd_writefile ()
{
	case $1 in +x) setx=true; shift ;; *) setx=false ;; esac
	chkremotedir
	cd "$remote_dir"
	$verbose && warn Writing "'$1'" to "'"`pwd`"'" || :
	cat > "$1"
	#sum=`md5sum "$1"`
	#case $sum in $2) ;; *) rm -f "$1"; die sum did not match ;; esac
	$setx && chmod 755 "$1" || :
}

cmd_removefile ()
{
	verbose set -x
	cd "$remote_dir" && rm "$1"
}

cmd_ping ()
{
	echo 'pong' `sed 's/[^A-Za-z0-9._ ] *.*//; y/ /_/; s/_*$//' /etc/issue`
}

while	case ${1:-} in
		-v) verbose=true ;;
		-x) set -x ;;
		'') usage ;;
		*) false ;;
	esac
do shift; done

$verbose && verbose () { "$@"; } || verbose () { :; }

cmd=$1; shift

case $cmd in
	poweroff) cmd_poweroff ;;
	run) cmd_run ${1:+"$@"} ;;
	debug) cmd_debug ${1:+"$@"} ;;
	mount) cmd_mount ${1:+"$@"} ;;
	umount) cmd_umount ;;
	install) cmd_install ${1:+"$@"} ;;
	uninstall) cmd_uninstall ${1:+"$@"} ;;
	writefile) cmd_writefile ${1:+"$@"} ;;
	removefile) cmd_removefile ${1:+"$@"} ;;
	ping) cmd_ping ;;
	self_update) self_update ;;
	*) die "'$cmd': no such command" ;;
esac

# Local variables:
# mode: shell-script
# sh-basic-offset: 8
# tab-width: 8
# End:
# vi: set sw=8 ts=8
