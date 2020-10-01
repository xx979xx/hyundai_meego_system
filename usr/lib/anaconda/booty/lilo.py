#!/usr/bin/python
#
# Module for manipulation of lilo.conf files. Original found
#    in the anaconda installer
# Copyright (c) 1999-2001 Red Hat, Inc.  Distributed under GPL.
#
# Author: Matt Wilson <msw@redhat.com>
#         Eric Troan <ewt@redhat.com>
#         Adrian Likins <alikins@redhat.com>
"""Module for manipulation of lilo.conf files."""
import string
import os

from UserDict import UserDict


class UserDictCase(UserDict):
    """A dictionary with case insensitive keys"""
    def __init__(self, data = {}):
        UserDict.__init__(self)
        # if we are passed a dictionary transfer it over...
        for k in data.keys():
            kl = string.lower(k)
            self.data[kl] = data[k]
    # some methods used to make the class work as a dictionary
    def __setitem__(self, key, value):
        key = string.lower(key)
        self.data[key] = value
    def __getitem__(self, key):
        key = string.lower(key)
        if not self.data.has_key(key):
            return None
        return self.data[key]
    get = __getitem__
    def __delitem__(self, key):
        key = string.lower(key)
        del self.data[key]
    def has_key(self, key):
        key = string.lower(key)
        return self.data.has_key(key)
    # return this data as a real hash
    def get_hash(self):
        return self.data
    # return the data for marshalling
    def __getstate__(self):
        return self.data
    # we need a setstate because of the __getstate__ presence screws up deepcopy
    def __setstate__(self, state):
        self.__init__(state)
    # get a dictionary out of this instance ({}.update doesn't get instances)
    def dict(self):
        return self.data

