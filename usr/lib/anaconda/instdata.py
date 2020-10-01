#
# instdata.py - central store for all configuration data needed to install
#
# Copyright (C) 2001, 2002, 2003, 2004, 2005, 2006, 2007  Red Hat, Inc.
# All rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Author(s): Erik Troan <ewt@redhat.com>
#            Chris Lumens <clumens@redhat.com>
#

import os, sys
import re
import subprocess
import stat
import string
import language
import network
import firewall
import security
import timezone
import desktop
import booty
import storage
import urllib
import iutil
import isys
import users
import shlex
from flags import *
from constants import *

from rhpl.simpleconfig import SimpleConfigFile
import rhpl.keyboard as keyboard

from pykickstart.version import versionToString, DEVEL

import logging
log = logging.getLogger("anaconda")

import gettext
_ = lambda x: gettext.ldgettext("anaconda", x)

# Collector class for all data related to an install/upgrade.

class InstallData:

    def reset(self):
        # Reset everything except:
        #
        # - The install language
        # - The keyboard

        self.instClass = None
        self.network = network.Network()
        self.firewall = firewall.Firewall()
        self.security = security.Security()
        self.timezone = timezone.Timezone()
        self.timezone.setTimezoneInfo(self.instLanguage.getDefaultTimeZone(self.anaconda.rootPath))
        self.users = None
        self.rootPassword = { "isCrypted": False, "password": "", "lock": False }
        self.userAccount = { "username": "",
                             "fullname": "",
                             "password": "",
                             "isCrypted": False,
                             "isSudoer": False,
                             "groups": [],
                             "homedir": "",
                             "shell": None,
                             "uid": None,
                             "algo": None,
                             "lock": None,
                             "root": "/mnt/sysimage" }
        self.auth = "--enableshadow --passalgo=sha512"
        self.desktop = desktop.Desktop()
        self.upgrade = None
        if flags.cmdline.has_key("preupgrade"):
            self.upgrade = True
        if flags.grub == True:
            self.grub = True
        else:
            self.grub = False
        self.storage = storage.Storage(self.anaconda)
        self.bootloader = booty.getBootloader(self)
        self.upgradeRoot = None
        self.rootParts = None
        self.upgradeSwapInfo = None
        self.escrowCertificates = {}

        if iutil.isS390() or self.anaconda.isKickstart:
            self.firstboot = FIRSTBOOT_SKIP
        else:
            self.firstboot = FIRSTBOOT_DEFAULT

        # XXX I still expect this to die when kickstart is the data store.
        self.ksdata = None

    def setInstallProgressClass(self, c):
        self.instProgress = c

    def setDisplayMode(self, display_mode):
        self.displayMode = display_mode

    # expects a Keyboard object
    def setKeyboard(self, keyboard):
        self.keyboard = keyboard

    # expects 0/1
    def setHeadless(self, isHeadless):
        self.isHeadless = isHeadless

    def setKsdata(self, ksdata):
        self.ksdata = ksdata

    # if upgrade is None, it really means False.  we use None to help the
    # installer ui figure out if it's the first time the user has entered
    # the examine_gui screen.   --dcantrell
    def getUpgrade (self):
        if self.upgrade == None:
            return False
        else:
            return self.upgrade

    def setUpgrade (self, bool):
        self.upgrade = bool

    # Reads the auth string and returns a string indicating our desired
    # password encoding algorithm.
    def getPassAlgo(self):
        if self.auth.find("--enablemd5") != -1 or \
           self.auth.find("--passalgo=md5") != -1:
            return 'md5'
        elif self.auth.find("--passalgo=sha256") != -1:
            return 'sha256'
        elif self.auth.find("--passalgo=sha512") != -1:
            return 'sha512'
        else:
            return None

    def write(self):
        self.instLanguage.write (self.anaconda.rootPath)

        self.anaconda.writeXdriver(self.anaconda.rootPath)

        if not flags.enablefirstboot:
	    f = open(self.anaconda.rootPath + '/etc/sysconfig/firstboot', 'w+')
            f.write('RUN_FIRSTBOOT=NO')
            f.close()
        else:
            if not os.path.exists(self.anaconda.rootPath + "/etc/readahead.packed"): 
                log.info("Generate /etc/readahead.packed")
                try:
                    iutil.execWithCapture("touch",["/etc/readahead.packed"], stdin=0, stderr=2, root=self.anaconda.rootPath)
                except RuntimeError, msg:
                    log.error("Error running touch: %s", msg)

        if not self.isHeadless and not flags.enablefirstboot:
            try:
                # Set the keyboard layout
                iutil.execWithCapture("/usr/bin/gconftool-2",
                                      ["--direct", "--config-source", "xml:readwrite:/etc/gconf/gconf.xml.defaults",
                                       "--type", "list", "--list-type", "string",
                                       "--set", "/desktop/gnome/peripherals/keyboard/kbd/layouts", "["+self.keyboard.__getitem__("layout")+"]"],
                                      stdin=0,
                                      stderr=2,
                                      root=self.anaconda.rootPath)
                # Set the default layout group
                iutil.execWithCapture("/usr/bin/gconftool-2",
                                      ["--direct", "--config-source", "xml:readwrite:/etc/gconf/gconf.xml.defaults",
                                       "--type", "int",
                                       "--set", "/desktop/gnome/peripherals/keyboard/general/defaultGroup", "0"],
                                      stdin=0,
                                      stderr=2,
                                      root=self.anaconda.rootPath)
            except RuntimeError, msg:
                log.error("Error running /usr/bin/gconftool-2: %s", msg)
            
            # Record keyboard info into /etc/sysconfig/keyboard
            self.keyboard.write (self.anaconda.rootPath)

        self.timezone.write (self.anaconda.rootPath)

        args = ["--update", "--nostart"] + shlex.split(self.auth)

        #try:
        #    if not flags.test:
        #        iutil.execWithRedirect("/usr/sbin/authconfig", args,
        #                               stdout = "/dev/tty5", stderr = "/dev/tty5",
        #                               root = self.anaconda.rootPath)
        #    else:
        #        log.error("Would have run: %s", args)
        #except RuntimeError, msg:
        #        log.error("Error running %s: %s", args, msg)

        self.network.write (instPath=self.anaconda.rootPath,
                            anaconda=self.anaconda,
                            username=self.userAccount["username"])
        self.firewall.write (self.anaconda.rootPath)
        self.security.write (self.anaconda.rootPath)
        self.desktop.write(self.anaconda.rootPath)

        if not flags.enablefirstboot:
            self.users = users.Users()

            # make sure crypt_style in libuser.conf matches the salt we're using
            users.createLuserConf(self.anaconda.rootPath,
                                  algoname=self.getPassAlgo())

            if self.userAccount["username"] != "":
                # add new user account
                if not self.users.createUser(username=self.userAccount["username"],
                                             fullname=self.userAccount["fullname"],
                                             password=self.userAccount["password"],
                                             isCrypted=self.userAccount["isCrypted"],
                                             isSudoer=self.userAccount["isSudoer"],
                                             groups=self.userAccount["groups"],
                                             homedir=self.userAccount["homedir"],
                                             shell=self.userAccount["shell"],
                                             uid=self.userAccount["uid"],
                                             algo=self.getPassAlgo(),
                                             lock=self.userAccount["lock"],
                                             root=self.anaconda.rootPath):
                    log.error("Error while creating user %s" % self.userAccount["username"])
                else:
                    # set the root password
                    # by default it is the same to the password of the new user account
                    self.users.setRootPassword(self.userAccount["password"],
                                               self.userAccount["isCrypted"],
                                               self.userAccount["lock"],
                                               algo=self.getPassAlgo())
 
                    # configure automatic login for the new user account
                    if not self.users.configAutoLogin(self.userAccount["username"],
                                                      root=self.anaconda.rootPath):
                        log.error("Error while configuring automatic login for the new user %s" % self.userAccount["username"])

                    # update xdg-user-dirs to prepare for bkl-rename-user
                    if os.path.exists(self.anaconda.rootPath + "/usr/bin/xdg-user-dirs-update"):
                        try:
                            log.info("Set XDG_CONFIG_HOME to /root/.config")
                            os.environ["XDG_CONFIG_HOME"] = "/root/.config"
                            log.info("Update xdg-user-dirs to prepare for bkl-rename-user")
                            iutil.execWithCapture("/usr/bin/xdg-user-dirs-update", "", stdin=0, stderr=2, root=self.anaconda.rootPath)
                        except RuntimeError, msg:
                            log.error("Error running xdg-user-dirs-update: %s", msg)

                    # rename the URIs stored in the Bickley database to the new username
                    if os.path.exists(self.anaconda.rootPath + "/usr/bin/bkl-rename-user"):
                        try:
                            log.info("Rename the URIS in bickley database to the new username %s", self.userAccount["username"])
                            iutil.execWithCapture("/usr/bin/bkl-rename-user", [self.userAccount["username"], self.userAccount["homedir"] + "/.kozo/databases/local-media"], stdin=0, stderr=2, root=self.anaconda.rootPath)
                        except RuntimeError, msg:
                            log.error("Error running bkl-rename-user: %s", msg)

                    # Clean the generated xdg-dirs under /root
                    if os.path.exists("/usr/lib/anaconda-runtime/clean-xdg-dirs"):
                        try:
                            log.info("Run script clean-xdg-dirs %s", self.anaconda.rootPath) 
                            iutil.execWithCapture("/bin/sh", ["/usr/lib/anaconda-runtime/clean-xdg-dirs", self.anaconda.rootPath, "/root"], stdin=0, stderr=2, root='/')
                        except RuntimeError, msg:
                            log.error("Error running clean-xdg-dirs: %s", msg)

        preload_script = "/var/lib/preload/preload.sh"
        env = {}
        if os.path.exists(preload_script):
            env["PRIMARY_USER_HOME"] = self.anaconda.rootPath + self.userAccount["homedir"]
            env["PRIMARY_USER"] = self.anaconda.rootPath + self.userAccount["username"]
            env["PRIMARY_USER_UID"] = self.anaconda.rootPath + self.userAccount["uid"]
            try:
                try:
            	    subprocess.call(["/bin/sh", preload_script], env = env)
                except OSError, (err, msg):
            	    raise CreatorError("Failed to execute preload script "
                                "with '%s' : %s" % ("/bin/sh", msg))
            finally:
                os.unlink(preload_script)

        post_script_dir = "/var/lib/installer/scripts/"
        dev_null = os.open("/dev/null", os.O_WRONLY)
        for s in os.listdir(post_script_dir):
            script = post_script_dir + s
            subprocess.call(["%s" % script], stdout = dev_null, stderr = dev_null)

        if self.anaconda.isKickstart:
            for svc in self.ksdata.services.disabled:
                iutil.execWithRedirect("/sbin/chkconfig",
                                       [svc, "off"],
                                       stdout="/dev/tty5", stderr="/dev/tty5",
                                       root=self.anaconda.rootPath)

            for svc in self.ksdata.services.enabled:
                iutil.execWithRedirect("/sbin/chkconfig",
                                       [svc, "on"],
                                       stdout="/dev/tty5", stderr="/dev/tty5",
                                       root=self.anaconda.rootPath)


    def writeKS(self, filename):
        f = open(filename, "w")

        f.write("# Kickstart file automatically generated by anaconda.\n\n")
        f.write("#version=%s\n" % versionToString(DEVEL))

        if self.upgrade:
            f.write("upgrade\n");
        else:
            f.write("install\n");

        m = None

        if self.anaconda.methodstr:
            m = self.anaconda.methodstr
        elif self.anaconda.stage2:
            m = self.anaconda.stage2

        if m:
            if m.startswith("cdrom:"):
                f.write("cdrom\n")
            elif m.startswith("hd:"):
                if m.count(":") == 3:
                    (part, fs, dir) = string.split(m[3:], ":")
                else:
                    (part, dir) = string.split(m[3:], ":")

                f.write("harddrive --partition=%s --dir=%s\n" % (part, dir))
            elif m.startswith("nfs:"):
                if m.count(":") == 3:
                    (server, opts, dir) = string.split(m[4:], ":")
                    f.write("nfs --server=%s --opts=%s --dir=%s" % (server, opts, dir))
                else:
                    (server, dir) = string.split(m[4:], ":")
                    f.write("nfs --server=%s --dir=%s\n" % (server, dir))
            elif m.startswith("ftp://") or m.startswith("http://"):
                f.write("url --url=%s\n" % urllib.unquote(m))

        self.instLanguage.writeKS(f)
        if not self.isHeadless:
            self.keyboard.writeKS(f)
            self.network.writeKS(f)
            self.zfcp.writeKS(f)

        if self.rootPassword["isCrypted"]:
            args = " --iscrypted %s" % self.rootPassword["password"]
        else:
            args = " --iscrypted %s" % users.cryptPassword(self.rootPassword["password"], algo=self.getPassAlgo())

        if self.rootPassword["lock"]:
            args += " --lock"

        f.write("rootpw %s\n" % args)

        # Some kickstart commands do not correspond to any anaconda UI
        # component.  If this is a kickstart install, we need to make sure
        # the information from the input file ends up in the output file.
        if self.anaconda.isKickstart:
            #f.write(self.ksdata.user.__str__())
            f.write("user --name=%s --password=%s\n" %(self.userAccount["username"],self.userAccount["password"]))
            f.write(self.ksdata.services.__str__())
            f.write(self.ksdata.reboot.__str__())

        self.firewall.writeKS(f)
        if self.auth.strip() != "":
            f.write("authconfig %s\n" % self.auth)
        self.security.writeKS(f)
        self.timezone.writeKS(f)
        self.bootloader.writeKS(f)
        self.storage.writeKS(f)

        if self.backend is not None:
            self.backend.writeKS(f)
            self.backend.writePackagesKS(f, self.anaconda)

        # Also write out any scripts from the input ksfile.
        if self.anaconda.isKickstart:
            for s in self.ksdata.scripts:
                f.write(s.__str__())

        # make it so only root can read, could have password
        os.chmod(filename, 0600)


    def __init__(self, anaconda, extraModules, displayMode, backend = None):
        self.displayMode = displayMode

        self.instLanguage = language.Language(self.displayMode)
        self.keyboard = keyboard.Keyboard()
        self.backend = backend
        self.anaconda = anaconda

        self.monitor = None
        self.videocard = None
        self.isHeadless = 0
        self.extraModules = extraModules

        self.reset()
