###cython: boundscheck=False, wraparound=False, nonecheck=False, optimize.use_switch=True

__version__ = "1.0.1"

# COMPILATION
# python setup_hsv.py build_ext --inplace

# HOW TO
"""
import HSV

# This will import the cython version 
from HSV import rgb2hsv, hsv2rgb

# This will import the C version 
from HSV import rgb_to_hsv_c, hsv_to_rgb_c, struct_rgb_to_hsv_c, struct_hsv_to_rgb_c

if __name__ == '__main__':

  r, g, b = 25, 60, 128
  
  # BELOW TESTING RGB TO HSV AND HSV TO RGB (METHOD WITH POINTER)
  # hls values are normalized if you wish to convert it to a colorys format 
  # multiply h * 360, s * 100 and l * 100
  h, s, l = rgb2hsv(r / 255.0, g / 255.0, b / 255.0)
  # return rgb values normalized!
  r, g, b = hsv2rgb(h, s, l) 
  print("RGB (25, 60, 128) ", r * 255, g * 255, b * 255)
  
  # BELOW TESTING RGB TO HSV AND HSV TO RGB (METHOD C STRUCT)
  # THIS METHOD IS SLIGHTLY FASTER AND WE DO NOT HAVE TO WORRY ABOUT
  # FREEING THE POINTER MEMORY
  r, g, b = 25, 60, 128
  h, s, l = struct_rgb_to_hsv_c(r/255.0, g/255.0, b/255.0)
  r, g, b = struct_hsv_to_rgb_c(h, s, l)
  print("RGB (25, 60, 128) ", r * 255, g * 255, b * 255)

"""

try:
    import pygame
except ImportError as e:
    raise ImportError("\n<Pygame> library is missing on your system."
          "\nTry: \n   C:\\pip install pygame on a window command prompt.")

try:
    cimport cython
    from cython.parallel cimport prange
except ImportError:
    raise ImportError("\n<cython> library is missing on your system."
          "\nTry: \n   C:\\pip install cython on a window command prompt.")

try:
    import numpy
except ImportError:
    raise ImportError("\n<Numpy> library is missing on your system."
          "\nTry: \n   C:\\pip install numpy on a window command prompt.")

from numpy import empty, uint8
from libc.stdlib cimport malloc, free

DEF ONE_255 = 1.0/255.0
DEF ONE_360 = 1.0/360.0

# EXTERNAL C CODE (file 'hsv_c.c')
cdef extern from 'hsv_c.c' nogil:

    struct hsv:
        double h
        double s
        double v

    struct rgb:
        double r
        double g
        double b

    struct rgba:
        double r
        double g
        double b
        double a

    # METHOD 1
    double * rgb_to_hsv(double red, double green, double blue)nogil
    double * hsv_to_rgb(double h, double s, double v)nogil
    # METHOD 2
    hsv struct_rgb_to_hsv(double red, double green, double blue)nogil
    rgb struct_hsv_to_rgb(double h, double s, double v)nogil

    double fmax_rgb_value(double red, double green, double blue)nogil
    double fmin_rgb_value(double red, double green, double blue)nogil

ctypedef hsv HSV
ctypedef rgb RGB

# ------------------------------------ INTERFACE ----------------------------------------------

@cython.boundscheck(False)
@cython.wraparound(False)
@cython.nonecheck(False)
cpdef tuple hsv2rgb(double h, double s, double v):
    """
    CONVERT HSV MODEL TO RGB 
    This method is using cython code (method hsv2rgb_c) of HSV to RGB (see algorithm below)
    
    :param h: python float; value in range [0...1.0]   
    :param s: python float; value in range [0...1.0]   
    :param v: python float; value in range [0...1.0]   
    :return: tuple of RGB values (Normalized, range [0...1.0] 
    """
    cdef:
        double *rgb = hsv2rgb_c(h, s, v)
    # free the pointer (do not remove)
    free(rgb)
    return rgb[0], rgb[1], rgb[2]

@cython.boundscheck(False)
@cython.wraparound(False)
@cython.nonecheck(False)
cpdef tuple rgb2hsv(double r, double g, double b):
    """
    CONVERT RGB TO HSV MODEL 
    This method is using cython code (method rgb2hsv_c) of RGB to HSV (see algorithm below)
    
    :param r: python float; value in range [0...1.0]   
    :param g: python float; value in range [0...1.0]   
    :param b: python float; value in range [0...1.0]   
    :return: tuple of HSV values (Normalized, range [0...1.0] 
    """
    cdef:
        double *hsv = rgb2hsv_c(r, g, b)
    # free the pointer (do not remove)
    free(hsv)
    return hsv[0], hsv[1], hsv[2]


@cython.boundscheck(False)
@cython.wraparound(False)
@cython.nonecheck(False)
cpdef tuple rgb_to_hsv_c(double r, double g, double b):
    """
    CONVERT RGB MODEL TO HSV
    This method is using a C function rgb_to_hsv (source code in the file hsv_c.c)  
     
    :param r: python float; value in range [0...1.0]   
    :param g: python float; value in range [0...1.0]   
    :param b: python float; value in range [0...1.0]   
    :return: tuple of HSV values (Normalized, range [0...1.0] 
 
    """
    cdef:
        double *hsv = rgb_to_hsv(r, g, b)
    # free the pointer (do not remove)
    free(hsv)
    return hsv[0], hsv[1], hsv[2]

