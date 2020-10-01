#
# genModule.py: make python modules on the fly
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
def create(mname, attrs):
    import imp

    m = imp.new_module(mname)
    del imp
    for k,v in attrs.items():
        setattr(m, k, v)
    return m

def install(mname, m):
    import sys
    sys.modules[mname] = m
    del sys

def generate(parent, mname, attrs):
    m = create(mname, attrs)
    # if parent isn't in sys.modules, this won't work...
    install(parent + '.' + mname, m)
    return m
    
# this is just a set of random examples, really
if __name__ == '__main__':
    m = create('a', {'b': lambda x: x})

    import sys
    sys.modules['a'] = m

    print m.b(1)

    import a
    print a.b(2)

    def zoink(x):
        print x

    generate('__main__', 'bar', {'baz': zoink})
    from __main__.bar import baz
    baz(3)
