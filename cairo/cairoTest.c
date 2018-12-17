#include<stdio.h>
#include <cairo/cairo.h>
#include <cairo/cairo-svg.h>

int main() {

    // try to make a surface to 
    cairo_surface_t * surface = cairo_svg_surface_create ("test.svg",400,400);
    cairo_t * cr = cairo_create(surface);

    // sets all the pixels to white
    cairo_set_source_rgb(cr, 0, 0, 0);

    cairo_surface_destroy(surface);
    cairo_destroy(cr);

    return 0;
}