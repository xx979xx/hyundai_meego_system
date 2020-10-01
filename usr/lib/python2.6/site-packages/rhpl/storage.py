#
# storage.py: classes to handle attributes of storage such as size.
#
# Peter Jones <pjones@redhat.com>
#
# Copyright 2005 Red Hat, Inc.
#
# This software may be freely redistributed under the terms of the GNU
# general public license.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

import genModule

class Unit(object):
    def __init__(self, abbr, value):
        self.abbr = str(abbr)
        self.value = long(value)

    def __long__(self):
        return long(self.value)

    def __str__(self):
        return str(self.abbr)

    def __call__(self, num=0, display_force_unit=None):
        s = Size(self.value)
        s *= num

        s.display_force_unit = display_force_unit

        return s

    def __cmp__(self, other):
        if other is None:
            return -2
        return cmp(long(self), long(other))

units = genModule.generate(__name__, 'units', {
    'Bytes' : Unit('B', 1),
    'kBytes' : Unit('kB', 1024),
    'MBytes' : Unit('MB', 1024**2),
    'GBytes' : Unit('GB', 1024**3),
    'TBytes' : Unit('TB', 1024**4),
})

class Size(object):
    from descriptors import TristateDescriptor, BoolDescriptor, \
        NonNegativeIntegerDescriptor

    clamped = TristateDescriptor()
    display_space = BoolDescriptor()
    display_precision = NonNegativeIntegerDescriptor()
    display_unit = BoolDescriptor()
    roundup = BoolDescriptor()

    def __init__(self, bytes=0, display_force_unit=None):
        import math
        self.bytes = long(math.floor(bytes))

        self.clamped = False
        self.clampbytes = None
        self.roundup = False

        self.display_precision = 2
        self.display_space = True
        self.display_unit = True
        self.display_force_unit = display_force_unit

    def clamp(self, bytes=None):
        if bytes is None and self.clampbytes is None:
            self.clampbytes = 0
            self.clamped = True
        elif bytes is not None:
            self.clampbytes = bytes
            self.clamped = True
        else:
            self.clamped = True
        return self

    def unclamp(self, reset=False):
        if reset:
            self.clampbytes = None
        self.clamped = False
        return self

    def shrink(self):
        """Reduce the unclamped size of the Size object to that of it's
           current size, taking clamping into account, and reset the clamp
           state.
        """
           
        self.bytes = long(self)
        self.unclamp(reset=True)
        return self

    def __long__(self):
        import math
        if self.roundup:
            func = math.ceil
        else:
            func = math.floor
        del math

        if self.clamped:
            return long(func(self.bytes/self.clampbytes)*self.clampbytes)
        return long(self.bytes)

    def __float__(self):
        return float(long(self))

    def __mul__(self, other):
        ret = Size(self)
        ret *= other
        return ret

    def __div__(self, other):
        ret = Size(self)
        ret /= other
        return ret

    def __mod__(self, other):
        ret = Size(self)
        ret %= other
        return ret

    def __add__(self, other):
        ret = Size(self)
        ret += other
        return ret

    def __sub__(self, other):
        ret = Size(self)
        ret -= other
        return ret

    def __imul__(self, other):
        import math
        self.bytes = long(math.floor(float(self.bytes) * float(other)))
        return self

    def __idiv__(self, other):
        import math
        self.bytes = long(math.floor(float(self) / float(other)))
        return self

    def __imod__(self, other):
        import math
        self.bytes = long(math.floor(float(self) % float(other)))
        return self

    def __iadd__(self, other):
        self.bytes += long(other)
        return self

    def __isub__(self, other):
        self.bytes -= long(other)
        return self

    def __cmp__(self, other):
        return cmp(self.bytes, long(other))

    def __str__(self):
        from storage.units import Bytes, kBytes, MBytes, GBytes, TBytes
        units = [Bytes, kBytes, MBytes, GBytes, TBytes]
        for u in units:
            scale = u
            scaled_size = float(self.bytes) / long(u)

            if (scaled_size < 1024 and not self.display_force_unit) \
                    or u == self.display_force_unit:
                fmt = '%.' + str(self.display_precision) + 'f'
                args = [float(scaled_size),]

                if self.display_unit:
                    if self.display_space:
                        fmt += ' '

                    fmt += '%s'
                    args.append(str(u))

                return fmt % tuple(args)

        raise ValueError, "%s bytes is more than 1024 TB" % (self.bytes,)

    def __repr__(self):
        return "Size(bytes=%s)" % (self.bytes,)

    def asBytes(self):
        return long(self)

    def askBytes(self):
        return long(self / 1024)

    def asMBytes(self):
        return long(self / (1024**2))

    def asGBytes(self):
        return long(self / (1024**3))

    def asTBytes(self):
        return long(self / (1024**4))

    def setBytes(self, size):
        self.bytes = size
        self.clampedFrom = None
        return self

    def setkBytes(self, size):
        return self.setBytes(size * 1024)

    def setMBytes(self, size):
        return self.setBytes(size * 1024**2)

    def setGBytes(self, size):
        return self.setBytes(size * 1024**3)

    def setTBytes(self, size):
        return self.setBytes(size * 1024**4)

    def sectors(self, sector_size=512):
        sector_size = Size().setBytes(sector_size)
        sectors = self / sector_size
        return sectors

#constructors = genModule.generate(__name__, 'constructors', {
#    'Bytes': lambda x: Size().setBytes(x),
#    'kBytes': lambda x: Size().setkBytes(x),
#    'kiloBytes': lambda x: Size().setkBytes(x),
#    'MBytes': lambda x: Size().setMBytes(x),
#    'MegaBytes': lambda x: Size().setMBytes(x),
#    'GBytes': lambda x: Size().setGBytes(x),
#    'GigaBytes': lambda x: Size().setGBytes(x),
#    'TBytes': lambda x: Size().setTBytes(x),
#    'TeraBytes': lambda x: Size().setTBytes(x),
#})

del genModule

__all__ = ['Size', 'units', 'Unit']

def __storage_test():
    from storage.units import Bytes, MBytes

    x = Bytes(1)
    if str(x) != "1.00 B": raise RuntimeError, str(x)

    x = Bytes(1024)
    if str(x) != "1.00 kB": raise RuntimeError, str(x)

    x.display_force_unit=Bytes
    if str(x) != "1024.00 B": raise RuntimeError, str(x)

    x.display_precision=0
    if str(x) != "1024 B": raise RuntimeError, str(x)

    x.display_force_unit = None
    if str(x) != "1 kB": raise RuntimeError, str(x)

    x.display_force_unit = MBytes
    if str(x) != "0 MB": raise RuntimeError, str(x)

    x.display_force_unit = None
    x.display_precision=2
    x.display_unit = False
    if str(x) != "1.00": raise RuntimeError, str(x)

__storage_test()
del __storage_test
