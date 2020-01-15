# HSV

## RGB to HSV and HSV to RGB colors system converstion tools.
```
This project provides the cython methods and C versions of the 
HSV conversion algorithms.

The code is based on the current python COLORSYS library, adapted and improved 
for an astonishing increase in speed compare to the original model.

```
## Requirements: 
```
python >=3.0  
Cython 
```
## Compilation:
```
You need to re-compile the file hsv.pyx after any change(s). 
Use the following:
C:\>python setup_hsv.py build_ext --inplace

This will translates Cython source code into efficient C code

If you change the file hsv_c you will also need to recompile the project 
```
## How to:
```
import the code in your program:

import HSV
# This will import the cython version 
from HSV import hsv2rgb, rgb2hsv

# This will import the C version 
from HSV import rgb_to_hsv_c, hsv_to_rgb_c

if __name__ == '__main__':
  r, g, b = 25, 60, 128
  rgb = rgb_to_hsv_c(r/255.0, g/255.0, b/255.0)


```
