# Array printing function
#
# Written by Konrad Hinsen <hinsenk@ere.umontreal.ca>
# last revision: 1996-3-13
# modified by Jim Hugunin 1997-3-3 for repr's and str's (and other details)

import sys
from umath import *
import Numeric

def array2string(a, max_line_width = None, precision = None,
                     suppress_small = None, separator=' ',
                     array_output=0):
    """array2string(a, max_line_width = None, precision = None,
                     suppress_small = None, separator=' ',
                     array_output=0)"""
    if len(a.shape) == 0:
        return str(a[0])

    if multiply.reduce(a.shape) == 0:
        return "zeros(%s, '%s')" % (a.shape, a.typecode())

    if max_line_width is None:
        try:
            max_line_width = sys.output_line_width
        except AttributeError:
            max_line_width = 77
    if precision is None:
        try:
            precision = sys.float_output_precision
        except AttributeError:
            precision = 8
    if suppress_small is None:
        try:
            suppress_small = sys.float_output_suppress_small
        except AttributeError:
            suppress_small = 0
    data = Numeric.ravel(a)
    type = a.typecode()
    items_per_line = a.shape[-1]
    # dvhart - added 'u' to list
    if type == 'b' or type == '1' or type == 's' or type == 'i' \
       or type == 'w' or type == 'l' or type == 'u':
        max_str_len = max(len(str(maximum.reduce(data))),
                          len(str(minimum.reduce(data))))
        format = '%' + str(max_str_len) + 'd'
        item_length = max_str_len
        format_function = lambda x, f = format: _formatInteger(x, f)
    elif type == 'f' or type == 'd':
        format, item_length = _floatFormat(data, precision, suppress_small)
        format_function = lambda x, f = format: _formatFloat(x, f)
    elif type == 'F' or type == 'D':
        real_format, real_item_length = _floatFormat(data.real, precision,
                                                     suppress_small, sign=0)
        imag_format, imag_item_length = _floatFormat(data.imaginary, precision,
                                                     suppress_small, sign=1)
        item_length = real_item_length + imag_item_length + 3
        format_function = lambda x, f1 = real_format, f2 = imag_format: \
                          _formatComplex(x, f1, f2)
    elif type == 'c':
        item_length = 1
        format_function = lambda x: str(x)
    elif type == 'O':
        item_length = max(map(lambda x: len(str(x)), data))
        format_function = _formatGeneral
    else:
        return str(a)
    final_spaces = (type != 'c')
    item_length = item_length+len(separator)
    line_width = item_length*items_per_line - final_spaces
    if line_width > max_line_width:
        indent = 6
        if indent == item_length:
            indent = 8
        items_first = (max_line_width+final_spaces)/item_length
        if items_first < 1: items_first = 1
        items_continuation = (max_line_width+final_spaces-indent)/item_length
        if items_continuation < 1: items_continuation = 1
        line_width = max(item_length*items_first,
                         item_length*items_continuation+indent) - final_spaces
        number_of_lines = 1 + (items_per_line-items_first +
                               items_continuation-1)/items_continuation
        line_format = (number_of_lines, items_first, items_continuation,
                       indent, line_width, separator)
    else:
        line_format = (1, items_per_line, 0, 0, line_width, separator)
    lst = _arrayToString(a, format_function, len(a.shape), line_format, 6*array_output, 0)[:-1]
    if array_output:
        if a.typecode() in ['l', 'd', 'D']:
            return "array(%s)" % lst
        else:
            return "array(%s,'%s')" % (lst, a.typecode())
    else:
        return lst
        
def _floatFormat(data, precision, suppress_small, sign = 0):
    exp_format = 0
    non_zero = abs(Numeric.compress(not_equal(data, 0), data))
    if len(non_zero) == 0:
        max_val = 0.
        min_val = 0.
    else:
        max_val = float(maximum.reduce(non_zero))
        min_val = float(minimum.reduce(non_zero))
        if max_val >= 1.e8:
            exp_format = 1
        if not suppress_small and (min_val < 0.0001 or max_val/min_val > 1000.):
            exp_format = 1
    if exp_format:
        large_exponent = 0 < min_val < 1e-99 or max_val >= 1e100
        max_str_len = 8 + precision + large_exponent
        if sign: format = '%+'
        else: format = '%'
        format = format + str(max_str_len) + '.' + str(precision) + 'e'
        if large_exponent: format = format + '3'
        item_length = max_str_len 
    else:
        format = '%.' + str(precision) + 'f'
        precision = min(precision, max(tuple(map(lambda x, p=precision,
                                                 f=format: _digits(x,p,f),
                                                 data))))
        max_str_len = len(str(int(max_val))) + precision + 2
        if sign: format = '%#+'
        else: format = '%#'
        format = format + str(max_str_len) + '.' + str(precision) + 'f'
        item_length = max_str_len 
    return (format, item_length)

def _digits(x, precision, format):
    s = format % x
    zeros = len(s)
    while s[zeros-1] == '0': zeros = zeros-1
    return precision-len(s)+zeros

def _arrayToString(a, format_function, rank, line_format, base_indent=0, indent_first=1):
    if rank == 0:
        return str(a[0])
    elif rank == 1:
        s = ''
        s0 = '['
        items = line_format[1]
        if indent_first:
            indent = base_indent
        else:
            indent = 0
        index = 0
        for j in range(line_format[0]):
            s = s + indent * ' '+s0
            for i in range(items):
                s = s + format_function(a[index])+line_format[-1]
                index = index + 1
                if index == a.shape[0]: break
            if s[-1] == ' ': s = s[:-1]
            s = s + '\n'
            items = line_format[2]
            indent = line_format[3]+base_indent
            s0 = ''
        s = s[:-len(line_format[-1])]+']\n'
    else:
        if indent_first:
            s = ' '*base_indent+'['
        else:
            s = '['
        for i in range(a.shape[0]-1):
            s = s + _arrayToString(a[i], format_function, rank-1, line_format, base_indent+1, indent_first=i!=0)
            s = s[:-1]+line_format[-1][:-1]+'\n'
        s = s + _arrayToString(a[a.shape[0]-1], format_function,
                               rank-1, line_format, base_indent+1)
        s = s[:-1]+']\n'
    return s

def _formatInteger(x, format):
    return format % x

def _formatFloat(x, format, strip_zeros = 1):
    if format[-1] == '3':
        format = format[:-1]
        s = format % x
        third = s[-3]
        if third == '+' or third == '-':
            s = s[1:-2] + '0' + s[-2:]
    elif format[-1] == 'f':
        s = format % x
        if strip_zeros:
            zeros = len(s)
            while s[zeros-1] == '0': zeros = zeros-1
            s = s[:zeros] + (len(s)-zeros)*' '
    else:
        s = format % x
    return s

def _formatComplex(x, real_format, imag_format):
    r = _formatFloat(x.real, real_format)
    i = _formatFloat(x.imag, imag_format, 0)
    if imag_format[-1] == 'f':
        zeros = len(i)
        while zeros > 2 and i[zeros-1] == '0': zeros = zeros-1
        i = i[:zeros] + 'j' + (len(i)-zeros)*' '
    else:
        i = i + 'j'
    return r + i

def _formatGeneral(x):
    return str(x) + ' '

if __name__ == '__main__':
    a = Numeric.arange(10)
    b = Numeric.array([a, a+10, a+20])
    c = Numeric.array([b,b+100, b+200])
    print array2string(a)
    print array2string(b)
    print array2string(sin(c), separator=', ', array_output=1)
    print array2string(sin(c)+1j*cos(c), separator=', ', array_output=1)
    print array2string(Numeric.array([[],[]]))