class LiloConfigFile:
    """class representing a lilo.conf lilo configuration file. Used to
    manipulate the file directly"""
    
    def __repr__ (self, tab = 0):
        s = ""
        for n in self.order:
            if (tab):
                s = s + '\t'
            if n[0] == '#':
                s = s + n[1:]
            else:
                s = s + n
                if self.items[n]:
                    s = s + "=" + self.items[n]
            s = s + '\n'
        for count in range(len(self.diskRemaps)):
            s = s + "disk = %s\n" % self.diskRemaps[count][1]
            s = s + "\tbios = %s\n" % self.biosRemaps[count][1] 
        for cl in self.images:
            s = s + "\n%s=%s\n" % (cl.imageType, cl.path)
            s = s + cl.__repr__(1)
        return s

    def addEntry(self, item, val = None, replace = 1):
        if not self.items.has_key(item):
            self.order.append(item)
        elif not replace:
            return

        if (val):
            self.items[item] = str(val)
        else:
            self.items[item] = None

    def getEntry(self, item):
        if self.items.has_key(item):
            return self.items[item]
        else:
            return None

    def delEntry(self, item):
        newOrder = []
        for i in self.order:
            if item != i: newOrder.append(i)
        self.order = newOrder

        del self.items[item]

    def listEntries(self):
        foo = self.items
        return foo

    def testEntry(self, item):
        if self.items.has_key(item):
            return 1
        else:
            return 0

    def getImage(self, label):
        for config in self.images:
            # sanity check
            if label is None:
                break
            if config.getEntry('label'):
                if string.lower(config.getEntry('label')) == string.lower(label):
                    return (config.imageType, config, config.path, config.other)
            if config.getEntry('alias'):
                if string.lower(config.getEntry('alias')) == string.lower(label):
                    return (config.imageType, config, config.path, config.other)
    
        
        raise IndexError, "unknown image %s" % (label)

    def addImage (self, config,first=None):
        # make sure the config has a valid label
        config.getEntry('label')
        if not config.path or not config.imageType:
            raise ValueError, "subconfig missing path or image type"

        if first:
            self.images = [config] + self.images
        else:
            self.images.append(config)

    def delImage (self, label):
        for config in self.images:
            # sanity check
            if label is None:
                break
            if config.getEntry('label'):
                if string.lower(config.getEntry('label')) == string.lower(label):
                    self.images.remove (config)
                    return

        raise IndexError, "unknown image %s" % (label,)

    def getDefault (self):
        default = None
        try:
            default = self.getEntry("default")
        except:
            pass

        if not default:
            default = self.listImages()[0]

        theDefault = self.getImage(default)

        return theDefault[1]

    def getDefaultLinux (self):
        defaultIsOther = None

        # XXX ick... this code badly needs work =\
        theDefault = self.getDefault()

        if theDefault.other:
            defaultIsOther = 1

        # if the default is other, look for the first linux image
        if theDefault.other:
            for image_label in self.listImages():
                image = self.getImage(image_label)[1]
                if not image.other:
                    theDefault = image
                    break

        # if we get here and are *still* an other, then we have no linux
        # images.  ick
        if theDefault.other:
            return None
        else:
            return theDefault

    def listImages (self):
        l = []
        for config in self.images:
            l.append(config.getEntry('label'))
        return l

    def listAliases (self):
        l = []
        for config in self.images:
            if config.getEntry('alias'):
                l.append(config.getEntry('alias'))
        return l

    def getPath (self):
        return self.path

    def write(self, file, perms = 0644):
        f = open(file, "w")
        f.write(self.__repr__())
        f.close()
        os.chmod(file, perms)

    def read (self, file):
        f = open(file, "r")
        image = None
        for l in f.readlines():
            l = l[:-1]
            orig = l
            while (l and (l[0] == ' ' or l[0] == '\t')):
                l = l[1:]
            if not l:
                continue
            if l[0] == '#' and not image:
                self.order.append('#' + orig)
                continue
            fields = string.split(l, '=', 1)
            if l[0] == '#' and image:
                args = ('#' + l,)
            elif (len(fields) == 2):
                f0 = string.strip (fields [0])
                f1 = string.strip (fields [1])
                if (f0 != "append"):
                    # people are silly and put quotes brokenly in their
                    # lilo.conf but you have to use them for append.  ARGH!
                    f1 = string.replace(f1, '"', '')
                    f1 = string.replace(f1, "'", "")
                if (f0 == "image" or f0 == "other"):
                    if image: self.addImage(image)
                    image = LiloConfigFile(imageType = f0, 
                                           path = f1)
                    if (f0 == "other"):
                        image.other = 1
                    args = None
                else:
                    args = (f0, f1)
                if (f0 == "disk"):
                    self.diskRemaps.append((f0,f1))
                    args = None
                if (f0 == "bios"):
                    self.biosRemaps.append((f0,f1))
                    args = None

            else:
                args = (string.strip (l),)

            if (args and image):
                apply(image.addEntry, args)
            elif args:
                apply(self.addEntry, args)

        if image: self.addImage(image)
            
        f.close()

    def __init__(self, imageType = None, path = None):
        self.imageType = imageType
        self.path = path
        self.order = []
        self.images = []
        self.other = None
        self.items = UserDictCase()
        self.biosRemaps = []
        self.diskRemaps = []
        self.unsupported = []


if __name__ == "__main__":
    import sys
    #sys.path.append("")
    config = LiloConfigFile ()
    config.read ('/etc/lilo.conf')
    print config
    print "image list", config.listImages()
    config.delImage ('linux')
    print '----------------------------------'
    config = LiloConfigFile ()
    config.read ('/etc/lilo.conf')
    print config
    print '----------------------------------'
    print '----------------------------------'
    print "list images"
    print config.listImages()
    print config.getImage('linux')
    print "----------------------------------"
    print "addimage (testlinux)"
    blip = """
read-only
blippy-blob=sdfsdf
append=\"sdfasdfasdf\"
root=/dev/hda6
"""
    sl = LiloConfigFile(imageType = "image", path="/boot/somevmlinuz-2.4.0")
    sl.addEntry("label", "newkernel")
    sl.addEntry("initrd", "blipppy")
    config.addImage(sl)

    print '-------------------------------------'
    print "writing out /tmp/lilo.conf"
    print config.write("/tmp/lilo.conf")
    print config
