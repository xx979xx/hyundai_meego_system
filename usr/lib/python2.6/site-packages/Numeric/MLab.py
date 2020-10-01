"""Matlab(tm) compatibility functions.

This will hopefully become a complete set of the basic functions available in
matlab.  The syntax is kept as close to the matlab syntax as possible.  One
fundamental change is that the first index in matlab varies the fastest (as in
FORTRAN).  That means that it will usually perform reductions over columns,
whereas with this object the most natural reductions are over rows.  It's perfectly
possible to make this work the way it does in matlab if that's desired.
"""
#import Matrix   --- cannot use Matrix module here because Linear Algebra imports it
#                    and Matrix depends on Linear Algebra.

from Numeric import *

# Elementary Matrices

# zeros is from matrixmodule in C
# ones is from Numeric.py

import RandomArray
def rand(*args):
    """rand(d1,...,dn) returns a matrix of the given dimensions
    which is initialized to random numbers from a uniform distribution
    in the range [0,1).
    """
    return RandomArray.random(args)

def randn(*args):
    """u = randn(d0,d1,...,dn) returns zero-mean, unit-variance Gaussian
    random numbers in an array of size (d0,d1,...,dn)."""
    x1 = RandomArray.random(args)
    x2 = RandomArray.random(args)
    return sqrt(-2*log(x1))*cos(2*pi*x2)


def eye(N, M=None, k=0, typecode=None):
    """eye(N, M=N, k=0, typecode=None) returns a N-by-M matrix where the
    k-th diagonal is all ones, and everything else is zeros.
    """
    if M is None: M = N
    if type(M) == type('d'):
        typecode = M
        M = N
    m = equal(subtract.outer(arange(N), arange(M)),-k)
    return asarray(m,typecode=typecode)


def tri(N, M=None, k=0, typecode=None):
    """tri(N, M=N, k=0, typecode=None) returns a N-by-M matrix where all
    the diagonals starting from lower left corner up to the k-th are all ones.
    """
    if M is None: M = N
    if type(M) == type('d'):
        typecode = M
        M = N
    m = greater_equal(subtract.outer(arange(N), arange(M)),-k)
    return m.astype(typecode)

# Matrix manipulation

def diag(v, k=0):
    """diag(v,k=0) returns the k-th diagonal if v is a matrix or
    returns a matrix with v as the k-th diagonal if v is a vector.
    """
    v = asarray(v)
    s = v.shape
    if len(s)==1:
        n = s[0]+abs(k)
        if k > 0:
            v = concatenate((zeros(k, v.typecode()),v))
        elif k < 0:
            v = concatenate((v,zeros(-k, v.typecode())))
        return eye(n, k=k)*v
    elif len(s)==2:
        v = add.reduce(eye(s[0], s[1], k=k)*v)
        if k > 0: return v[k:]
        elif k < 0: return v[:k]
        else: return v
    else:
            raise ValueError, "Input must be 1- or 2-D."


def fliplr(m):
    """fliplr(m) returns a 2-D matrix m with the rows preserved and
    columns flipped in the left/right direction.  Only works with 2-D
    arrays.
    """
    m = asarray(m)
    if len(m.shape) != 2:
        raise ValueError, "Input must be 2-D."
    return m[:, ::-1]

def flipud(m):
    """flipud(m) returns a 2-D matrix with the columns preserved and
    rows flipped in the up/down direction.  Only works with 2-D arrays.
    """
    m = asarray(m)
    if len(m.shape) != 2:
        raise ValueError, "Input must be 2-D."
    return m[::-1]

# reshape(x, m, n) is not used, instead use reshape(x, (m, n))

def rot90(m, k=1):
    """rot90(m,k=1) returns the matrix found by rotating m by k*90 degrees
    in the counterclockwise direction.
    """
    m = asarray(m)
    if len(m.shape) != 2:
        raise ValueError, "Input must be 2-D."
    k = k % 4
    if k == 0: return m
    elif k == 1: return transpose(fliplr(m))
    elif k == 2: return fliplr(flipud(m))
    elif k == 3: return fliplr(transpose(m))

def tril(m, k=0):
    """tril(m,k=0) returns the elements on and below the k-th diagonal of
    m.  k=0 is the main diagonal, k > 0 is above and k < 0 is below the main
    diagonal.
    """
    svsp = m.spacesaver()
    m = asarray(m,savespace=1)
    out = tri(m.shape[0], m.shape[1], k=k, typecode=m.typecode())*m
    out.savespace(svsp)
    return out

