include("cairo/cairoWrapper.jl")
include("dataStructure.jl")

# constants for drawing methods

# mulitpliers to make diamonds and boxes fit around text
const text_w_mult= 3.0
const text_h_mult = 3.0

#diamond height
const dia_height= 20.0

# font_size
const font_size = 10.0

const line_dist_x = 10.0
const line_dist_y = 10.0

const arrow_height = 10.0
const arrow_width = 10.0


function getNumNewlines(input::String)::Int64
    number::Int64 = 0
    for char in input
        if char == '\n'
            number +=1
        end
    end
    return number
end

function longestLineLength(input::String)::Int64
    current_len::Int64 = 0
    max_len::Int64 =0

    for char in input
        if (char == '\n')

            if(current_len > max_len)
                max_len = current_len
            end

            current_len = 0

        else
            current_len +=1
        end
    end

    if current_len > max_len
        return current_len
    end

    return max_len
end

function drawCondition(env::cairo_env,condition::String,x::Float64,y::Float64,true_code::String)
    global text_w_mult 
    global dia_height
    global arrow_height
    global arrow_width
    global line_dist_x
    global line_dist_y
    global font_size

    condition_len = length(text)
    dia_w = length(text)*text_w_mult
    # draw the diamond to hold the text
    drawDiamondCairo(env,x,y,dia_w, dia_height)

    # draw the text in the diamond
    drawTextCairo(env,x,y+dia_height/2,font_size,"Sans",text)

    # draw text for true and false statements
    drawTextCairo(env,x+dia_w/2,y+dia_height/2,font_size,"Sans","Yes")

    # draw text for true and false statements
    drawTextCairo(env,x,y+dia_height+font_size,font_size,"Sans","No")

    # draw the arrow to the true code
    drawArrowLineCairo(env,
                    x + (dia_w*0.5),
                    y+(dia_height/2),
                    line_dist_x,
                    0,
                    arrow_width,
                    arrow_height)
    
    current_x::Float64 = x + (condition_len*text_mult*0.5) + line_dist_x
    current_y::Float64 = y+(dia_height/2)

    # figure out how big the box needs to be
    rect_height = getNumNewlines(true_code)*text_h_mult    

    rect_width = longestLineLength(true_code)*text_w_mult
    # make the text box 
    drawRectCairo(env,current_x,current_y,rect_width,rect_height)

    # draw the text
    drawTextCairo(env,current_x,current_y,font_size,"Sans",true_code)

    current_x = current_x + rect_width/2
    current_y = current_y + rect_height

    return current_x, current_y
end


# draw an if block
# x and y are positions to draw the block
function drawIf(env::cairo_env, input::if_block,x::Float64,y::Float64)



    # draw line to true code
    

    #draw



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
