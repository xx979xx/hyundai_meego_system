"""Numeric module defining a multi-dimensional array and useful procedures for
   Numerical computation.

Functions

-   array                      - NumPy Array construction
-   zeros                      - Return an array of all zeros
-   empty                      - Return an uninitialized array (200x faster than zeros)
-   shape                      - Return shape of sequence or array
-   rank                       - Return number of dimensions
-   size                       - Return number of elements in entire array or a
                                 certain dimension
-   fromstring                 - Construct array from (byte) string
-   take                       - Select sub-arrays using sequence of indices
-   put                        - Set sub-arrays using sequence of 1-D indices
-   putmask                    - Set portion of arrays using a mask
-   reshape                    - Return array with new shape
-   repeat                     - Repeat elements of array
-   choose                     - Construct new array from indexed array tuple
-   cross_correlate            - Correlate two 1-d arrays
-   searchsorted               - Search for element in 1-d array
-   sum                        - Total sum over a specified dimension
-   average                    - Average, possibly weighted, over axis or array.
-   cumsum                     - Cumulative sum over a specified dimension
-   product                    - Total product over a specified dimension
-   cumproduct                 - Cumulative product over a specified dimension
-   alltrue                    - Logical and over an entire axis
-   sometrue                   - Logical or over an entire axis
-   allclose		       - Tests if sequences are essentially equal

More Functions:

-   arrayrange (arange)        - Return regularly spaced array
-   asarray                    - Guarantee NumPy array
-   sarray                     - Guarantee a NumPy array that keeps precision
-   convolve                   - Convolve two 1-d arrays
-   swapaxes                   - Exchange axes
-   concatenate                - Join arrays together
-   transpose                  - Permute axes
-   sort                       - Sort elements of array
-   argsort                    - Indices of sorted array
-   argmax                     - Index of largest value
-   argmin                     - Index of smallest value
-   innerproduct               - Innerproduct of two arrays
-   dot                        - Dot product (matrix multiplication)
-   outerproduct               - Outerproduct of two arrays
-   resize                     - Return array with arbitrary new shape
-   indices                    - Tuple of indices
-   fromfunction               - Construct array from universal function
-   diagonal                   - Return diagonal array
-   trace                      - Trace of array
-   dump                       - Dump array to file object (pickle)
-   dumps                      - Return pickled string representing data
-   load                       - Return array stored in file object
-   loads                      - Return array from pickled string
-   ravel                      - Return array as 1-D
-   nonzero                    - Indices of nonzero elements for 1-D array
-   shape                      - Shape of array
-   where                      - Construct array from binary result
-   compress                   - Elements of array where condition is true
-   clip                       - Clip array between two values
-   ones                       - Array of all ones
-   identity                   - 2-D identity array (matrix)

(Universal) Math Functions

       add                    logical_or             exp
       subtract               logical_xor            log
       multiply               logical_not            log10
       divide                 maximum                sin
       divide_safe            minimum                sinh
       conjugate              bitwise_and            sqrt
       power                  bitwise_or             tan
       absolute               bitwise_xor            tanh
       negative               invert                 ceil
       greater                left_shift             fabs
       greater_equal          right_shift            floor
       less                   arccos                 arctan2
       less_equal             arcsin                 fmod
       equal                  arctan                 hypot
       not_equal              cos                    around
       logical_and            cosh                   sign
       arccosh                arcsinh                arctanh

"""

import numeric_version
__version__ = numeric_version.version
del numeric_version

import multiarray
from umath import *
from Precision import *

import _numpy # for freeze dependency resolution (at least on Mac)

import string, types, math

#Use this to add a new axis to an array
NewAxis = None

#The following functions are considered builtin, they all might be
#in C some day

