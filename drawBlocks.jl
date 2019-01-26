include("cairo/cairoWrapper.jl")
include("dataStructure.jl")

# constants for drawing methods

# mulitpliers to make diamonds and boxes fit around text
const text_w_mult= 5.5
const text_h_mult = 1.7

# font_size
const font_size = 10.0

const line_dist_x = 30.0
const line_dist_y = 30.0

const arrow_height = 10.0
const arrow_width = 10.0


function getNumNewlines(input::String)::Int64
    number::Int64 = 1
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

            if current_len > max_len
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
function drawTextBox(env::cairo_env,text::String,x::Float64,y::Float64, center_x::Bool)
    
    global font_size
    global text_w_mult
    global text_h_mult
    
    # figure out how big the box needs to be
    rect_height = getNumNewlines(text)*text_h_mult*font_size 

    rect_width = longestLineLength(text)*text_w_mult


    if center_x == true
        # make the text box, and center it on the x
        x -= rect_width/2
        drawRectCairo(env,x,y,rect_width,rect_height)

    else
        # draw and center on y
        y -= rect_height/2
        drawRectCairo(env,x,y,rect_width,rect_height)
    end


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

    global font_size
    global text_h_mult
    global text_w_mult    

    # get dimensions of text/diamond
    text_h = getNumNewlines(text)*text_h_mult*font_size
    text_w = longestLineLength(text)*text_w_mult

    # add the extra width to get the proper width of the diamod
    dia_h_w = text_w + 2*text_h

    # draw the diamond
    drawDiamondCairo(env, x,y,dia_h_w,dia_h_w)

    # split the strings at newlines
    text = split(text,'\n')    

    #where to print the text
    current_y = y + dia_h_w/2 - text_h/2 + font_size
    current_x = x - text_w/2

    for str in text
        # draw the text
        drawTextCairo(env,current_x,current_y,font_size,"Sans",str)

        # step down to print the next line
        current_y += font_size+1
    end   

    # draw the Yes and No text
    drawTextCairo(env,x + dia_h_w/2, y + dia_h_w/2 -font_size ,font_size,"Sans","Yes")
    drawTextCairo(env,x + 5, y + dia_h_w + font_size ,font_size,"Sans","No")

    return dia_h_w
end