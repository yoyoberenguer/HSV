###cython: boundscheck=False, wraparound=False, nonecheck=False, optimize.use_switch=True

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


# ------------------------------------ INTERFACE ----------------------------------------------

#***********************************************
#**********  METHOD HSV TO RGB   ***************
#***********************************************
@cython.boundscheck(False)
@cython.wraparound(False)
@cython.nonecheck(False)
# CYTHON VERSION
cpdef hsv2rgb(double h, double s, double v):
    cdef:
        double *rgb
        double r, g, b
    rgb = hsv2rgb_c(h, s, v)
    r, g, b = rgb[0], rgb[1], rgb[2]
    free(rgb)
    return r, g ,b

# CYTHON VERSION
@cython.boundscheck(False)
@cython.wraparound(False)
@cython.nonecheck(False)
cpdef rgb2hsv(double r, double g, double b):
    cdef:
        double *hsv
        double h, s, v
    hsv = rgb2hsv_c(r, g, b)
    h, s, v = hsv[0], hsv[1], hsv[2]
    free(hsv)
    return h, s, v

# C VERSION
@cython.boundscheck(False)
@cython.wraparound(False)
@cython.nonecheck(False)
cpdef rgb_to_hsv_c(double r, double g, double b):
    cdef:
        double *hsv
        double h, s, v
    hsv = rgb_to_hsv(r, g, b)
    h, s, v = hsv[0], hsv[1], hsv[2]
    free(hsv)
    return h, s, v

# C VERSION
@cython.boundscheck(False)
@cython.wraparound(False)
@cython.nonecheck(False)
cpdef hsv_to_rgb_c(double h, double s, double v):
    cdef:
        double *rgb
        double r, g, b
    rgb = hsv_to_rgb(h, s, v)
    r, g, b = rgb[0], rgb[1], rgb[2]
    free(rgb)
    return r, g, b

#------------------------------------- CYTHON CODE --------------------------------------
@cython.boundscheck(False)
@cython.wraparound(False)
@cython.nonecheck(False)
@cython.cdivision(True)
cdef double * rgb2hsv_c(double r, double g, double b)nogil:
    """
    Convert RGB color model into HSV
    This method is identical to the python library colorsys.rgb_to_hsv
    * Don't forget to free the memory allocated for hsv values if you are 
    calling the method without using the cpdef function (see interface section).
    (Use the same pointer address returned by malloc() to free the block)
    
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
    * Don't forget to free the memory allocated for rgb values if you are 
    calling the method without using the cpdef function (see interface section).
    (Use the same pointer address returned by malloc() to free the block)

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