def triu(m, k=0):
    """triu(m,k=0) returns the elements on and above the k-th diagonal of
    m.  k=0 is the main diagonal, k > 0 is above and k < 0 is below the main
    diagonal.
    """
    svsp = m.spacesaver()
    m = asarray(m,savespace=1)
    out = (1-tri(m.shape[0], m.shape[1], k-1, m.typecode()))*m
    out.savespace(svsp)
    return out

# Data analysis

# Basic operations
def max(m,axis=0):
    """max(m,axis=0) returns the maximum of m along dimension axis.
    """
    m = asarray(m)
    return maximum.reduce(m,axis)

def min(m,axis=0):
    """min(m,axis=0) returns the minimum of m along dimension axis.
    """
    m = asarray(m)
    return minimum.reduce(m,axis)

# Actually from Basis, but it fits in so naturally here...

def ptp(m,axis=0):
    """ptp(m,axis=0) returns the maximum - minimum along the the given dimension
    """
    m = asarray(m)
    return max(m,axis)-min(m,axis)

def mean(m,axis=0):
    """mean(m,axis=0) returns the mean of m along the given dimension.
       If m is of integer type, returns a floating point answer.
    """
    m = asarray(m)
    return add.reduce(m,axis)/float(m.shape[axis])

# sort is done in C but is done row-wise rather than column-wise
def msort(m):
    """msort(m) returns a sort along the first dimension of m as in MATLAB.
    """
    m = asarray(m)
    return transpose(sort(transpose(m)))

def median(m):
    """median(m) returns a median of m along the first dimension of m.
    """
    sorted = msort(m)
    if sorted.shape[0] % 2 == 1:
        return sorted[int(sorted.shape[0]/2)]
    else:
        sorted = msort(m)
        index=sorted.shape[0]/2
        return (sorted[index-1]+sorted[index])/2.0

def std(m,axis=0):
    """std(m,axis=0) returns the standard deviation along the given
    dimension of m.  The result is unbiased with division by N-1.
    If m is of integer type returns a floating point answer.
    """
    x = asarray(m)
    n = float(x.shape[axis])
    mx = asarray(mean(x,axis))
    if axis < 0:
        axis = len(x.shape) + axis
    mx.shape = mx.shape[:axis] + (1,) + mx.shape[axis:]
    x = x - mx
    return sqrt(add.reduce(x*x,axis)/(n-1.0))

def cumsum(m,axis=0):
    """cumsum(m,axis=0) returns the cumulative sum of the elements along the
    given dimension of m.
    """
    m = asarray(m)
    return add.accumulate(m,axis)

def prod(m,axis=0):
    """prod(m,axis=0) returns the product of the elements along the given
    dimension of m.
    """
    m = asarray(m)
    return multiply.reduce(m,axis)

def cumprod(m,axis=0):
    """cumprod(m) returns the cumulative product of the elements along the
    given dimension of m.
    """
    m = asarray(m)
    return multiply.accumulate(m,axis)

def trapz(y, x=None, axis=-1):
    """trapz(y,x=None,axis=-1) integrates y along the given dimension of
    the data array using the trapezoidal rule.
    """
    y = asarray(y)
    if x is None:
        d = 1.0
    else:
        d = diff(x,axis=axis)
    y = asarray(y)
    nd = len(y.shape)
    slice1 = [slice(None)]*nd
    slice2 = [slice(None)]*nd
    slice1[axis] = slice(1,None)
    slice2[axis] = slice(None,-1)
    return add.reduce(d * (y[slice1]+y[slice2])/2.0,axis)

def diff(x, n=1,axis=-1):
    """diff(x,n=1,axis=-1) calculates the n'th difference along the axis specified.
       Note that the result is one shorter in the axis'th dimension.
       Returns x if n == 0. Raises ValueError if n < 0.
    """
    x = asarray(x)
    nd = len(x.shape)
    if nd == 0:
        nd = 1
    if n < 0:
        raise ValueError, 'MLab.diff, order argument negative.'
    elif n == 0:
        return x
    elif n == 1:
        slice1 = [slice(None)]*nd
        slice2 = [slice(None)]*nd
        slice1[axis] = slice(1,None)
        slice2[axis] = slice(None,-1)
        return x[slice1]-x[slice2]
    else:
        return diff(diff(x,1,axis), n-1)

