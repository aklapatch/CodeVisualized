

mutable struct cairo_env
    surface::Ptr{void}
    cr::Ptr{void}
end

# init cairo layer
function initCairo(height::Float64,width::Float64)::cairo_env
    #t = ccall(:clock,Int32,())
    surface = ccall((:cairo_svg_surface_create,"./libcairo.dll.a"),Ptr{Cvoid},(Cstring,Float64,Float64),"test.svg",height,width)
    cr = ccall(:cairo_create,"./libcairo.a",Ptr{void},(Ptr{void},),surface)

    # set image to white
    ccall(:cairo_set_source_rgb,"./libcairo.a",Cvoid,(Ptr{void},Int8,Int8,Int8),cr,0,0,0)

    return cairo_env(surface,cr)
end

destroyCairo(env::cairo_env)
    ccall(:cairo_surface_destroy,"./libcairo.a", Cvoid,(Ptr{void},),env.surface)
    ccall(:cairo_destroy,"./libcairo.a", Cvoid,(Ptr{void},),env.cr)
end
