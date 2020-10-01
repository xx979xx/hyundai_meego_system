#
# descriptors.py: classes implementing pythons "descriptor" protocol,
# which are usable as python properties
#
# Peter Jones <pjones@redhat.com>
#
# Copyright 2005 Red Hat, Inc.
#
# This software may be freely redistributed under the terms of the GNU
# library public license.
#
# You should have received a copy of the GNU Library Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#

class SimpleBoolDescriptor(object):
    """A data descriptor which constrains its values to True and False."""

    def __init__(self):
        self.val = False

    def __get__(self, obj, objtype):
        return self.val

    def __set__(self, obj, val):
        if not isinstance(val, type(True)):
            raise TypeError, "value is not True of False"
        self.val = val

class BoolDescriptor(SimpleBoolDescriptor):
    """A data descriptor which constrains its values to True
       and False, and may be set immutable
    """
    immutable = SimpleBoolDescriptor()

    def __set__(self, obj, val):
        if self.immutable:
            raise RuntimeError, "attribute is immutable"
        SimpleBoolDescriptor.__set__(self, obj, val)

class TristateDescriptor(BoolDescriptor):
    """A data descriptor which constrains its values to True,
       False, and None, and which may be set immutable
    """
    immutable = SimpleBoolDescriptor()

    def __set__(self, obj, val):
        if self.immutable:
            raise RuntimeError, "attribute is immutable"
        if isinstance(val, type(None)):
            self.val = None
            return
        BoolDescriptor.__set__(self, obj, val)

class NonNegativeIntegerDescriptor(object):
    """A data descriptor which constrains its values to non-negative integers
    """

    immutable = SimpleBoolDescriptor()

    def __set__(self, obj, val):
        if self.immutable:
            raise RuntimeError, "attribute is immutable"
        if not isinstance(val, type(int(1))) and \
                not isinstance(val, type(long(1))):
            raise TypeError, type(val)
        if val < 0:
            raise ValueError, "%s is less than 0" % (int(val,))
        self.val = val

    def __get__(self, obj, objtype):
        return self.val
