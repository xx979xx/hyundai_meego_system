import string
import types

import Numeric
import LinearAlgebra
from UserArray import UserArray, asarray
from Numeric import dot, identity, multiply
from MLab import squeeze

# make translation table
_table = [None]*256
for k in range(256):
    _table[k] = chr(k)
_table = ''.join(_table)

_numchars = string.digits + ".-+jeEL"
_todelete = []
for k in _table:
    if k not in _numchars:
        _todelete.append(k)
_todelete = ''.join(_todelete)

def _eval(astr):
    return eval(astr.translate(_table,_todelete))

def _convert_from_string(data):
    data.find
    rows = data.split(';')
    newdata = []
    count = 0
    for row in rows:
        trow = row.split(',')
        newrow = []
        for col in trow:
            temp = col.split()
            newrow.extend(map(_eval,temp))
        if count == 0:
            Ncols = len(newrow)
        elif len(newrow) != Ncols:
            raise ValueError, "Rows not the same size."
        count += 1
        newdata.append(newrow)
    return newdata


_lkup = {'0':'000',
         '1':'001',
         '2':'010',
         '3':'011',
         '4':'100',
         '5':'101',
         '6':'110',
         '7':'111'}

def _binary(num):
    ostr = oct(num)
    bin = ''
    for ch in ostr[1:]:
        bin += _lkup[ch]
    ind = 0
    while bin[ind] == '0':
        ind += 1
    return bin[ind:]


class Matrix(UserArray):
    def __init__(self, data, typecode=None, copy=1, savespace=0):
        if type(data) is types.StringType:
            data = _convert_from_string(data)
        UserArray.__init__(self,data,typecode, copy, savespace)
        if len(self.array.shape) == 1:
            self.array.shape = (1,self.array.shape[0])
        self.shape = self.array.shape

    def __getitem__(self, index):
        out = self._rc(self.array[index])
        try:
            n = len(index)
            if n > 1 and isinstance(index[0], types.SliceType) \
               and isinstance(index[1], types.IntType):
                sh = out.array.shape
                out.array.shape = (sh[1],sh[0])
                out.shape = out.array.shape
        except TypeError:  # Index not a sequence
            pass
        return out

    def __mul__(self, other):
        aother = asarray(other)
        if len(aother.shape) == 0:
            return self._rc(self.array*aother)
        else:
            return self._rc(dot(self.array, aother))

    def __rmul__(self, other):
        aother = asarray(other)
        if len(aother.shape) == 0:
            return self._rc(aother*self.array)
        else:
            return self._rc(dot(aother, self.array))

    def __imul__(self,other):
        aother = asarray(other)
        self.array = dot(self.array, aother)
        return self

    def __pow__(self, other):
        shape = self.array.shape
        if len(shape)!=2 or shape[0]!=shape[1]:
            raise TypeError, "matrix is not square"
        if type(other) in (type(1), type(1L)):
            if other==0:
                return Matrix(identity(shape[0]))
            if other<0:
                result=Matrix(LinearAlgebra.inverse(self.array))
                x=Matrix(result)
                other=-other
            else:
                result=self
                x=result
            if other <= 3:
                while(other>1):
                    result=result*x
                    other=other-1
                return result
            # binary decomposition to reduce the number of Matrix
            #  Multiplies for other > 3.
            beta = _binary(other)
            t = len(beta)
            Z,q = x.copy(),0
            while beta[t-q-1] == '0':
                Z *= Z
                q += 1
            result = Z.copy()
            for k in range(q+1,t):
                Z *= Z
                if beta[t-k-1] == '1':
                    result *= Z
            return result
        else:
            raise TypeError, "exponent must be an integer"

    def __rpow__(self, other):
        raise TypeError, "x**y not implemented for matrices y"

    def __invert__(self):
        return Matrix(Numeric.conjugate(self.array))

    def __setattr__(self,attr,value):
        if attr=='shape':
            if len(value) == 0:
                value = (1,1)
            if len(value) == 1:
                value = (1,) + value
            if len(value) != 2:
                raise ValueError, "Can only reshape a Matrix as a 2-d array."
            self.array.shape=value
        self.__dict__[attr]=value

    def __getattr__(self, attr):
        if attr == 'A':
            return squeeze(self.array)
        elif attr == 'T':
            return Matrix(Numeric.transpose(self.array))
        elif attr == 'H':
            if len(self.array.shape) == 1:
                self.array.shape = (1,self.array.shape[0])
            return Matrix(Numeric.conjugate(Numeric.transpose(self.array)))
        elif attr == 'I':
            return Matrix(LinearAlgebra.inverse(self.array))
        elif attr == 'real':
            return Matrix(self.array.real)
        elif attr == 'imag':
            return Matrix(self.array.imag)
        elif attr == 'flat':
            return Matrix(self.array.flat)
        else:
            raise AttributeError, attr + " not found."

    def __setitem__(self, index, value):
        value = asarray(value, self._typecode)
        self.array[index] = squeeze(value)
    def __setslice__(self, i, j, value): self.array[i:j] = asarray(squeeze(value),self._typecode)

    def __float__(self):
        return float(squeeze(self.array))

    def m(self,b):
        return Matrix(self.array * asarray(b))

    def asarray(self,t=None):
        if t is None:
            return self.array
        else:
            return asarray(self.array,t)

if __name__ == '__main__':
    from Numeric import *
    m = Matrix( [[1,2,3],[11,12,13],[21,22,23]])
    print m*m
    print m.array*m.array
    print transpose(m)
    print m**-1
    m = Matrix([[1,1],[1,0]])
    print "Fibonacci numbers:",
    for i in range(10):
        mm=m**i
        print mm[0][0],
    print