##def range2(start, stop=None, step=1, typecode=None):
##    """Just like range() except it returns a array whose type can be specified
##    by the keyword argument typecode.
##    """
##
##    if (stop is None):
##        stop = start
##        start = 0
##    n = int(math.ceil(float(stop-start)/step))
##    if n <= 0:
##        m = zeros( (0,) )+(step+start+stop)
##    else:
##        m = (add.accumulate(ones((n,), Int))-1)*step +(start+(stop-stop))
##        # the last bit is to deal with e.g. Longs -- 3L-3L==0L
##   if typecode is not None and m.typecode() != typecode:
##        return m.astype(typecode)
##    else:
##        return m

arrayrange = multiarray.arange

array = multiarray.array
zeros = multiarray.zeros
empty = multiarray.empty

def asarray(a, typecode=None, savespace=0):
    """asarray(a,typecode=None) returns a as a NumPy array.  Unlike array(),
    no copy is performed if a is already an array.
    """
    return multiarray.array(a, typecode, copy=0, savespace=savespace)

def sarray(a, typecode=None, copy=0):
    """sarray(a, typecode=None, copy=0) calls array with savespace=1."""
    return multiarray.array(a, typecode, copy, savespace=1)

fromstring = multiarray.fromstring
take = multiarray.take
reshape = multiarray.reshape
choose = multiarray.choose
cross_correlate = multiarray.cross_correlate

def repeat(a, repeats, axis=0):
    """repeat elements of a repeats times along axis
       repeats is a sequence of length a.shape[axis]
       telling how many times to repeat each element.
       If repeats is an integer, it is interpreted as
       a tuple of length a.shape[axis] containing repeats.
       The argument a can be anything array(a) will accept.
    """
    a = array(a, copy=0)
    s = a.shape
    if isinstance(repeats, types.IntType):
        repeats = tuple([repeats]*(s[axis]))
    if len(repeats) != s[axis]:
        raise ValueError, "repeat requires second argument integer or of length of a.shape[axis]."
    d = multiarray.repeat(a, repeats, axis)
    return d

def put (a, ind, v):
    """put(a, ind, v) results in a[n] = v[n] for all n in ind
       If v is shorter than mask it will be repeated as necessary.
       In particular v can be a scalar or length 1 array.
       The routine put is the equivalent of the following (although the loop
       is in C for speed):

           ind = array(indices, copy=0)
           v = array(values, copy=0).astype(a, typecode())
           for i in ind: a.flat[i] = v[i]
       a must be a contiguous Numeric array.
    """
    multiarray.put (a, ind, array(v, copy=0).astype(a.typecode()))

def putmask (a, mask, v):
    """putmask(a, mask, v) results in a = v for all places mask is true.
       If v is shorter than mask it will be repeated as necessary.
       In particular v can be a scalar or length 1 array.
    """
    tc = a.typecode()
    mask = asarray(mask).astype(Int)
    v = array(v, copy=0).astype(tc)
    if tc == PyObject:
        if v.shape == (): v.shape=(1,)
        ax = ravel(a)
        mx = ravel(mask)
        vx = ravel(v)
        vx = resize(vx, ax.shape)
        for i in range(len(ax)):
            if mx[i]: ax[i] = vx[i]
    else:
        multiarray.putmask (a, mask, v)

def convolve(a,v,mode=2):
    """Returns the discrete, linear convolution of 1-D
    sequences a and v; mode can be 0 (valid), 1 (same), or 2 (full)
    to specify size of the resulting sequence.
    """
    if (len(v) > len(a)):
        temp = a
        a = v
        v = temp
        del temp
    return cross_correlate(a,asarray(v)[::-1],mode)

ArrayType = multiarray.arraytype
UfuncType = type(sin)

def swapaxes(a, axis1, axis2):
    """swapaxes(a, axis1, axis2) returns array a with axis1 and axis2
    interchanged.
    """
    a = array(a, copy=0)
    n = len(a.shape)
    if n <= 1: return a
    if axis1 < 0: axis1 += n
    if axis2 < 0: axis2 += n
    if axis1 < 0 or axis1 >= n:
        raise ValueError, "Bad axis1 argument to swapaxes."
    if axis2 < 0 or axis2 >= n:
        raise ValueError, "Bad axis2 argument to swapaxes."
    new_axes = arange(n)
    new_axes[axis1] = axis2
    new_axes[axis2] = axis1
    return multiarray.transpose(a, new_axes)

