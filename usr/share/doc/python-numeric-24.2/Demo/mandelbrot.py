#!/usr/bin/env python
#
# Mandelbrot ASCII-art using Numeric Python 1.0beta1
#
# Rob Hooft, 1996. Distribute freely.

from Numeric import *

def draw(LowX, HighX, LowY, HighY, stepx=80, stepy=24, maxiter=30):
	xx=arange(LowX,HighX,(HighX-LowX)/stepx)
	yy=arange(HighY,LowY,(LowY-HighY)/stepy)*1j
	c=ravel(xx+yy[:,NewAxis])
	z=zeros(c.shape,Complex)
	output=resize(array(['_'],'c'),c.shape)
	for iter in range(maxiter):
		z=z*z+c
		finished=greater(abs(z),2.0)
		c=where(finished,0+0j,c)
		z=where(finished,0+0j,z)
		output=where(finished,chr(66+iter),output)
	return output.tostring()


if __name__ == "__main__":
	print draw(-2.1, 0.7, -1.2, 1.2)


