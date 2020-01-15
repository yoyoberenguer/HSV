/* C implementation */

#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <memory.h>
#include <math.h>
#include <float.h>
#include <assert.h>

// From a given set of RGB values, determines min and max values.
double fmax_rgb_value(double red, double green, double blue);
double fmin_rgb_value(double red, double green, double blue);

// Convert RGB color model into HSV and reciprocally
double * rgb_to_hsv(double r, double g, double b);
double * hsv_to_rgb(double h, double s, double v);

#define ONE_255 1.0/255.0
#define ONE_360 1.0/360.0

#define cmax(a,b) \
   ({ __typeof__ (a) _a = (a); \
       __typeof__ (b) _b = (b); \
     _a > _b ? _a : _b; })


// All inputs have to be double precision (python float) in range [0.0 ... 255.0]
// Output: return the maximum value from given RGB values (double precision).
inline double fmax_rgb_value(double red, double green, double blue)
{
    if (red>green){
        if (red>blue) {
		    return red;}
		else {
		    return blue;}
    }
    else if (green>blue){
	    return green;}
        else {
	        return blue;}
}

// All inputs have to be double precision (python float) in range [0.0 ... 255.0]
// Output: return the minimum value from given RGB values (double precision).
inline double fmin_rgb_value(double red, double green, double blue)
{
    if (red<green){
        if (red<blue){
            return red;}
    else{
	    return blue;}
    }
    else if (green<blue){
	    return green;}
    else{
	    return blue;}
}



// Convert RGB color model into HSV model (Hue, Saturation, Value)
// all colors inputs have to be double precision (RGB normalized values),
// (python float) in range [0.0 ... 1.0]
// outputs is a C array containing 3 values, HSV (double precision)
inline double * rgb_to_hsv(double r, double g, double b)
{
    // check if all inputs are normalized
    assert ((0.0<=r) <= 1.0);
    assert ((0.0<=g) <= 1.0);
    assert ((0.0<=b) <= 1.0);

    double mx, mn;
    double h, df, s, v, df_;
    double *hsv = malloc (sizeof (double) * 3);
    // Check if the memory has been successfully 
    // allocated by malloc or not 
    if (hsv == NULL) { 
        printf("Memory not allocated.\n"); 
        exit(0); 
    } 

    mx = fmax_rgb_value(r, g, b);
    mn = fmin_rgb_value(r, g, b);

    df = mx-mn;
    df_ = 1.0/df;
    if (mx == mn)
    {
        h = 0.0;}
    // The conversion to (int) approximate the final result 
    else if (mx == r){
        // h = (int)(60.0 * ((g-b) * df_) + 360.0) % 360;}
	h = fmod(60.0 * ((g-b) * df_) + 360.0, 360);}
    else if (mx == g){
        // h = (int)(60.0 * ((b-r) * df_) + 120.0) % 360;}
	h = fmod(60.0 * ((b-r) * df_) + 120.0, 360);}
    else if (mx == b){
        // h = (int)(60.0 * ((r-g) * df_) + 240.0) % 360;}
	h = fmod(60.0 * ((r-g) * df_) + 240.0, 360);}
    if (mx == 0){
        s = 0.0;}
    else{
        s = df/mx;}
    v = mx;
    hsv[0] = h * ONE_360;
    hsv[1] = s;
    hsv[2] = v;
    free(hsv);
    return hsv;
}

// Convert HSV color model into RGB (red, green, blue)
// all inputs have to be double precision, (python float) in range [0.0 ... 1.0]
// outputs is a C array containing RGB values (double precision) normalized.

inline double * hsv_to_rgb(double h, double s, double v)
{
    // check if all inputs are normalized
    assert ((0.0<= h) <= 1.0);
    assert ((0.0<= s) <= 1.0);
    assert ((0.0<= v) <= 1.0);

    int i;
    double f, p, q, t;
    double *rgb = malloc (sizeof (double) * 3);
    // Check if the memory has been successfully 
    // allocated by malloc or not 
    if (rgb == NULL) { 
        printf("Memory not allocated.\n"); 
        exit(0); 
    } 

    if (s == 0.0){
        rgb[0] = v;
        rgb[1] = v;
        rgb[2] = v;
	free(rgb);
        return rgb;
    }

    i = (int)(h*6.0);

    f = (h*6.0) - i;
    p = v*(1.0 - s);
    q = v*(1.0 - s*f);
    t = v*(1.0 - s*(1.0-f));
    i = i%6;

    if (i == 0){
        rgb[0] = v;
        rgb[1] = t;
        rgb[2] = p;
	free(rgb);
        return rgb;
    }
    else if (i == 1){
        rgb[0] = q;
        rgb[1] = v;
        rgb[2] = p;
	free(rgb);
        return rgb;
    }
    else if (i == 2){
        rgb[0] = p;
        rgb[1] = v;
        rgb[2] = t;
	free(rgb);
        return rgb;
    }
    else if (i == 3){
        rgb[0] = p;
        rgb[1] = q;
        rgb[2] = v;
	free(rgb);
        return rgb;
    }
    else if (i == 4){
        rgb[0] = t;
        rgb[1] = p;
        rgb[2] = v;
	free(rgb);
        return rgb;
    }
    else if (i == 5){
        rgb[0] = v;
        rgb[1] = p;
        rgb[2] = q;
	free(rgb);
        return rgb;
    }
    free(rgb);
    return rgb;
}


int main ()
{



return 0;
}