arraytype = multiarray.arraytype
#add extra intelligence to the basic C functions
def concatenate(a, axis=0):
    """concatenate(a, axis=0) joins the tuple of sequences in a into a single
    NumPy array.
    """
    if axis == 0:
        return multiarray.concatenate(a)
    else:
        new_list = []
        for m in a:
            new_list.append(swapaxes(m, axis, 0))
    return swapaxes(multiarray.concatenate(new_list), axis, 0)

def transpose(a, axes=None):
    """transpose(a, axes=None) returns array with dimensions permuted
    according to axes.  If axes is None (default) returns array with
    dimensions reversed.
    """
#    if axes is None: # this test has been moved into multiarray.transpose
#        axes = arange(len(array(a).shape))[::-1]
    return multiarray.transpose(a, axes)

def sort(a, axis=-1):
    """sort(a,axis=-1) returns array with elements sorted along given axis.
    """
    a = array(a, copy=0)
    n = len(a.shape)
    if axis < 0: axis += n
    if axis < 0 or axis >= n:
        raise ValueError, "sort axis argument out of bounds"
    if axis != n-1: a = swapaxes(a, axis, n-1)
    s = multiarray.sort(a)
    if axis != n-1: s = swapaxes(s, axis, -1)
    return s

def argsort(a, axis=-1):
    """argsort(a,axis=-1) return the indices into a of the sorted array
    along the given axis, so that take(a,result,axis) is the sorted array.
    """
    a = array(a, copy=0)
    n = len(a.shape)
    if axis < 0: axis += n
    if axis < 0 or axis >= n:
        raise ValueError, "argsort axis argument out of bounds"
    if axis != n-1: a = swapaxes(a, axis, n-1)
    s = multiarray.argsort(a)
    if axis != n-1: s = swapaxes(s, axis, -1)
    return s

def argmax(a, axis=-1):
    """argmax(a,axis=-1) returns the indices to the maximum value of the
    1-D arrays along the given axis.
    """
    a = array(a, copy=0)
    n = len(a.shape)
    if axis < 0: axis += n
    if axis < 0 or axis >= n:
        raise ValueError, "argmax axis argument out of bounds"
    if axis != n-1: a = swapaxes(a, axis, n-1)
    s = multiarray.argmax(a)
    if axis != n-1: s = swapaxes(s, axis, -1)
    return s

def argmin(a, axis=-1):
    """argmin(a,axis=-1) returns the indices to the minimum value of the
    1-D arrays along the given axis.
    """
    arra = array(a,copy=0)
    type = arra.typecode()
    num = array(0,type)
    if type in ['bwu']:
        num = -array(1,type)
    a = num-arra
    n = len(a.shape)
    if axis < 0: axis += n
    if axis < 0 or axis >= n:
        raise ValueError, "argmin axis argument out of bounds"
    if axis != n-1: a = swapaxes(a, axis, n-1)
    s = multiarray.argmax(a)
    if axis != n-1: s = swapaxes(s, axis, -1)
    return s


searchsorted = multiarray.binarysearch

def innerproduct(a,b):
    """innerproduct(a,b) returns the dot product of two arrays, which has
    shape a.shape[:-1] + b.shape[:-1] with elements computed by summing the
    product of the elements from the last dimensions of a and b.
    """
    try:
        return multiarray.innerproduct(a,b)
    except TypeError,detail:
        if array(a).shape == () or array(b).shape == ():
            return a*b
        else:
            raise TypeError, detail or "invalid types for dot"

def outerproduct(a,b):
   """outerproduct(a,b) returns the outer product of two vectors.
      result(i,j) = a(i)*b(j) when a and b are vectors
      Will accept any arguments that can be made into vectors.
   """
   return array(a).flat[:,NewAxis]*array(b).flat[NewAxis,:]

