"""
Displaying image files in a separate thread on Tk+thread, w/ xv in
forked & execv'ed processes otherwise.

view(array):  will spawn a displaying program for arrays which are
              either NxM or NxMx3.  does the 'min/max' and conversion
              to char.

array2ppm(array): given an NxM or NxMx3 array, returns a ppm string
                  which is a valid thing to put in a PPM file.  (or
                  PGM file if NxM file).

TODO:
  - automatic scaling for small images
  - accept rank-1 arrays

NOTE: This is a modified version which removes all threading and PIL
support. It should work on any system with Tkinter alone.

"""

DEFAULT_HEIGHT = 255
MINSIZE = 150

import os
import Tkinter
from Numeric import *
import tempfile, time


def save_ppm(ppm, fname=None):
    if fname == None:
        fname = tempfile.mktemp('.ppm')
    f = open(fname, 'wb')
    f.write(ppm)
    f.close()
    return fname


def array2ppm(image):
    # scaling
    if len(image.shape) == 2:
        # B&W:
        image = transpose(image)
        return "P5\n#PPM version of array\n%d %d\n255\n%s" % \
               (image.shape[1], image.shape[0], ravel(image).tostring())
    else:
        # color
        image = transpose(image, (1, 0, 2))
        return "P6\n%d %d\n255\n%s" % \
               (image.shape[1], image.shape[0], ravel(image).tostring())

def preprocess(image, (scalex,scaley)):
    assert len(image.shape) in (1, 2) or \
           len(image.shape) == 3 and image.shape[2] == 3, \
           "image not correct format"
    themin = float(minimum.reduce(ravel(image)))
    themax = float(maximum.reduce(ravel(image)))
    if len(image.shape) == 1:
        len_x = image.shape[0]
        ys = ((image - themin)/(themax-themin)*(DEFAULT_HEIGHT-1)).astype('b')
        image = (zeros((DEFAULT_HEIGHT, len_x))+255).astype('b')
        for x in range(len_x):
            image[DEFAULT_HEIGHT-1-ys[x],len_x-x-1] = 0
        image = transpose(image)
    elif image.typecode() != 'b':
        image = (image - themin) / (themax-themin) * 255
        image = image.astype('b')

    len_x, len_y = image.shape[:2]
    if scalex is None:
        if len_x < MINSIZE:
            scalex = int(float(MINSIZE) / len_x) + 1
        else:
            scalex = 1
    if scaley is None:
        if len_y < MINSIZE:
            scaley = int(float(MINSIZE) / len_y) + 1
        else:
            scaley = 1
    return image, (scalex, scaley)


class PPMImage(Tkinter.Label):
    def __init__(self, master, ppm, (scalex, scaley)):
        self.image = Tkinter.PhotoImage(file=save_ppm(ppm))
        w, h = self.image.width(), self.image.height()
        self.image = self.image.zoom(scalex, scaley)
        self.image.configure(width=w*scalex, height=h*scaley)
        Tkinter.Label.__init__(self, master, image=self.image,
                               bg="black", bd=0)

        self.pack()

# Start the Tk process from which all subsequent windows will be opened.
def tk_root():
    if Tkinter._default_root is None:
        root = Tkinter.Tk()
        Tkinter._default_root.withdraw()
    else:
        root = Tkinter._default_root
    return root

_root = tk_root()

def view(image, scale=None):
    """Display an image, optionally rescaling it.

    scale can be either an integer or a tuple of 2 integers (for separate x/y
    rescaling.  """

    if scale is None:
        scale=(None,None)
    else:
        try:
            len(scale)
        except TypeError:
            scale = (scale,scale)

    image, scales = preprocess(image, scale)
    tl = Tkinter.Toplevel()
    u = PPMImage(tl, array2ppm(image), scales)
    u.pack(fill='both', expand=1)
    u.tkraise()
