include("cairo/cairoWrapper.jl")
include("dataStructure.jl")






# draw an if block
# x and y are positions to draw the block
function drawIf(env::cairo_env, input::if_block,x::Float64,y::Float64)
    text_mult::Float64 = 3.0
    dia_height::Float64 = 4.0
    condition_len = length(input.condition)
    font_size::Float64 = 10.0

    current_x::Float64 = x
    current_y::Float64 = y

    line_dist_x::Float64 = 10.0
    line_dist_y::Float64 = 10.0

    # draw the diamond to hold the text
    drawDiamondCairo(env,x,y,condition_len*text_mult, dia_height)

    # draw the text in a certian spot
    drawTextCairo(env,x,y+dia_height/2,font_size,"Sans",input.condition)

    # draw line to true code
    drawRelLineCairo(env,x + (condition_len*text_mult*0.5),y+(dia_height/2),line_dist_x,0)
    current_y = x + (condition_len*text_mult*0.5) + line_dist_x
    current_y = y+(dia_height/2)

    # draw the arrow for the line to true code
    

    # draw the true text and the true code

    # draw the false text

    # draw line to continue on down

    # connect the lines for the true code and the false condition
     

    # return the ending x and y coordinates
end




# draw an else if block





# draw an else block




# this function calls the upper three functions and inits the cairo environment
# input is a vector of control blocks
# it checks the type and calls one of the above functions accordingly