#dot = multiarray.matrixproduct
# how can I associate this doc string with the function dot?
def dot(a, b):
    """dot(a,b) returns matrix-multiplication between a and b.  The product-sum
    is over the last dimension of a and the second-to-last dimension of b.
    """
    try:
        return multiarray.matrixproduct(a, b)
    except TypeError,detail:
        if array(a).shape == () or array(b).shape == ():
            return a*b
        else:
            raise TypeError, detail or "invalid types for dot"

def vdot(a, b):
    """Returns the dot product of 2 vectors (or anything that can be made into
       a vector). NB: this is not the same as `dot`, as it takes the conjugate
       of its first argument if complex and always returns a scalar."""
    return multiarray.matrixproduct(conjugate(ravel(a)),
                                    ravel(b))

# try to import blas optimized dot, innerproduct and vdot, if available
try:
    from dotblas import dot, innerproduct, vdot
except ImportError: pass

#This is obsolete, don't use in new code
matrixmultiply = dot

def _move_axis_to_0(a, axis):
    if axis == 0:
        return a
    n = len(a.shape)
    if axis < 0:
        axis += n
    axes = range(1, axis+1) + [0,] + range(axis+1, n)
    return multiarray.transpose(a, axes)

def cross_product(a, b, axis1=-1, axis2=-1):
    """Return the cross product of two vectors.

    The cross product is performed over the last axes of a and b by default,
    and can handle axes with dimensions 2 and 3. For a dimension of 2,
    the z-component of the equivalent three-dimensional cross product is
    returned.
    """
    a = _move_axis_to_0(asarray(a), axis1)
    b = _move_axis_to_0(asarray(b), axis2)
    if a.shape[0] != b.shape[0]:
        raise ValueError("incompatible dimensions for cross product")
    elif a.shape[0] == 2:
        return a[0]*b[1] - a[1]*b[0]
    elif a.shape[0] == 3:
        x = a[1]*b[2] - a[2]*b[1]
        y = a[2]*b[0] - a[0]*b[2]
        z = a[0]*b[1] - a[1]*b[0]
        cp = array([x,y,z])
        if len(cp.shape) == 1:
            return cp
        # we put the result (in the first axis) as the last axis
        axes = range(1, len(cp.shape)) + [0]
        return multiarray.transpose(cp, axes)
    else:
        raise ValueError("can only do cross product for axes with dimensions 2 or 3")

#Use Konrad's printing function (modified for both str and repr now)
from ArrayPrinter import array2string
def array_repr(a, max_line_width = None, precision = None, suppress_small = None):
    return array2string(a, max_line_width, precision, suppress_small, ', ', 1)

def array_str(a, max_line_width = None, precision = None, suppress_small = None):
    return array2string(a, max_line_width, precision, suppress_small, ' ', 0)

multiarray.set_string_function(array_str, 0)
multiarray.set_string_function(array_repr, 1)

#This is a nice value to have around
#Maybe in sys some day
LittleEndian = fromstring("\001"+"\000"*7, 'i')[0] == 1

def resize(a, new_shape):
    """resize(a,new_shape) returns a new array with the specified shape.
    The original array's total size can be any size.
    """

    a = ravel(a)
    if not len(a): return zeros(new_shape, a.typecode())
    total_size = multiply.reduce(new_shape)
    n_copies = int(total_size / len(a))
    extra = total_size % len(a)

    if extra != 0:
        n_copies = n_copies+1
        extra = len(a)-extra

    a = concatenate( (a,)*n_copies)
    if extra > 0:
        a = a[:-extra]

    return reshape(a, new_shape)

def indices(dimensions, typecode=None):
    """indices(dimensions,typecode=None) returns an array representing a grid
    of indices with row-only, and column-only variation.
    """
    tmp = ones(dimensions, typecode)
    lst = []
    for i in range(len(dimensions)):
        lst.append( add.accumulate(tmp, i, )-1 )
    return array(lst)

def fromfunction(function, dimensions):
    """fromfunction(function, dimensions) returns an array constructed by
    calling function on a tuple of number grids.  The function should
    accept as many arguments as there are dimensions which is a list of
    numbers indicating the length of the desired output for each axis.
    """
    return apply(function, tuple(indices(dimensions)))


