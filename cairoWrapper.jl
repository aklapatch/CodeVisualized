
# init cairo layer
function initCairo()

    surface = ccall(:cairo_svg_surface_create,"libcairo",Ptr{Cvoid},(Cstring,),Float64,Float64,"test.svg",400,400)
    cr = ccall(:cairo_create,"libcairo",Ptr{void},Ptr{void},surface)

    

end

initCairo()
