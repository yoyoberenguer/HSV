# cython: binding=False, boundscheck=False, wraparound=False, nonecheck=False, cdivision=True, optimize.use_switch=True
# encoding: utf-8

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

    hsv struct_rgb_to_hsv(double red, double green, double blue)nogil
    rgb struct_hsv_to_rgb(double h, double s, double v)nogil

ctypedef hsv HSV_
ctypedef rgb RGB_


cpdef tuple rgb_to_hsv(double r, double g, double b)
cpdef tuple hsv_to_rgb(double h, double s, double v)




