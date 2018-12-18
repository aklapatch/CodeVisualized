mutable struct cairo_env
    surface::Ptr{Cvoid}
    cr::Ptr{Cvoid}
end

# init cairo layer
function initCairo(height::Float64,width::Float64)::cairo_env
    surface = ccall((:cairo_svg_surface_create,"libcairo"),Ptr{Cvoid},(Cstring,Float64,Float64),"test.svg",height,width)
    cr = ccall((:cairo_create,"libcairo"),Ptr{Cvoid},(Ptr{Cvoid},),surface)

    # set image to white
    ccall((:cairo_set_source_rgb,"libcairo"),Cvoid,(Ptr{Cvoid},Int8,Int8,Int8),cr,0,0,0)

    return cairo_env(surface,cr)
end

function destroyCairo(env::cairo_env)
    ccall((:cairo_surface_destroy,"libcairo"), Cvoid,(Ptr{Cvoid},),env.surface)
    ccall((:cairo_destroy,"libcairo"), Cvoid,(Ptr{Cvoid},),env.cr)
end



function drawTextCairo(env::cairo_env, pos_x::Float64, pos_y::Float64,font_size::Float64, font_name, text)
    ccall((:cairo_select_font_face,"libcairo"),Cvoid, (Ptr{Cvoid},Cstring, Cint,Cint), env.cr, font_name,0,0)
    ccall((:cairo_set_font_size,"libcairo"),Cvoid, (Ptr{Cvoid},Float64), env.cr, font_size)

    ccall((:cairo_move_to,"libcairo"),Cvoid,(Ptr{Cvoid},Float64,Float64),env.cr,pos_x,pos_y)

    ccall((:cairo_show_text,"libcairo"),Cvoid,(Ptr{Cvoid},Cstring),env.cr,text)
end

function drawRectCairo(env::cairo_env, pos_x::Float64, pos_y::Float64,width::Float64, height::Float64)
    ccall((:cairo_rectangle,"libcairo"),Cvoid,(Ptr{Cvoid},Float64,Float64,Float64,Float64),env.cr,pos_x,pos_y,width,height)

    # apply stroke
    ccall((:cairo_stroke,"libcairo"),Cvoid,(Ptr{Cvoid},),env.cr)
end

function setLineWidthCairo(env::cairo_env,line_width::Float64)
    #set line width first
    ccall((:cairo_set_line_width,"libcairo"),Cvoid,(Ptr{Cvoid},Float64),env.cr,line_width)
end

# pos_x and pos_y are the top of the diamond
function drawDiamondCairo(env::cairo_env,pos_x::Float64,pos_y::Float64, width::Float64,height::Float64)

    ccall((:cairo_move_to,"libcairo"),Cvoid,(Ptr{Cvoid},Float64,Float64),env.cr,pos_x,pos_y)

    ccall((:cairo_rel_line_to,"libcairo"),Cvoid,(Ptr{Cvoid},Float64,Float64),env.cr,width/2,height/2)

    ccall((:cairo_rel_line_to,"libcairo"),Cvoid,(Ptr{Cvoid},Float64,Float64),env.cr,-width/2,height/2)

    ccall((:cairo_rel_line_to,"libcairo"),Cvoid,(Ptr{Cvoid},Float64,Float64),env.cr,-width/2,-height/2)

    ccall((:cairo_close_path,"libcairo"),Cvoid,(Ptr{Cvoid},),env.cr)

    ccall((:cairo_stroke,"libcairo"),Cvoid,(Ptr{Cvoid},),env.cr)
end

function drawRelLineCairo(env::cairo_env,pos_x::Float64,pos_y::Float64,dist_x::Float64,dist_y::Float64)
    ccall((:cairo_move_to,"libcairo"),Cvoid,(Ptr{Cvoid},Float64,Float64),env.cr,pos_x,pos_y)

    ccall((:cairo_rel_line_to,"libcairo"),Cvoid,(Ptr{Cvoid},Float64,Float64),env.cr,dist_x,dist_y)

    ccall((:cairo_stroke,"libcairo"),Cvoid,(Ptr{Cvoid},),env.cr)
end