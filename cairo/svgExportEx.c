// from zetcode.com/gfx/cairo/cairobackends/

#include <cairo/cairo.h>
#include <cairo/cairo-svg.h> 
 
int main(void) 
{
  cairo_surface_t *surface;
  cairo_t *cr;

  surface = cairo_svg_surface_create("svgfile.svg", 390, 60);
  cr = cairo_create(surface);

  cairo_set_source_rgb(cr, 0, 0, 0);


  cairo_select_font_face(cr, "Sans", CAIRO_FONT_SLANT_NORMAL,
      CAIRO_FONT_WEIGHT_NORMAL);
  cairo_set_font_size(cr, 40.0);

  cairo_move_to(cr, 10.0, 50.0);
  //cairo_show_text(cr, "Disziplin ist Macht.");
  
  cairo_set_line_width (cr, 1);
cairo_set_source_rgb (cr, 0, 0, 0);
cairo_rectangle (cr, 0.25, 0.25, 50, 50);
cairo_stroke (cr);

  cairo_surface_destroy(surface);
  cairo_destroy(cr);

  return 0;
}