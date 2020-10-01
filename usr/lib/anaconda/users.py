#
# users.py:  Code for creating user accounts and setting the root password
#
# Copyright (C) 2008, 2009  Intel Corp.
# Copyright (C) 2006, 2007, 2008 Red Hat, Inc.  All rights reserved.
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
# Author(s): Xu Li <xu.li@intel.com>
# Author(s): Chris Lumens <clumens@redhat.com>
#

import libuser
import string
import crypt
import random
import tempfile
import os
import os.path
import re
import stat
import logging
log = logging.getLogger("anaconda")
import gettext
_ = lambda x: gettext.ldgettext("anaconda", x)

def createLuserConf(instPath, algoname='sha512'):
    """Writes a libuser.conf for instPath."""
    if os.getenv("LIBUSER_CONF") and \
       os.access(os.environ["LIBUSER_CONF"], os.R_OK):
        fn = os.environ["LIBUSER_CONF"]
        fd = open(fn, 'w')
    else:
        (fp, fn) = tempfile.mkstemp(prefix="libuser.")
        fd = os.fdopen(fp, 'w')

    buf = """
[defaults]
skeleton = %(instPath)s/etc/skel
mailspooldir = %(instPath)s/var/mail
crypt_style = %(algo)s
modules = files shadow
create_modules = files shadow
[files]
directory = %(instPath)s/etc
[shadow]
directory = %(instPath)s/etc
""" % {"instPath": instPath, "algo": algoname}

    fd.write(buf)
    fd.close()
    os.environ["LIBUSER_CONF"] = fn

# These are explained in crypt/crypt-entry.c in glibc's code.  The prefixes
# we use for the different crypt salts:
#     $1$    MD5
#     $5$    SHA256
#     $6$    SHA512
def cryptPassword(password, algo=None):
    salts = {'md5': '$1$', 'sha256': '$5$', 'sha512': '$6$', None: ''}
    saltstr = salts[algo]
    saltlen = 2

    if algo == 'md5' or algo == 'sha256' or algo == 'sha512':
        saltlen = 16

    for i in range(saltlen):
        saltstr = saltstr + random.choice (string.letters +
                                           string.digits + './')

    return crypt.crypt (password, saltstr)