@cython.boundscheck(False)
@cython.wraparound(False)
@cython.nonecheck(False)
cpdef tuple hsv_to_rgb_c(double h, double s, double v):
    """
    CONVERT RGB MODEL TO HSV
    This method is using a C function hsv_to_rgb (source code in the file hsv_c.c)  
     
    :param h: python float; value in range [0...1.0]   
    :param s: python float; value in range [0...1.0]   
    :param v: python float; value in range [0...1.0]   
    :return: tuple of HSV values (Normalized, range [0...1.0] 
 
    """
    cdef:
        double *rgb = hsv_to_rgb(h, s, v)
     # free the pointer (do not remove)
    free(rgb)
    return rgb[0], rgb[1], rgb[2]


@cython.boundscheck(False)
@cython.wraparound(False)
@cython.nonecheck(False)
cpdef tuple struct_rgb_to_hsv_c(double r, double g, double b):
    """
    CONVERT RGB TO HSV MODEL 
    This method is using a C function struct_rgb_to_hsv (source code in the file hsv_c.c)  
    
    :param r: python float; value in range [0...1.0]  
    :param g: python float; value in range [0...1.0]  
    :param b: python float; value in range [0...1.0]  
    :return: tuple of HSV values (Normalized, range [0...1.0] 
    """
    cdef HSV hsv_ = struct_rgb_to_hsv(r, g, b)
    return hsv_.h, hsv_.s, hsv_.v


@cython.boundscheck(False)
@cython.wraparound(False)
@cython.nonecheck(False)
cpdef tuple struct_hsv_to_rgb_c(double h, double s, double v):
    """
    CONVERT HSV MODEL TO RGB 
    This method is using a C function struct_hsv_to_rgb (source code in the file hsv_c.c  
    
    :param h: python float; value in range [0...1.0]  
    :param s: python float; value in range [0...1.0]  
    :param l: python float; value in range [0...1.0]  
    :return: tuple of RGB values (Normalized, range [0...1.0] 
    """
    cdef RGB rgb_ = struct_hsv_to_rgb(h, s, v)
    return rgb_.r, rgb_.g, rgb_.b




#------------------------------------- CYTHON CODE --------------------------------------
@cython.boundscheck(False)
@cython.wraparound(False)
@cython.nonecheck(False)
@cython.cdivision(True)
cdef double * rgb2hsv_c(double r, double g, double b)nogil:
    """
    Convert RGB color model into HSV
    * Don't forget to free the memory allocated for hsv values
    
    :param r: python float; red in range[0 ... 1.0]
    :param g: python float; green in range [0 ... 1.0]
    :param b: python float; blue in range [0 ... 1.0]
    :return: Return HSV values 
    
    to convert in % do the following :
    h = h * 360.0
    s = s * 100.0
    v = v * 100.0
    
    """
    cdef:
        double mx, mn
        double h, df, s, v, df_
        double *hsv = <double *> malloc(3 * sizeof(double))

    mx = fmax_rgb_value(r, g, b)
    mn = fmin_rgb_value(r, g, b)

    df = mx - mn
    df_ = 1.0/df
    if mx == mn:
        h = 0.0

    elif mx == r:
        h = (60 * ((g-b) * df_) + 360) % 360
    elif mx == g:
        h = (60 * ((b-r) * df_) + 120) % 360
    elif mx == b:
        h = (60 * ((r-g) * df_) + 240) % 360
    if mx == 0:
        s = 0.0
    else:
        s = df/mx
    v = mx
    hsv[0] = h * ONE_360
    hsv[1] = s
    hsv[2] = v
    return hsv


@cython.boundscheck(False)
@cython.wraparound(False)
@cython.nonecheck(False)
cdef double * hsv2rgb_c(double h, double s, double v)nogil:
    """
    Convert hsv color model to rgb
    * Don't forget to free the memory allocated for hsv values

    :param h: python float; hue in range [0.0 ... 1.0]
    :param s: python float; saturation   [0.0 ... 1.0] 
    :param v: python float; value        [0.0 ... 1.0]
    :return: Return RGB floating values (normalized [0.0 ... 1.0]).
             multiply (red * 255.0, green * 255.0, blue * 255.0) to get the right pixel color.
    """
    cdef:
        int i = 0
        double f, p, q, t
        double *rgb = <double *> malloc(3 * sizeof(double))

    if s == 0.0:
        rgb[0] = v
        rgb[1] = v
        rgb[2] = v
        return rgb

    i = <int>(h * 6.0)
    f = (h * 6.0) - i
    p = v*(1.0 - s)
    q = v*(1.0 - s * f)
    t = v*(1.0 - s * (1.0 - f))
    i = i % 6

    if i == 0:
        rgb[0] = v
        rgb[1] = t
        rgb[2] = p
        return rgb
    elif i == 1:
        rgb[0] = q
        rgb[1] = v
        rgb[2] = p
        return rgb
    elif i == 2:
        rgb[0] = p
        rgb[1] = v
        rgb[2] = t
        return rgb
    elif i == 3:
        rgb[0] = p
        rgb[1] = q
        rgb[2] = v
        return rgb
    elif i == 4:
        rgb[0] = t
        rgb[1] = p
        rgb[2] = v
        return rgb
    elif i == 5:
        rgb[0] = v
        rgb[1] = p
        rgb[2] = q
        return rgb