def diagonal(a, offset= 0, axis1=0, axis2=1):
    """diagonal(a, offset=0, axis1=0, axis2=1) returns all offset diagonals
    defined by the given dimensions of the array.
    """
    a = asarray (a)
    nd = len(a.shape)
    new_axes = range(nd)
    if (axis1 < 0): axis1 += nd
    if (axis2 < 0): axis2 += nd
    try:
        new_axes.remove(axis1)
        new_axes.remove(axis2)
    except ValueError:
            raise ValueError, "axis1(=%d) and axis2(=%d) must be different "\
                  "and within range (nd=%d)." % (axis1, axis2, nd)
    new_axes = new_axes + [axis1, axis2]
    a = transpose(a, new_axes)
    s = a.shape
    if len (s) == 2:
        n1 = s [0]
        n2 = s [1]
        n = n1 * n2
        s = (n,)
        a = reshape (a, s)
        if offset < 0:
            return take (a, range (-n2*offset, min(n2, n1+offset)*(n2+1) -
                                   n2*offset, n2+1), 0)
        else:
            return take (a, range (offset,  min(n1, n2-offset) * (n2+1) +
                                   offset, n2+1), 0)
    else :
        my_diagonal = []
        for i in range (s [0]) :
            my_diagonal.append (diagonal (a [i], offset))
        return array (my_diagonal)

def trace(a, offset=0, axis1=0, axis2=1):
    """trace(a,offset=0, axis1=0, axis2=1) returns the sum along diagonals
    (defined by the last two dimensions) of the array.
    """
    return add.reduce(diagonal(a, offset, axis1, axis2),-1)


# These two functions are used in my modified pickle.py so that
# matrices can be pickled.  Notice that matrices are written in
# binary format for efficiency, but that they pay attention to
# byte-order issues for  portability.

def DumpArray(m, fp):
    if m.typecode() == 'O':
        raise TypeError, "Numeric Pickler can't pickle arrays of Objects"
    s = m.shape
    if LittleEndian: endian = "L"
    else: endian = "B"
    fp.write("A%s%s%d " % (m.typecode(), endian, m.itemsize()))
    for d in s:
        fp.write("%d "% d)
    fp.write('\n')
    fp.write(m.tostring())

def LoadArray(fp):
    ln = string.split(fp.readline())
    if ln[0][0] == 'A': ln[0] = ln[0][1:] # Nasty hack showing my ignorance of pickle
    typecode = ln[0][0]
    endian = ln[0][1]

    shape = map(lambda x: string.atoi(x), ln[1:])
    itemsize = string.atoi(ln[0][2:])

    sz = reduce(multiply, shape)*itemsize
    data = fp.read(sz)

    m = fromstring(data, typecode)
    m = reshape(m, shape)

    if (LittleEndian and endian == 'B') or (not LittleEndian and endian == 'L'):
        return m.byteswapped()
    else:
        return m

import pickle, copy
class Unpickler(pickle.Unpickler):
    def load_array(self):
        self.stack.append(LoadArray(self))

    dispatch = copy.copy(pickle.Unpickler.dispatch)
    dispatch['A'] = load_array

class Pickler(pickle.Pickler):
    def save_array(self, object):
        DumpArray(object, self)

    dispatch = copy.copy(pickle.Pickler.dispatch)
    dispatch[ArrayType] = save_array

#Convenience functions
from StringIO import StringIO

from pickle import load, loads, dump, dumps 
 
# slightly different format uses the copy_reg mechanism 
import copy_reg 
 
def array_constructor(shape, typecode, thestr, Endian=LittleEndian): 
    if typecode == "O":
        x = array(thestr,"O") 
    else: 
        x = fromstring(thestr, typecode) 
    x.shape = shape 
    if LittleEndian != Endian: 
        return x.byteswapped() 
    else: 
        return x 
 
def pickle_array(a): 
    if a.typecode() == "O": 
        return (array_constructor,  
                (a.shape, a.typecode(), a.tolist(), LittleEndian)) 
    else: 
        return (array_constructor,  
                (a.shape, a.typecode(), a.tostring(), LittleEndian))
          
