import HSV

# This will import the cython version 
from HSV import hsv2rgb, rgb2hsv

# This will import the C version 
from HSV import rgb_to_hsv_c, hsv_to_rgb_c

from HSV import struct_rgb_to_hsv_c, struct_hsv_to_rgb_c

import colorsys
from colorsys import rgb_to_hsv

import timeit

if __name__ == '__main__':
    print('TESTING HSV CYTHON VERSION')
    # ---------- CYTHON VERSION ---------------------------------------------------------
    r, g, b = 25, 60, 128
    print("\nOriginal RGB values red %s, green %s, blue %s " % (r, g, b))
    # Don't forget to normalise the values (/255.0)
    hsv = rgb2hsv(r / 255.0, g / 255.0, b / 255.0)
    print("Cython hsv values       : ", hsv)
    print("Cython hsv formated     : ", hsv[0] * 360, hsv[1] * 100, hsv[2] * 100)

    hsv1 = colorsys.rgb_to_hsv(r / 255.0, g / 255.0, b / 255.0)
    print("\nColorsys hsv          : ", hsv1)
    print("Colorsys hsv formated : ", hsv1[0] * 360, hsv1[1] * 100, hsv1[2] * 100)
    h, s, v = list(hsv)
    rgb = hsv2rgb(h, s, v)
    red = round(rgb[0] * 255.0)
    green = round(rgb[1] * 255.0)
    blue = round(rgb[2] * 255.0)
    print("Cython rgb values : red %s, green %s, blue %s " % (red, green, blue))

    print('\nTESTING HSV C VERSION')
    # ---------- C VERSION -------------------------------------------------------------
    r, g, b = 25, 60, 128
    print("\nOriginal RGB values red %s, green %s, blue %s " % (r, g, b))
    # Don't forget to normalise the values (/255.0)
    hsv = rgb_to_hsv_c(r / 255.0, g / 255.0, b / 255.0)
    print("C hsv values     : ", hsv)
    print("C hsv formated   : ", hsv[0] * 360, hsv[1] * 100, hsv[2] * 100)

    hsv1 = colorsys.rgb_to_hsv(r / 255.0, g / 255.0, b / 255.0)
    print("\nColorsys hsv          : ", hsv1)
    print("Colorsys hsv formated : ", hsv1[0] * 360, hsv1[1] * 100, hsv1[2] * 100)
    h, s, v = list(hsv)
    rgb = hsv_to_rgb_c(h, s, v)
    red = round(rgb[0] * 255.0)
    green = round(rgb[1] * 255.0)
    blue = round(rgb[2] * 255.0)
    print("\nC rgb values : red %s, green %s, blue %s \n" % (red, green, blue))

    N = 1000000

    print("\nTIMINGS :")
    print("Cython rgb2hsv %s for %s iterations: " % (timeit.timeit("rgb2hsv(r/255.0, g/255.0, b/255.0)",
                                                                   "from __main__ import rgb2hsv, r, g, b", number=N),
                                                     N))
    print("C rgb_to_hsv_c %s for %s iterations: " % (timeit.timeit("rgb_to_hsv_c(r/255.0, g/255.0, b/255.0)",
                                                                   "from __main__ import rgb_to_hsv_c, r, g, b",
                                                                   number=N), N))
    print("struct_rgb_to_hsv_c %s for %s iterations: " % (
        timeit.timeit("struct_rgb_to_hsv_c(r/255.0, g/255.0, b/255.0)",
                      "from __main__ import struct_rgb_to_hsv_c, r, g, b",
                      number=N), N))
    print("struct_hsv_to_rgb_c %s for %s iterations: " % (
        timeit.timeit("struct_hsv_to_rgb_c(r/255.0, g/255.0, b/255.0)",
                      "from __main__ import struct_hsv_to_rgb_c, r, g, b",
                      number=N), N))

    print("Colorsys rgb_to_hsv %s for %s iterations: " % (timeit.timeit("rgb_to_hsv(r/255.0, g/255.0, b/255.0)",
                                                                        "from __main__ import rgb_to_hsv, r, g, b",
                                                                        number=N), N))

    # TEST CYTHON rgb2hsv method vs colorsys.rgb_to_hsv
    for i in range(256):
        for j in range(256):
            for k in range(256):
                hsv = rgb2hsv(i / 255.0, j / 255.0, k / 255.0)
                hsv1 = colorsys.rgb_to_hsv(i / 255.0, j / 255.0, k / 255.0)
                h, s, v = round(hsv[0], 2), round(hsv[1], 2), round(hsv[2], 2)
                h1, s1, v1 = round(hsv1[0], 2), round(hsv1[1], 2), round(hsv1[2], 2)
                if abs(h - h1) > 0.1 or abs(s - s1) > 0.1 or abs(v - v1) > 0.1:
                    print("\n R:%s G:%s B :%s " % (i, j, k))
                    print("rgb_to_hsv_c   : h:%s s:%s v:%s " % (h, s, v))
                    print("rgb_to_hsv     : h:%s s:%s v:%s " % (h1, s1, v1))
                    raise ValueError("discrepancy.")

    # TEST CYTHON rgb_to_hsv_c method vs colorsys.rgb_to_hsv
    for i in range(256):
        for j in range(256):
            for k in range(256):
                hsv = rgb_to_hsv_c(i / 255.0, j / 255.0, k / 255.0)
                hsv1 = colorsys.rgb_to_hsv(i / 255.0, j / 255.0, k / 255.0)
                h, s, v = round(hsv[0], 2), round(hsv[1], 2), round(hsv[2], 2)
                h1, s1, v1 = round(hsv1[0], 2), round(hsv1[1], 2), round(hsv1[2], 2)
                if abs(h - h1) > 0.1 or abs(s - s1) > 0.1 or abs(v - v1) > 0.1:
                    print("\n R:%s G:%s B :%s " % (i, j, k))
                    print("rgb_to_hsv_c   : h:%s s:%s v:%s " % (h, s, v))
                    print("rgb_to_hsv     : h:%s s:%s v:%s " % (h1, s1, v1))
                    raise ValueError("discrepancy.")

    # TEST C hsv_to_rgb_c method vs colorsys.hsv_to_rgb
    for i in range(256):
        for j in range(256):
            for k in range(256):
                hsv = colorsys.rgb_to_hsv(i / 255.0, j / 255.0, k / 255.0)
                h1, s1, v1 = hsv[0], hsv[1], hsv[2]
                rgb = hsv_to_rgb_c(h1, s1, v1)
                r, g, b = rgb[0] * 255.0, rgb[1] * 255.0, rgb[2] * 255.0
                rgb1 = colorsys.hsv_to_rgb(h1, s1, v1)
                r1, g1, b1 = rgb1[0] * 255.0, rgb1[1] * 255.0, rgb1[2] * 255.0
                if abs(r - r1) > 0.1 or abs(g - g1) > 0.1 or abs(b - b1) > 0.1:
                    print("\n", i, j, k)
                    print(r, g, b)
                    print(r1, g1, b1)
                    raise ValueError("discrepancy.")

    # TEST C hsv2rgb method vs colorsys.hsv_to_rgb
    for i in range(256):
        for j in range(256):
            for k in range(256):
                hsv = colorsys.rgb_to_hsv(i / 255.0, j / 255.0, k / 255.0)
                h1, s1, v1 = hsv[0], hsv[1], hsv[2]
                rgb = hsv2rgb(h1, s1, v1)
                r, g, b = rgb[0] * 255.0, rgb[1] * 255.0, rgb[2] * 255.0
                rgb1 = colorsys.hsv_to_rgb(h1, s1, v1)
                r1, g1, b1 = rgb1[0] * 255.0, rgb1[1] * 255.0, rgb1[2] * 255.0

                if abs(r - r1) > 0.1 or abs(g - g1) > 0.1 or abs(b - b1) > 0.1:
                    print("\n R:%s G:%s B:%s " % (i, j, k))
                    print("hsv2rgb R:%s G:%s B:%s " % (r, g, b))
                    print("colorsys : R:%s G:%s B:%s " % (r1, g1, b1))
                    raise ValueError("discrepancy.")

        # TEST struct_rgb_to_hsv_c method vs colorsys.hsv_to_rgb
        for i in range(256):
            for j in range(256):
                for k in range(256):
                    hsv = colorsys.rgb_to_hsv(i / 255.0, j / 255.0, k / 255.0)
                    h1, s1, v1 = hsv[0], hsv[1], hsv[2]
                    rgb = struct_rgb_to_hsv_c(h1, s1, v1)
                    r, g, b = rgb[0] * 255.0, rgb[1] * 255.0, rgb[2] * 255.0
                    rgb1 = colorsys.hsv_to_rgb(h1, s1, v1)
                    r1, g1, b1 = rgb1[0] * 255.0, rgb1[1] * 255.0, rgb1[2] * 255.0

                    if abs(r - r1) > 0.1 or abs(g - g1) > 0.1 or abs(b - b1) > 0.1:
                        print("\n R:%s G:%s B:%s " % (i, j, k))
                        print("struct_rgb_to_hsv_c R:%s G:%s B:%s " % (r, g, b))
                        print("colorsys : R:%s G:%s B:%s " % (r1, g1, b1))
                        raise ValueError("discrepancy.")
