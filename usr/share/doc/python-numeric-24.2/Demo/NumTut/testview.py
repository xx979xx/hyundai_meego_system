import view

from Numeric import *

x = arange(-3, 6, .04)
y = arange(-12, 12, .08)
y = sin(y)*exp(-y*y/18.0)
z = x * y[:,NewAxis]
view.view(z)
raw_input()