copy_reg.pickle(ArrayType, pickle_array, array_constructor) 


# These are all essentially abbreviations
# These might wind up in a special abbreviations module

def ravel(m):
    """ravel(m) returns a 1d array corresponding to all the elements of it's
    argument.
    """
    return reshape(m, (-1,))

def nonzero(a):
    """nonzero(a) returns the indices of the elements of a which are not zero,
    a must be 1d
    """
    return repeat(arange(len(a)), not_equal(a, 0))

def shape(a):
    """shape(a) returns the shape of a (as a function call which
       also works on nested sequences).
    """
    return asarray(a).shape

def where(condition, x, y):
    """where(condition,x,y) is shaped like condition and has elements of x and
    y where condition is respectively true or false.
    """
    return choose(not_equal(condition, 0), (y, x))

def compress(condition, m, axis=-1):
    """compress(condition, x, axis=-1) = those elements of x corresponding
    to those elements of condition that are "true".  condition must be the
    same size as the given dimension of x."""
    return take(m, nonzero(condition), axis)

def clip(m, m_min, m_max):
    """clip(m, m_min, m_max) = every entry in m that is less than m_min is
    replaced by m_min, and every entry greater than m_max is replaced by
    m_max.
    """
    selector = less(m, m_min)+2*greater(m, m_max)
    return choose(selector, (m, m_min, m_max))

def ones(shape, typecode='l', savespace=0):
    """ones(shape, typecode=Int, savespace=0) returns an array of the given
    dimensions which is initialized to all ones.
    """
    a=zeros(shape, typecode, savespace)
    a[...]=1
    return a

def identity(n,typecode='l'):
    """identity(n) returns the identity matrix of shape n x n.
    """
    return resize(array([1]+n*[0],typecode=typecode), (n,n))

def sum (x, axis=0):
    """Sum the array over the given axis.
    """
    x = array(x, copy=0)
    n = len(x.shape)
    if axis < 0: axis += n
    if n == 0 and axis in [0,-1]: return x[0]
    if axis < 0 or axis >= n:
        raise ValueError, 'Improper axis argument to sum.'
    return add.reduce(x, axis)

def product (x, axis=0):
    """Product of the array elements over the given axis."""
    x = array(x, copy=0)
    n = len(x.shape)
    if axis < 0: axis += n
    if n == 0 and axis in [0,-1]: return x[0]
    if axis < 0 or axis >= n:
        return ValueError, 'Improper axis argument to product.'
    return multiply.reduce(x, axis)

def sometrue (x, axis=0):
    """Perform a logical_or over the given axis."""
    x = array(x, copy=0)
    n = len(x.shape)
    if axis < 0: axis += n
    if n == 0 and axis in [0,-1]: return x[0] != 0
    if axis < 0 or axis >= n:
        return ValueError, 'Improper axis argument to sometrue.'
    return logical_or.reduce(x, axis)

def alltrue (x, axis=0):
    """Perform a logical_and over the given axis."""
    x = array(x, copy=0)
    n = len(x.shape)
    if axis < 0: axis += n
    if n == 0 and axis in [0,-1]: return x[0] != 0
    if axis < 0 or axis >= n:
        return ValueError, 'Improper axis argument to product.'
    return logical_and.reduce(x, axis)

def cumsum (x, axis=0):
    """Sum the array over the given axis."""
    x = array(x, copy=0)
    n = len(x.shape)
    if axis < 0: axis += n
    if n == 0 and axis in [0,-1]: return x[0]
    if axis < 0 or axis >= n:
        return ValueError, 'Improper axis argument to cumsum.'
    return add.accumulate(x, axis)

def cumproduct (x, axis=0):
    """Sum the array over the given axis."""
    x = array(x, copy=0)
    n = len(x.shape)
    if axis < 0: axis += n
    if n == 0 and axis in [0,-1]: return x[0]
    if axis < 0 or axis >= n:
        return ValueError, 'Improper axis argument to cumproduct.'
    return multiply.accumulate(x, axis)

