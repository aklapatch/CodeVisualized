include("cairo/cairoWrapper.jl")
include("dataStructure.jl")

# constants for drawing methods

# mulitpliers to make diamonds and boxes fit around text
const text_w_mult= 5.0
const text_h_mult = 2.0

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

# draws a box with the text, text inside
# x and y are the top left corner of the rectangle
function drawTextBox(env::cairo_env,text::String,x::Float64,y::Float64)
    
    # figure out how big the box needs to be
    rect_height = getNumNewlines(text)*text_h_mult*font_size 

    rect_width = longestLineLength(text)*text_w_mult


    # make the text box 
    drawRectCairo(env,x,y,rect_width,rect_height)

    # split the strings at newlines
    text = split(text,'\n')    

    #where to print the text
    current_y = y
    current_x = x+2.0

    for str in text

        # step down to print the next line
        current_y += font_size+1

        # draw the text
        drawTextCairo(env,current_x,current_y,font_size,"Sans",str)

    end    

    # pass back the w and h of the rectangle
    return rect_width,rect_height
end

function drawTextDiamond(env::cairo_env,text::String,x::Float64,y::Float64)::Float64

    # get dimensions of text/diamond
    text_h = getNumNewlines(text::String)*text_h_mult*font_size
    text_w = longestLineLength(text)*text_w_mult

    # use a 45 45 90 triangle (on the top of the text area)to get the height of 
    # the diamond
    # get the height of the triangle
    extra_h = text_w*0.5*tan(pi/4)

    # add the extra_h twice
    dia_h_w = text_h + extra_h*2

    # draw the diamond
    drawDiamondCairo(env, x,y,dia_h_w,dia_h_w)

    # split the strings at newlines
    text = split(text,'\n')    

    #where to print the text
    current_y = y + extra_h
    current_x = x+2.0 - text_w/2

    for str in text

        # step down to print the next line
        current_y += font_size+1

        # draw the text
        drawTextCairo(env,current_x,current_y,font_size,"Sans",str)

    end   

    # draw the Yes and No text
    drawTextCairo(env,x + dia_h_w/2, y + dia_h_w/2 -font_size ,font_size,"Sans","Yes")
    drawTextCairo(env,x + 5, y + dia_h_w + font_size ,font_size,"Sans","No")

    return dia_h_w
end