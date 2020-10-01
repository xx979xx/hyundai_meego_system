""" A simple hack to start thinking about a better way to handle
specification of typecodes.

TODO:
    The code_table should probably be cached somehow
    Float/Complex needs to have precision and range specifiers
"""

from multiarray import zeros
import string

# dvhart - added the character 'u' for the UnsignedInteger 'list of codes' ?
typecodes = {'Character':'c', 'Integer':'1sil', 'UnsignedInteger':'bwu', 'Float':'fd', 'Complex':'FD'}

def _get_precisions(typecodes):
    lst = []
    for t in typecodes:
        lst.append( (zeros( (1,), t ).itemsize()*8, t) )
    return lst

def _fill_table(typecodes, table={}):
    for key, value in typecodes.items():
        table[key] = _get_precisions(value)
    return table

_code_table = _fill_table(typecodes)

class PrecisionError(Exception):
    pass

def _lookup(table, key, required_bits):
    lst = table[key]
    for bits, typecode in lst:
        if bits >= required_bits:
            return typecode
    raise PrecisionError, key+" of "+str(required_bits)+" bits not available on this system"

Character = 'c'

try:
    UnsignedInt8 = _lookup(_code_table, "UnsignedInteger", 8)
    UInt8 = UnsignedInt8
except(PrecisionError):
    pass
try:
    UnsignedInt16 = _lookup(_code_table, "UnsignedInteger", 16)
    UInt16 = UnsignedInt16
except(PrecisionError):
    pass
try:
    UnsignedInt32 = _lookup(_code_table, "UnsignedInteger", 32)
    UInt32 = UnsignedInt32
except(PrecisionError):
    pass
try:
    UnsignedInt64 = _lookup(_code_table, "UnsignedInteger", 64)
    UInt64 = UnsignedInt64
except(PrecisionError):
    pass
try:
    UnsignedInt128 = _lookup(_code_table, "UnsignedInteger", 128)
    UInt128 = UnsignedInt128
except(PrecisionError):
    pass
UnsignedInteger = 'u'
UInt = UnsignedInteger


try: Int0 = _lookup(_code_table, 'Integer', 0)
except(PrecisionError): pass
try: Int8 = _lookup(_code_table, 'Integer', 8)
except(PrecisionError): pass
try: Int16 = _lookup(_code_table, 'Integer', 16)
except(PrecisionError): pass
try: Int32 = _lookup(_code_table, 'Integer', 32)
except(PrecisionError): pass
try: Int64 = _lookup(_code_table, 'Integer', 64)
except(PrecisionError): pass
try: Int128 = _lookup(_code_table, 'Integer', 128)
except(PrecisionError): pass
Int = 'l'

try: Float0 = _lookup(_code_table, 'Float', 0)
except(PrecisionError): pass
try: Float8 = _lookup(_code_table, 'Float', 8)
except(PrecisionError): pass
try: Float16 = _lookup(_code_table, 'Float', 16)
except(PrecisionError): pass
try: Float32 = _lookup(_code_table, 'Float', 32)
except(PrecisionError): pass
try: Float64 = _lookup(_code_table, 'Float', 64)
except(PrecisionError): pass
try: Float128 = _lookup(_code_table, 'Float', 128)
except(PrecisionError): pass
Float = 'd'

try: Complex0 = _lookup(_code_table, 'Complex', 0)
except(PrecisionError): pass
try: Complex8 = _lookup(_code_table, 'Complex', 16)
except(PrecisionError): pass
try: Complex16 = _lookup(_code_table, 'Complex', 32)
except(PrecisionError): pass
try: Complex32 = _lookup(_code_table, 'Complex', 64)
except(PrecisionError): pass
try: Complex64 = _lookup(_code_table, 'Complex', 128)
except(PrecisionError): pass
try: Complex128 = _lookup(_code_table, 'Complex', 256)
except(PrecisionError): pass
Complex = 'D'

PyObject = 'O'