arange = multiarray.arange

def around(m, decimals=0):
    """around(m, decimals=0) \
    Round in the same way as standard python performs rounding. Returns
    always a float.
    """
    m = asarray(m)
    s = sign(m)
    if decimals:
        m = absolute(m*10.**decimals)
    else:
        m = absolute(m)
    rem = m-asarray(m).astype(Int)
    m = where(less(rem,0.5), floor(m), ceil(m))
    # convert back
    if decimals:
        m = m*s/(10.**decimals)
    else:
        m = m*s
    return m

def sign(m):
    """sign(m) gives an array with shape of m with elements defined by sign
    function:  where m is less than 0 return -1, where m greater than 0, a=1,
    elsewhere a=0.
    """
    m = asarray(m)
    return zeros(shape(m))-less(m,0)+greater(m,0)

def allclose (a, b, rtol=1.e-5, atol=1.e-8):
    """ allclose(a,b,rtol=1.e-5,atol=1.e-8)
        Returns true if all components of a and b are equal
        subject to given tolerances.
        The relative error rtol must be positive and << 1.0
        The absolute error atol comes into play for those elements
        of y that are very small or zero; it says how small x must be also.
    """
    x = array(a, copy=0)
    y = array(b, copy=0)
    d = less(absolute(x-y), atol + rtol * absolute(y))
    return alltrue(ravel(d))

def rank (a):
    """Get the rank of sequence a (the number of dimensions, not a matrix rank)
       The rank of a scalar is zero.
    """
    return len(shape(a))

def shape (a):
    "Get the shape of sequence a"
    try:
        return a.shape
    except:
        return array(a).shape

def size (a, axis=None):
    "Get the number of elements in sequence a, or along a certain axis."
    s = shape(a)
    if axis is None:
        if len(s)==0:
            return 1
        else:
            return reduce(lambda x,y:x*y, s)
    else:
        return s[axis]

def average (a, axis=0, weights=None, returned = 0):
    """average(a, axis=0, weights=None)
       Computes average along indicated axis.
       If axis is None, average over the entire array.
       Inputs can be integer or floating types; result is type Float.

       If weights are given, result is:
           sum(a*weights)/(sum(weights))
       weights must have a's shape or be the 1-d with length the size
       of a in the given axis. Integer weights are converted to Float.

       Not supplying weights is equivalent to supply weights that are
       all 1.

       If returned, return a tuple: the result and the sum of the weights
       or count of values. The shape of these two results will be the same.

       raises ZeroDivisionError if appropriate when result is scalar.
       (The version in MA does not -- it returns masked values).
    """
    if axis is None:
        a = array(a).flat
        if weights is None:
            n = add.reduce(a)
            d = len(a) * 1.0
        else:
            w = array(weights, typecode=Float, copy=0).flat
            n = add.reduce(a*w)
            d = add.reduce(w)
    else:
        a = array(a)
        ash = a.shape
        if ash == ():
            a.shape = (1,)
        if weights is None:
            n = add.reduce(a, axis)
            d = ash[axis] * 1.0
            if returned:
                d = ones(shape(n)) * d
        else:
            w = array(weights, copy=0) * 1.0
            wsh = w.shape
            if wsh == ():
                wsh = (1,)
            if wsh == ash:
                n = add.reduce(a*w, axis)
                d = add.reduce(w, axis)
            elif wsh == (ash[axis],):
                ni = ash[axis]
                r = [NewAxis]*ni
                r[axis] = slice(None,None,1)
                w1 = eval("w["+repr(tuple(r))+"]*ones(ash, Float)")
                n = add.reduce(a*w1, axis)
                d = add.reduce(w1, axis)
            else:
                raise ValueError, 'average: weights wrong shape.'

    if not isinstance(d, ArrayType):
        if d == 0.0:
            raise ZeroDivisionError, 'Numeric.average, zero denominator'
    if returned:
        return n/d, d
    else:
        return n/d
