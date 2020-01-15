import HSV
# This will import the cython version 
from HSV import hsv2rgb, rgb2hsv
# This will import the C version 
from HSV import rgb_to_hsv_c, hsv_to_rgb_c
import colorsys
from colorsys import rgb_to_hsv
import timeit

if __name__ == '__main__':
  print('TESTING CYTHON VERSION')
  # ---------- CYTHON VERSION ---------------------------------------------------------
  r, g, b = 25, 60, 128
  print("\nOriginal RGB values red %s, green %s, blue %s " % (r, g, b))
  # Don't forget to normalise the values (/255.0)
  hsv = rgb2hsv(r/255.0, g/255.0, b/255.0)
  print("Cython hsv values       : ", hsv)
  print("Cython hsv formated     : ", hsv[0] * 360, hsv[1] * 100, hsv[2] * 100)

  hsv1 = colorsys.rgb_to_hsv(r/255.0, g/255.0, b/255.0)
  print("\nColorsys hsv          : ", hsv1)
  print("Colorsys hsv formated : ", hsv1[0] * 360, hsv1[1] * 100, hsv1[2] * 100)
  h, s, v = list(hsv)
  rgb = hsv2rgb(h, s, v)
  red = round(rgb[0] * 255.0)
  green = round(rgb[1] * 255.0)
  blue = round(rgb[2] * 255.0)
  print("Cython rgb values : red %s, green %s, blue %s " % (red, green, blue))

  print('\nTESTING C VERSION')
  # ---------- C VERSION -------------------------------------------------------------
  r, g, b = 25, 60, 128
  print("\nOriginal RGB values red %s, green %s, blue %s " % (r, g, b))
  # Don't forget to normalise the values (/255.0)
  hsv = rgb_to_hsv_c(r/255.0, g/255.0, b/255.0)
  print("C hsv values     : ", hsv)
  print("C hsv formated   : ", hsv[0] * 360, hsv[1] * 100, hsv[2] * 100)
  
  hsv1 = colorsys.rgb_to_hsv(r/255.0, g/255.0, b/255.0)
  print("\nColorsys hsv          : ", hsv1) 
  print("Colorsys hsv formated : ", hsv1[0] * 360, hsv1[1] * 100, hsv1[2] * 100)
  h, s, v = list(hsv)
  rgb = hsv_to_rgb_c(h, s, v)
  red = round(rgb[0] * 255.0)
  green = round(rgb[1] * 255.0)
  blue = round(rgb[2] * 255.0)
  print("\nC rgb values : red %s, green %s, blue %s " % (red, green, blue))

  N = 1000000
  print("\nCython rgb2hsv ", timeit.timeit("rgb2hsv(r/255.0, g/255.0, b/255.0)", "from __main__ import rgb2hsv, r, g, b", number = N))
  print("C rgb_to_hsv_c ", timeit.timeit("rgb_to_hsv_c(r/255.0, g/255.0, b/255.0)", "from __main__ import rgb_to_hsv_c, r, g, b", number = N))
  print("C rgb_to_hsv_c ", timeit.timeit("rgb_to_hsv(r/255.0, g/255.0, b/255.0)", "from __main__ import rgb_to_hsv, r, g, b", number = N))
