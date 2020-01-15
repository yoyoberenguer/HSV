###cython: boundscheck=False, wraparound=False, nonecheck=False, optimize.use_switch=True

"""
MIT License

Copyright (c) 2019 Yoann Berenguer

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"""

# CYTHON IS REQUIRED
try:
    cimport cython
    from cython.parallel cimport prange
except ImportError:
    print("\n<cython> library is missing on your system."
          "\nTry: \n   C:\\pip install cython on a window command prompt.")
    raise SystemExit

from libc.stdlib cimport srand, rand, RAND_MAX, qsort, malloc, free, abs

DEF ONE_255 = 1.0/255.0
DEF ONE_360 = 1.0/360.0


cdef extern from 'hsv_c.c' nogil:
    double * rgb_to_hsv(double red, double green, double blue)
    double * hsv_to_rgb(double h, double s, double v)
    double fmax_rgb_value(double red, double green, double blue)
    double fmin_rgb_value(double red, double green, double blue)


# ------------------- INTERFACE ----------------------------------------------
#***********************************************
#**********  METHOD HSV TO RGB   ***************
#***********************************************
@cython.boundscheck(False)
@cython.wraparound(False)
@cython.nonecheck(False)

# CYTHON
def hsv2rgb(h: float, s: float, v: float):
    cdef float *rgb
    rgb = hsv2rgb_c(h, s, v)
    return rgb[0], rgb[1], rgb[2]

# CYTHON
@cython.boundscheck(False)
@cython.wraparound(False)
@cython.nonecheck(False)
def rgb2hsv(r: float, g: float, b: float):
    cdef float *hsv
    hsv = rgb2hsv_c(r, g, b)
    return hsv[0], hsv[1], hsv[2]

# C VERSION
@cython.boundscheck(False)
@cython.wraparound(False)
@cython.nonecheck(False)
def rgb_to_hsv_c(r, g, b):
    cdef double *hsv
    hsv = rgb_to_hsv(r, g, b)
    return hsv[0], hsv[1], hsv[2]

# C VERSION
@cython.boundscheck(False)
@cython.wraparound(False)
@cython.nonecheck(False)
def hsv_to_rgb_c(r: float, g: float, b: float):
    cdef double *hsv
    hsv = hsv_to_rgb(r, g, b)
    return hsv[0], hsv[1], hsv[2]

#--------------------- CYTHON CODE --------------------------------------
@cython.boundscheck(False)
@cython.wraparound(False)
@cython.nonecheck(False)
@cython.cdivision(True)
cdef float * rgb2hsv_c(double r_, double g_, double b_)nogil:
    """
    Convert RGB color model into HSV
    This method is identical to the python library colorsys.rgb_to_hsv
    
    :param r_: python float; red in range[0 ... 1.0]
    :param g_: python float; green in range [0 ... 1.0]
    :param b_: python float; blue in range [0 ... 1.0]
    :return: Return HSV values 
    """
    cdef double r = r_ * ONE_255
    cdef double g = g_ * ONE_255
    cdef double b = b_ * ONE_255
    cdef:
        double mx, mn
        double h, df, s, v, df_
        float *hsv = <float *> malloc(3 * sizeof(float))
        
    mx = fmax_rgb_value(r, g, b)
    mn = fmin_rgb_value(r, g, b)

    df = mx-mn
    df_ = 1.0/df
    if mx == mn:
        h = 0
    
    elif mx == r:
        h = (60 * ((g-b) * df_) + 360) % 360  
    elif mx == g:
        h = (60 * ((b-r) * df_) + 120) % 360  
    elif mx == b:
        h = (60 * ((r-g) * df_) + 240) % 360  
    if mx == 0:
        s = 0
    else:
        s = df/mx
    v = mx
    hsv[0] = h * ONE_360
    hsv[1] = s
    hsv[2] = v
    free(hsv)
    return hsv


@cython.boundscheck(False)
@cython.wraparound(False)
@cython.nonecheck(False)
cdef float * hsv2rgb_c(double h, double s, double v)nogil:
    """
    Convert hsv color model to rgb

    :param h: python float; hue in range [0.0 ... 1.0]
    :param s: python float; saturation   [0.0 ... 1.0] 
    :param v: python float; value        [0.0 ... 1.0]
    :return: Return RGB floating values (normalized [0.0 ... 1.0]).
             multiply (red * 255.0, green * 255.0, blue * 255.0) to get the right pixel color.
    """
    cdef:
        int i = 0
        double f, p, q, t
        float *rgb = <float *> malloc(3 * sizeof(float))

    if s == 0.0:
        rgb[0] = v
        rgb[1] = v
        rgb[2] = v
        free(rgb)
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
        free(rgb)
        return rgb
    if i == 1:
        rgb[0] = q
        rgb[1] = v
        rgb[2] = p
        free(rgb)
        return rgb
    if i == 2:
        rgb[0] = p
        rgb[1] = v
        rgb[2] = t
        free(rgb)
        return rgb
    if i == 3:
        rgb[0] = p
        rgb[1] = q
        rgb[2] = v
        free(rgb)
        return rgb
    if i == 4:
        rgb[0] = t
        rgb[1] = p
        rgb[2] = v
        free(rgb)
        return rgb
    if i == 5:
        rgb[0] = v
        rgb[1] = p
        rgb[2] = q
        free(rgb)
        return rgb