class Users:
    def __init__ (self):
        self.admin = libuser.admin()

    def createUser(self,
                   username=None, fullname=None, password=None,
                   isCrypted=False, isSudoer=False,
                   groups=[], homedir=None,
                   shell=None, uid=None, algo=None,
                   lock=False, root="/mnt/sysimage"):
        childpid = os.fork()

        if not childpid:
            os.chroot(root)
            del(os.environ["LIBUSER_CONF"])

            self.admin = libuser.admin()

            try:
                user = self.admin.lookupUserByName(username)
                if user == None:
                    #if the user doesn't already exist
                    userEnt = self.admin.initUser(username)
                else:
                    userEnt = user

                userEnt.set(libuser.GECOS, [fullname])

                if shell:
                    userEnt.set(libuser.LOGINSHELL, shell)

                if uid >= 0:
                    userEnt.set(libuser.UIDNUMBER, uid)

                groupEnt = self.admin.initGroup(username)
                grpLst = filter(lambda grp: grp,
                                map(lambda name: self.admin.lookupGroupByName(name), groups))
                gidNumber = groupEnt.get(libuser.GIDNUMBER)[0]
                userEnt.set(libuser.GIDNUMBER, [gidNumber] + 
                            map(lambda grp: grp.get(libuser.GIDNUMBER)[0], grpLst))

                if not homedir:
                    homedir = "/home/" + username

                try:
                    os.stat(homedir)
                    mkhomedir = False
                except:
                    mkhomedir = True

                userEnt.set(libuser.HOMEDIRECTORY, homedir)

                if user == None:
                    self.admin.addUser(userEnt, mkhomedir=mkhomedir)
                    self.admin.addGroup(groupEnt)

                    if not mkhomedir:
                        uidNumber = userEnt.get(libuser.UIDNUMBER)[0]
                        os.chown(homedir, uidNumber, gidNumber)
                        os.path.walk(homedir, _chown, (uidNumber, gidNumber))
                else:
                    self.admin.modifyUser(userEnt)
                    self.admin.modifyGroup(groupEnt)
                    os.chown(userEnt.get(libuser.HOMEDIRECTORY)[0],
                             userEnt.get(libuser.UIDNUMBER)[0],
                             userEnt.get(libuser.GIDNUMBER)[0])

                if password:
                    if isCrypted:
                        self.admin.setpassUser(userEnt, password, True)
                    else:
                        self.admin.setpassUser(userEnt,
                                               cryptPassword(password, algo=algo),
                                               True)

                if lock:
                    self.admin.lockUser(userEnt)

                # Add the user to all the groups they should be part of.
                for grp in grpLst:
                    grp.add(libuser.MEMBERNAME, username)
                    self.admin.modifyGroup(grp)

                # Add the user to sudoers list
                if isSudoer and os.path.exists("/etc/sudoers"):
                    os.chmod("/etc/sudoers", stat.S_IWRITE)
                    f = open("/etc/sudoers", "a")
                    f.write("\n## Allow %s to run all commands\n" % username)
                    f.write("%s    ALL=(ALL)    ALL" % username)
                    f.close()
                    os.chmod("/etc/sudoers", 0440)

                os._exit(0)
            except Exception, e:
                log.critical("Error while creating user: %s" % str(e))
                os._exit(1)

        try:
            (pid, status) = os.waitpid(childpid, 0)
        except OSError, (num, msg):
            log.critical("exception from waitpid while creating user: %s %s" % (num, msg))
            return False

        if os.WIFEXITED(status) and (os.WEXITSTATUS(status) == 0):
            return True
        else:
            return False

    def deleteUser(self, username, root="/mnt/sysimage"):
        childpid = os.fork()

        if not childpid:
            os.chroot(root)
            del(os.environ["LIBUSER_CONF"])

            self.admin = libuser.admin()

            try:
                if username == "":
                    os._exit(0)

                user = self.admin.lookupUserByName(username)
                if user != None:
                    self.admin.deleteUser(user, True, True)

                group = self.admin.lookupGroupByName(username)
                if group != None:
                    self.admin.deleteGroup(group)

                os._exit(0)
            except Exception, e:
                log.critical("Error while deleting user: %s" % str(e))
                os._exit(1)
        try:
            (pid, status) = os.waitpid(childpid, 0)
        except OSError, (num, msg):
            log.critical("exception from waitpid while deleting user: %s %s" % (num, msg))
            return False

        if os.WIFEXITED(status) and (os.WEXITSTATUS(status) == 0):
            return True
        else:
            return False

    def checkUsername(self, username, root="/mnt/sysimage"):
        if username == "":
            return (False, _("You must create a user account for this system."))
 
        childpid = os.fork()

        if not childpid:
            os.chroot(root)
            del(os.environ["LIBUSER_CONF"])

            self.admin = libuser.admin()
            user = self.admin.lookupUserByName(username)
            if user != None and user.get(libuser.UIDNUMBER)[0] < 500:
                os._exit(1)

            os._exit(0)

        try:
            (pid, status) = os.waitpid(childpid, 0)
        except OSError, (num, msg):
            log.critical("exception from waitpid while checking username: %s %s" % (num, msg))
            return (False, _("Internal error while checking username"))

        if os.WIFEXITED(status) and (os.WEXITSTATUS(status) == 0):
            return (True, "")
        else:
            return (False, _("The username '%s' is a reserved system \n"
                             "account.  Please specify another username." % username))

    def setRootPassword(self, password, isCrypted, lock, algo=None):
        rootUser = self.admin.lookupUserByName("root")

        if isCrypted:
            self.admin.setpassUser(rootUser, password, True)
        else:
            self.admin.setpassUser(rootUser, cryptPassword(password, algo=algo), True)

        if lock:
            self.admin.lockUser(rootUser)

        self.admin.modifyUser(rootUser)

    def configAutoLogin(self, username, root="/mnt/sysimage"):
        autologin = False

        # Update /etc/gdm/custom.conf if exists
        if os.path.exists(root + "/usr/sbin/gdm") and os.path.exists(root + "/etc/gdm/custom.conf"):
            # Set AutomaticLoginEnable to true
            f = open(root + "/etc/gdm/custom.conf", "r+")
            if re.search("AutomaticLoginEnable *=", f.read()):
                f.seek(0)
                str = re.sub("AutomaticLoginEnable *=.*", "AutomaticLoginEnable=true", f.read())
                f.close()
                f = open(root + "/etc/gdm/custom.conf", "w")
                f.write(str)
            else:
                f.write("\n[daemon]\n")
                f.write("AutomaticLoginEnable=true\n")
            f.close()
            
            # Set AutomaticLogin to username
            f = open(root + "/etc/gdm/custom.conf", "r+")
            if re.search("AutomaticLogin *=", f.read()):
                f.seek(0)
                str = re.sub("AutomaticLogin *=.*", "AutomaticLogin=%s" % username, f.read())
                f.close()
                f = open(root + "/etc/gdm/custom.conf", "w")
                f.write(str)
            else:
                f.seek(0)
                str = re.sub("AutomaticLoginEnable=true", "AutomaticLoginEnable=true\nAutomaticLogin=%s" % username, f.read())
                f.seek(0)
                f.write(str)
            f.close()
            autologin = True
        # custom.conf does not exist; let's create one
        elif os.path.exists(root + "/usr/sbin/gdm"):
            f = open(root + "/etc/gdm/custom.conf", "w")
            f.write("\n[daemon]\n")
            f.write("AutomaticLoginEnable=true\n")
            f.write("AutomaticLogin=%s\n" % username)
            f.close()
            autologin = True

        # Update /etc/sysconfig/desktop if exists
        if os.path.exists(root + "/etc/sysconfig/desktop"):
            f = open(root + "/etc/sysconfig/desktop", "r")
            str = re.sub("AUTOLOGIN_USER *=.*", "AUTOLOGIN_USER=%s" % username, f.read())
            f.close()
            # f.seek(0) & f.write(str) will bring errors
            f = open(root + "/etc/sysconfig/desktop", "w")
            f.write(str)
            f.close()
            autologin = True

        # Update /etc/sysconfig/uxlaunch if exists
        if os.path.exists(root + "/etc/sysconfig/uxlaunch"):
            f = open(root + "/etc/sysconfig/uxlaunch", "r")
            str = re.sub(".*user *=.*", "user=%s" % username, f.read())
            f.close()
            # f.seek(0) & f.write(str) will bring errors
            f = open(root + "/etc/sysconfig/uxlaunch", "w")
            f.write(str)
            f.close()
            autologin = True

        if not autologin:
            return False

        return True
