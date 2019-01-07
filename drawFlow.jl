include("drawBlocks.jl")



# draws the diamond and the block of true code together
function drawCondition(env::cairo_env,condition::String,x::Float64,y::Float64,true_code::String)

    # draw the diamond
    dia_size = drawTextDiamond(env,condition,x,y)

    # move coordinates to the right point of the diamond
    x += dia_size/2
    y += dia_size/2

    # make an arrow from the diamond to a block of true code
    drawArrowLineCairo(env,x,y, line_dist_x,0.0, arrow_width,arrow_height)

    # set the x,y to the end of the arrow
    x += line_dist_x

    # draw the box at the end of the arrow
    rect_w,rect_h = drawTextBox(env,true_code,x,y)

    x = x-dia_size/2 - line_dist_x
    y = y + dia_size/2

    # draw a line from the bottom of the diamond down
    drawArrowLineCairo(env,x,y,0.0,line_dist_y, arrow_width, arrow_height)

    return x,y,dia_size,rect_w,rect_h
end

# draws the control flow in the array
#input is an array of control blocks
function drawFlow(input,filename::String)

    increase_scope::Bool = false
    current_x = 350.0
    current_y = 0.0
    dia_size = 0.0
    rect_w = 0.0
    rect_h = 0.0

    rect_x = 0.0
    rect_y = 0.0

    env = initCairo(filename,700.0,700.0)
    
    for i in 1:length(input)

        if typeof(input[i]) == if_block
            
            current_x,current_y,dia_size,rect_w,rect_h = drawCondition(env,input[i].condition,current_x,current_y,input[i].true_code)

            if i < length(input) && typeof(input[i+1]) == if_block
                # set the current x and y to be from the code block
                current_x += dia_size/2 + line_dist_x + rect_w/2

                current_y = current_y - dia_size/2 - line_dist_y + rect_h
            end
            
            
        elseif typeof(input[i]) == if_else_block

            
            if i > 1 && typeof(input[i-1]) != if_else_block
                # get the x and y of the previous true code block
                rect_x += dia_size/2 + line_dist_x + rect_w/2

                rect_y = current_y - dia_size/2 - line_dist_y + rect_h
                # store that until the series of the else ifs is done

            end

           #TODO draw the code amnd the conditionthat occures for that else if 

            if i == length(input) || typeof(input[i+1]) != if_else_block
                # draw the arrow from the last true code block to the current point
                drawRelLineCairo(env,rect_x,rect_y, 0.0, current_y - rect_y)
                drawArrowLineCairo(env, rect_x, current_y, - rect_x  + current_x, 0.0,arrow_width, arrow_height)

            end

        elseif typeof(input[i]) == else_block


            # find the last true code block and draw the joining line
            # get the x and y of the previous true code block
            rect_x += dia_size/2 + line_dist_x + rect_w/2

            rect_y = current_y - dia_size/2 - line_dist_y + rect_h

            # TODO, draw the code that happens 

            # draw the arrow from the last true code block to the current point
            drawRelLineCairo(env,rect_x,rect_y, 0.0, current_y - rect_y)
            drawArrowLineCairo(env, rect_x, current_y, - rect_x  + current_x, 0.0,arrow_width, arrow_height)



        else
            # type in the array was not provisioned for
            throw(ArgumentError("Element",i," type not recognized."))
        end

    end 

    destroyCairo(env)
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