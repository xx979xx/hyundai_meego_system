# Copyright (C) 2003, 2004, 2005, 2006 Red Hat Inc. <http://www.redhat.com/>
# Copyright (C) 2003 David Zeuthen
# Copyright (C) 2004 Rob Taylor
# Copyright (C) 2005, 2006 Collabora Ltd. <http://www.collabora.co.uk/>
# Copyright (C) 2007 John (J5) Palmieri
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use, copy,
# modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER

from xml.parsers.expat import ExpatError, ParserCreate
from dbus.exceptions import IntrospectionParserException

class _Parser(object):
    __slots__ = ('map', 
                 'in_iface', 
                 'in_method', 
                 'in_signal',
                 'in_property',
                 'property_access',
                 'in_sig',
                 'out_sig', 
                 'node_level',
                 'in_signal')
    def __init__(self):
        self.map = {'child_nodes':[],'interfaces':{}}
        self.in_iface = ''
        self.in_method = ''
        self.in_signal = ''
        self.in_property = ''
        self.property_access = ''
        self.in_sig = [] 
        self.out_sig = []
        self.node_level = 0

    def parse(self, data):
        parser = ParserCreate('UTF-8', ' ')
        parser.buffer_text = True
        parser.StartElementHandler = self.StartElementHandler
        parser.EndElementHandler = self.EndElementHandler
        parser.Parse(data)
        return self.map

    def StartElementHandler(self, name, attributes):
        if name == 'node':
            self.node_level += 1
            if self.node_level == 2:
                self.map['child_nodes'].append(attributes['name'])
        elif not self.in_iface:
            if (not self.in_method and name == 'interface'):
                self.in_iface = attributes['name']
        else:
            if (not self.in_method and name == 'method'):
                self.in_method = attributes['name']
            elif (self.in_method and name == 'arg'):
                arg_type = attributes['type']
                arg_name = attributes.get('name', None)
                if attributes.get('direction', 'in') == 'in':
                    self.in_sig.append({'name': arg_name, 'type': arg_type})
                if attributes.get('direction', 'out') == 'out':
                    self.out_sig.append({'name': arg_name, 'type': arg_type})
            elif (not self.in_signal and name == 'signal'):
                self.in_signal = attributes['name']
            elif (self.in_signal and name == 'arg'):
                arg_type = attributes['type']
                arg_name = attributes.get('name', None)

                if attributes.get('direction', 'in') == 'in':
                    self.in_sig.append({'name': arg_name, 'type': arg_type})
            elif (not self.in_property and name == 'property'):
                prop_type = attributes['type']
                prop_name = attributes['name']

                self.in_property = prop_name
                self.in_sig.append({'name': prop_name, 'type': prop_type})
                self.property_access = attributes['access']


    def EndElementHandler(self, name):
        if name == 'node':
            self.node_level -= 1
        elif self.in_iface:
            if (not self.in_method and name == 'interface'):
                self.in_iface = ''
            elif (self.in_method and name == 'method'):
                if not self.map['interfaces'].has_key(self.in_iface):
                    self.map['interfaces'][self.in_iface]={'methods':{}, 'signals':{}, 'properties':{}}

                if self.map['interfaces'][self.in_iface]['methods'].has_key(self.in_method):
                    print "ERROR: Some clever service is trying to be cute and has the same method name in the same interface"
                else:
                    self.map['interfaces'][self.in_iface]['methods'][self.in_method] = (self.in_sig, self.out_sig)

                self.in_method = ''
                self.in_sig = [] 
                self.out_sig = []
            elif (self.in_signal and name == 'signal'):
                if not self.map['interfaces'].has_key(self.in_iface):
                    self.map['interfaces'][self.in_iface]={'methods':{}, 'signals':{}, 'properties':{}}

                if self.map['interfaces'][self.in_iface]['signals'].has_key(self.in_signal):
                    print "ERROR: Some clever service is trying to be cute and has the same signal name in the same interface"
                else:
                    self.map['interfaces'][self.in_iface]['signals'][self.in_signal] = (self.in_sig,)

                self.in_signal = ''
                self.in_sig = []
                self.out_sig = []
            elif (self.in_property and name == 'property'):
                if not self.map['interfaces'].has_key(self.in_iface):
                    self.map['interfaces'][self.in_iface]={'methods':{}, 'signals':{}, 'properties':{}}

                if self.map['interfaces'][self.in_iface]['properties'].has_key(self.in_property):
                    print "ERROR: Some clever service is trying to be cute and has the same property name in the same interface"
                else:
                    self.map['interfaces'][self.in_iface]['properties'][self.in_property] = (self.in_sig, self.property_access)

                self.in_property = ''
                self.in_sig = [] 
                self.out_sig = []
                self.property_access = ''


def process_introspection_data(data):
    """Return a structure mapping all of the elements from the introspect data 
       to python types TODO: document this structure

    :Parameters:
        `data` : str
            The introspection XML. Must be an 8-bit string of UTF-8.
    """
    try:
        return _Parser().parse(data)
    except Exception, e:
        raise IntrospectionParserException('%s: %s' % (e.__class__, e))