def cov(m,y=None, rowvar=0, bias=0):
    """Estimate the covariance matrix.

    If m is a vector, return the variance.  For matrices where each row
    is an observation, and each column a variable, return the covariance
    matrix.  Note that in this case diag(cov(m)) is a vector of
    variances for each column.

    cov(m) is the same as cov(m, m)

    Normalization is by (N-1) where N is the number of observations
    (unbiased estimate).  If bias is 1 then normalization is by N.

    If rowvar is zero, then each row is a variable with
    observations in the columns.
    """
    if y is None:
        y = m
    else:
        y = y
    if rowvar:
        m = transpose(m)
        y = transpose(y)
    if (m.shape[0] == 1):
        m = transpose(m)
    if (y.shape[0] == 1):
        y = transpose(y)
    N = m.shape[0]
    if (y.shape[0] != N):
        raise ValueError, "x and y must have the same number of observations."
    m = m - mean(m,axis=0)
    y = y - mean(y,axis=0)
    if bias:
        fact = N*1.0
    else:
        fact = N-1.0
    #
    val = squeeze(dot(transpose(m),conjugate(y)) / fact)
    return val

def corrcoef(x, y=None):
    """The correlation coefficients
    """
    c = cov(x, y)
    d = diag(c)
    return c/sqrt(multiply.outer(d,d))


# Added functions supplied by Travis Oliphant
import LinearAlgebra
def squeeze(a):
    "squeeze(a) returns a with any ones from the shape of a removed"
    a = asarray(a)
    b = asarray(a.shape)
    return reshape (a, tuple (compress (not_equal (b, 1), b)))


def kaiser(M,beta):
    """kaiser(M, beta) returns a Kaiser window of length M with shape parameter
    beta. It depends on the cephes module for the modified bessel function i0.
    """
    import cephes
    n = arange(0,M)
    alpha = (M-1)/2.0
    return cephes.i0(beta * sqrt(1-((n-alpha)/alpha)**2.0))/cephes.i0(beta)

def blackman(M):
    """blackman(M) returns the M-point Blackman window.
    """
    n = arange(0,M)
    return 0.42-0.5*cos(2.0*pi*n/(M-1)) + 0.08*cos(4.0*pi*n/(M-1))


def bartlett(M):
    """bartlett(M) returns the M-point Bartlett window.
    """
    n = arange(0,M)
    return where(less_equal(n,(M-1)/2.0),2.0*n/(M-1),2.0-2.0*n/(M-1))

def hanning(M):
    """hanning(M) returns the M-point Hanning window.
    """
    n = arange(0,M)
    return 0.5-0.5*cos(2.0*pi*n/(M-1))

def hamming(M):
    """hamming(M) returns the M-point Hamming window.
    """
    n = arange(0,M)
    return 0.54-0.46*cos(2.0*pi*n/(M-1))

def sinc(x):
    """sinc(x) returns sin(pi*x)/(pi*x) at all points of array x.
    """
    y = pi* where(x == 0, 1.0e-20, x)
    return sin(y)/y

def eig(v):
    """[x,v] = eig(m) returns the eigenvalues of m in x and the corresponding
    eigenvectors in the rows of v.
    """
    return LinearAlgebra.eigenvectors(v)

def svd(v):
    """[u,x,v] = svd(m) return the singular value decomposition of m.
    """
    return LinearAlgebra.singular_value_decomposition(v)


def angle(z):
    """phi = angle(z) return the angle of complex argument z."""
    z = asarray(z)
    if z.typecode() in ['D','F']:
       zimag = z.imag
       zreal = z.real
    else:
       zimag = 0
       zreal = z
    return arctan2(zimag,zreal)


def roots(p):
    """ return the roots of the polynomial coefficients in p.

    The values in the rank-1 array p are coefficients of a polynomial.
    If the length of p is n+1 then the polynomial is
    p[0] * x**n + p[1] * x**(n-1) + ... + p[n-1]*x + p[n]
    """
    if type(p) in [types.IntType, types.FloatType, types.ComplexType]:
        p = asarray([p])
    else:
        p = asarray(p)

    n = len(p)
    if len(p.shape) != 1:
        raise ValueError, "Input must be a rank-1 array."

    # Strip zeros at front of array
    ind = 0
    while (p[ind] == 0):
        ind = ind + 1
    p = asarray(p[ind:])

    N = len(p)
    root = zeros((N-1,),'D')
    # Strip zeros at end of array which correspond to zero-valued roots
    ind = len(p)
    while (p[ind-1]==0):
        ind = ind - 1
    p = asarray(p[:ind])

    N = len(p)
    if N > 1:
        A = diag(ones((N-2,),p.typecode()),-1)
        A[0,:] = -p[1:] / p[0]
        root[:N-1] = eig(A)[0]
    if ((root.typecode() == 'F' and allclose(root.imag, 0, rtol=1e-7)) or
        (root.typecode() == 'D' and allclose(root.imag, 0, rtol=1e-14))):
        root = root.real
    return root
