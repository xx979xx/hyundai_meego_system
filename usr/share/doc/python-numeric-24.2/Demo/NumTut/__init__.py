#! /usr/bin/env python
"""
Support package for the numeric tutorial.

TODO:

 - scan pictures, give good names
 - define load & save for arrays and images

"""
from view import *
import pickle, os
_dir = __path__[0]
greece = pickle.load(open(os.path.join(_dir, 'greece.pik'), 'rb')) / 256.0
# use NTSC conversion 
greeceBW = .299 * greece[:,:,0] + .587*greece[:,:,1] + .114 * greece[:,:,2]
red = array(greece, copy=1)
red[:,:,1:] = 0
green = array(greece, copy=1)
green[:,:,::2] = 0
blue = array(greece, copy=1)
blue[:,:,:2] = 0
xgrade = arange(0, 1, 1.0/greece.shape[0])[:,NewAxis,NewAxis]
ygrade = arange(0, 1, 1.0/greece.shape[1])[NewAxis,:,NewAxis]

sgreece = greece[::2,::2]
sgreeceBW = greeceBW[::2,::2]

_test = """
view(greece)
view(1.0-greece)
view(greeceBW)
view(greece*xgrade)
view(greece*ygrade)
negative = 1.0 - greece
view(greece*xgrade + negative*ygrade)
view(red)
view(green)
view(blue)
sine = sin(xgrade*6*pi)
view(green*sine + red*(1.0-sine))
view(green + red[::-1])
view(transpose(greece, (1,0,2)))

"""

def test():
    lines = filter(None, string.split(_test, '\n'))
    for line in lines:
        print '>>> '+line
        exec line

"""
# show green pixels if red > .5, blue pixels otherwise:

RED, GREEN, BLUE = 0, 1, 2
newpic = zeros(greece.shape, greece.typecode())
mask = greater(greece[:,:,RED], .5)
newpic[:,:,GREEN] = where(mask, 0, greece[:,:,GREEN])
newpic[:,:,BLUE] = where(mask, greece[:,:,BLUE], 0)
view(newpic)
view(greater(redvalues, .5))
"""

"""
#brighten an image
view(log(greece + .01))
view(power(greece, factor)) # factor < 1 -> brighter
"""

"""
view(repeat(greece, 2*ones(greece.shape[0]))) # double in X
view(repeat(greece, 2*ones(greece.shape[1]), 1)) # double in Y
"""

"""
# make a collage

view(concatenate((concatenate((greece,red), 0),
     concatenate((green,blue), 0)),
     1))
"""

"""
view(identity(100))
"""

def shift(x, left=0, up=0):
    """shift an array to the left and up by specified #'s of columns and
    rows (with circular copy -- things show up on the other side)."""
    y = array(x, copy=1)
    if left < 0: left = x.shape[0] + left
    if up < 0: up = x.shape[1] + up
    w = x.shape[0]-left
    h = x.shape[1]-up
    y[:w] = x[left:left+w]
    y[w:] = x[:left]
    z = array(y, copy=1)
    z[:, :h] = y[:, up:up+h]
    z[:, h:] = y[:, :up]
    return z

"""
view(shift(greece, left=40, up=20))

"""
