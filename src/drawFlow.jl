include("drawBlocks.jl")

# draws the diamond and the block of true code together
function drawCondition(env::cairo_env,condition::String,x::Float64,y::Float64,true_code::String)

    # draw the diamond
    dia_size = drawTextDiamond(env,condition,x,y)

    # draw the arrow going down from the diamond
    y+=dia_size

    # later return where the no arrow is
    false_x = x
    false_y =y +line_dist_y

    # draw a line from the bottom of the diamond down
    drawArrowLineCairo(env,x,y,0.0,line_dist_y, arrow_width, arrow_height)

    # move coordinates to the right point of the diamond
    x += dia_size/2
    y -= dia_size/2

    # make an arrow from the diamond to a block of true code
    drawArrowLineCairo(env,x,y, line_dist_x,0.0, arrow_width,arrow_height)

    # set the x,y to the end of the arrow
    x += line_dist_x

    # draw the box at the end of the arrow
    rect_w,rect_h = drawTextBox(env,true_code,x,y,false)

    # return the x,y of the end of the true code block
    x = x + rect_w/2 - line_dist_x
    y = y + rect_h

    # we need to return all these since the program needs to be able to
    # figure out how to backtrack to the "No" arrow
    return x,y,false_x,false_y
end


function connectWArrowLines(env,origin_x,origin_y,end_x,end_y)

    # get the distance to draw
    x_dist = end_x - origin_x
    y_dist = end_y - origin_y

    # draw the first relative line before the joining line
    drawRelLineCairo(env,origin_x,origin_y,y_dist,0.0)

    drawArrowLineCairo(env,origin_x,origin_y+y_dist,0.0,x_dist)

end

# draws the control flow in the array
#input is an array of control blocks
# 
# control flow
#  if the control block is an if, draw from the true_code block
# 
#  An else if block draws from the 'No' arrow
#
# an else block also draws from the 'No' arrow
# an else will rejoin the true_code arrow after the else code block
function drawFlow(input,filename::String, line_width::Float64)

    current_x = 350.0
    current_y = 10.0
    dia_size = 0.0
    rect_w = 0.0
    rect_h = 0.0

    # holds coordinates for the true and false paths
    true_x = 350.0
    true_y = 10.0
    false_x =350.0
    false_y = 10.0

    rect_x = 0.0
    rect_y = 0.0

    # index and indicator of program scope
    scope_stack = Vector{ Vector{Tuple{Int64,Int64}} }(undef, 0)
    scope_index::Int64 = 0
    block_index::Int64 = 0

    num_blocks = length(input)
    size_mult = 400.0

    # TODO make the size of the svg proportional to the number of elements
    # in input
    env = initCairo(filename,size_mult*num_blocks,size_mult*num_blocks)

    setLineWidthCairo(env ,line_width)
    
    for i in 1:length(input)

        if typeof(input[i]) == if_block
            
            # draw the block and store where the true_code block ends
            current_x,current_y,false_x,false_y = drawCondition(env,input[i].condition,current_x,current_y,input[i].true_code)

            # increase the scope or the loop if the else needs to be carried on
            if input[i].has_else == true
               
                push!(scope_stack,(current_x,current_y))
                scope_index+=1
                block_index+=1
            else # connect the previous lines 
                
            end

              
        elseif typeof(input[i]) == if_else_block

            # if the previous element is not an if, then an error should be
            # thrown
            # I am assuming that the previous element should be an if
            if i > 1 && typeof(input[i-1]) == if_block
                # backtrack to the 'No' section, and draw another condition from there
                current_x,current_y,false_x,false_y = drawCondition(env,input[i].condition,false_x,false_y,input[i].true_code)

            # TODO output error and stop
            else

            end

            # if the else continues, do not connect the line from the true code
            if input[i].has_else == true
                push!(scope_stack[scope_index],(current_x,current_y))
                block_index +=1
            
            else # connect the previous lines 

            end


        elseif typeof(input[i]) == else_block

            # if the previous element is not an if, then an error should be
            # thrown
            # I am assuming that the previous element should be an if
            if i > 1 && (typeof(input[i-1]) == if_block || typeof(input[i-1]) == if_else_block)

                # just draw the true_code at for the else statement
                rect_w,rect_h = drawTextBox(env,input[i].true_code,false_x,false_y,true)

                false_y+=rect_h

            # TODO output error and stop
            else

            end     
            
            # draw the arrow if it is not at the end
            if i != num_blocks
                drawArrowLineCairo(env,current_x,current_y,0.0,line_dist_y,arrow_width,arrow_height)
            end

            current_y+=line_dist_y

            # connect the blocks with arrow lines
        
        # this is for regular blocks of code, with no conditions
        elseif typeof(input[i]) == String

            # just draw the true_code at for the else statement
            rect_w,rect_h = drawTextBox(env,input[i],false_x,false_y,true)      

            false_y+=rect_h

            current_y = false_y

            # draw the arrow if it is not at the end
            if i != num_blocks
                drawArrowLineCairo(env,current_x,current_y,0.0,line_dist_y,arrow_width,arrow_height)
            end

            current_y+=line_dist_y

        else
            # type in the array was not provisioned for
            throw(ArgumentError("Element ",i," type not recognized."))
        end

    end 

    destroyCairo(env)
end
