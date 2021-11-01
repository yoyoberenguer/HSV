# cython: binding=False, boundscheck=False, wraparound=False, nonecheck=False, cdivision=True, optimize.use_switch=True
# encoding: utf-8

## License :
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

__version__ = "1.0.2"

__all__ = ["rgb_to_hsv", "hsv_to_rgb"]

# CYTHON IS REQUIRED
try:
    cimport cython
except ImportError:
    raise("\n<cython> library is missing on your system."
          "\nTry: \n   C:\\pip install cython in a window command prompt.")

from hsv cimport struct_rgb_to_hsv, struct_hsv_to_rgb, HSV_, RGB_


@cython.boundscheck(False)
@cython.wraparound(False)
@cython.nonecheck(False)
@cython.cdivision(True)
cpdef tuple rgb_to_hsv(double r, double g, double b):
    """
    CONVERT RGB TO HSV MODEL 
    
    This method is calling an external C function struct_rgb_to_hsv (source code in the file hsv_c.c)  
    
    :param r: python float; red normalized value in range [0...1.0]  
    :param g: python float; green normalized value in range [0...1.0]  
    :param b: python float; blue normalized value in range [0...1.0]  
    :return: Return a python object (tuple) of HSV values (Normalized python float, range [0...1.0]) 
    """
    assert 0 <= r <= 1.0, "\nRed value must be normalized!"
    assert 0 <= g <= 1.0, "\nGreen value must be normalized!"
    assert 0 <= b <= 1.0, "\nBlue value must be normalized!"

    cdef HSV_ hsv_ = struct_rgb_to_hsv(r, g, b)
    return hsv_.h, hsv_.s, hsv_.v


@cython.boundscheck(False)
@cython.wraparound(False)
@cython.nonecheck(False)
@cython.cdivision(True)
cpdef tuple hsv_to_rgb(double h, double s, double v):
    """
    CONVERT HSV MODEL TO RGB 
    
    This method is calling an external C function struct_hsv_to_rgb (source code in the file hsv_c.c)  
    
    :param h: python float; hue normalized value in range [0...1.0]  
    :param s: python float; saturation normalized value in range [0...1.0]  
    :param v: python float; value normalized in range [0...1.0]  
    :return: Return a python object (tuple) of RGB values (Normalized python float, range [0...1.0])
    """
    assert 0 <= h <= 1.0, "\nhue value must be normalized!"
    assert 0 <= s <= 1.0, "\nsaturation value must be normalized!"
    assert 0 <= v <= 1.0, "\nvalue must be normalized!"

    cdef RGB_ rgb_ = struct_hsv_to_rgb(h, s, v)
    return rgb_.r, rgb_.g, rgb_.b



