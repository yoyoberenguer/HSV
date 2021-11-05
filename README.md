<p align="center">
    <img src="https://github.com/yoyoberenguer/HSV/blob/master/hue.gif" width="200">
</p>


# HSV project

##  Why installing HSV :

This library offers fast conversion tools such as `HSV to RGB` and `RGB to HSV`
ported into cython for better performances 

 

## Project description :
```
Conversions between color systems (cython library)
This module defines bidirectional conversions of color values between colors
expressed in the RGB (Red Green Blue) color space used in computer monitors and three
HSV (Hue Saturation, Value).
```

## Installation 
```
pip install HSV
```

## How to?
```python
from HSV.hsv import rgb_to_hsv, hsv_to_rgb

if __name__ == '__main__':
    ONE_255 = 1.0 / 255.0
    r, g, b = 25, 60, 128
    print("\nOriginal RGB values (R:%s, G:%s, B:%s)\n" % (r, g, b))
    
    h, s, v = rgb_to_hsv(r * ONE_255, g * ONE_255, b * ONE_255)
    
    print("HSV values (H:%s, S:%s, V:%s)" % (h * 360.0, s * 100.0, v * 100.0))
    
    r, g, b = hsv_to_rgb(h, s, v)
    
    print("Retrieved RGB values (R:%s, G:%s, B:%s)\n" % (r * 255.0, g * 255.0, b * 255.0))
```

## Building cython code

If you need to compile the Cython code after changing the files `hsv.pyx` or `hsv.pxd` or
the external C code please proceed as follow:
```
1) open a terminal window
2) Go in the main project directory where (hsv.pyx & hsv.pxd files are located)
3) run : python setup_hsv.py build_ext `--inplace`

If you have to compile the code with a specific python version, make sure
to reference the right python version in (c:\python setup_hsv.py build_ext --inplace)

If the compilation fail, refers to the requirement section and make sure cython
and a C-compiler are correctly install on your system.
- A compiler such visual studio, MSVC, CGYWIN setup correctly on your system.
  - a C compiler for windows (Visual Studio, MinGW etc) install on your system
  and linked to your windows environment.
  Note that some adjustment might be needed once a compiler is install on your system,
  refer to external documentation or tutorial in order to setup this process.
  e.g https://devblogs.microsoft.com/python/unable-to-find-vcvarsall-bat/
```

## Credit
`Yoann Berenguer` 

## Dependencies :
```
cython >= 0.28
setuptools>=49.2.1
```

## License :
```
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
```

## Timing :

python
Test with `1000000` iterations
```
This library
`rgb_to_hsv` per call 2.22e-07 overall time 0.22196 for 1000000
`hsv_to_rgb` per call 1.156e-07 overall time 0.11563 for 1000000

Colorsys library
`rgb_to_hsv` per call 9.631e-07 overall time 0.96312 for 1000000
`hsv_to_rgb` per call 4.587e-07 overall time 0.45866 for 1000000
```


