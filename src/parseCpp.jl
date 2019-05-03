include("dataStructure.jl")

    # return the index of the string matching the pattern
function findPattern(pattern::String, search_me::String, start::Int,done::Int)::Int
    
    # return if no match
    if (!occursin(pattern,search_me[start:done]))
        return done+1
    end

    #TODO fix this bad way of doing things
    # this is an expensive way to do this since array[1:n]
    # allocates a copy
    pat_len = length(pattern)-1
    i=start
    while (i + pat_len) < done
        # return the ending index of the match
        # @show(search_me[i:i+pat_len])
        if (pattern == search_me[i:i+pat_len])
            return i     
        end
        i+=1
    end

    # return end index+1 if no match found
    return done+1
end

# go until your find a comment, then make the output = previous portion
# keep going and if you
function filterComments(str::String)::String
    #remove all the comments from the string
    # start from the beginning

    # skip if there are no comments
    if (!occursin("//",str) && !occursin( "/*",str))
        return str
    end

    output::String = ""
    i = 1
    len = length(str)
    end_comment = 1
    
    # logic: go through str, find the index of the start of the comment
    # and store everything up to that comment into output
    # then set the search index to the end of the comment

    while i <= len
        commentDash = findPattern("//",str,i,len)
        commentStar = findPattern("/*",str,i,len)

        if (commentDash < commentStar )
            # find the end and concat to output
            end_comment = findPattern("\n",str,commentDash,len)
            output = output * str[i:commentDash-1]
            i = end_comment
            
        elseif (commentDash > commentStar)
            # find the end and concat to output
            end_comment = findPattern("*/",str,commentStar,len)
            output = output * str[i:commentStar-1]
            i = end_comment+2
            
        # if they are equal, then it should be done
        else 
            output = output * str[i:len]
            i = len +1  
        end   
    end
    return output
end

# return type of block and its index in the array
function findBlock(file::String, start::Int)
    i = start
    len = length(file)

    b_types = Vector{Int64}(undef,2)
    b_types[1] = findPattern("if",file,i,len)
    b_types[2]= findPattern("else",file,i,len)

    if b_types[1] == b_types[2] 
        return len,"done"
    end

    # find the closest block
    smallest = 1
    j = 1
    while j < 3
        if b_types[j] < b_types[smallest]
            smallest = j
        end
        j+=1
    end

    if smallest == 1
        return b_types[1],"if"

    elseif smallest == 2

        # figure out if there is an else if and return it
        if findPattern("\n",file,b_types[2],len) < findPattern("if", file,b_types[2],len)
            return b_types[2],"else"
        else 

            return findPattern("if", file,b_types[2],len),"else if"
        end
    end
    
    # no blocks found
    return i,"done"
end


function getControlBlockNum(file::String)
    i = 1
    len = length(file)
    num_of_blocks = 0
    while i <= len
        # count all the if's, elses and if elses

        if (findPattern("if",file,i,len) < len)
            i = findPattern("if",file,i,len)
            num_of_blocks += 1
        end

        if (findPattern("else",file,i,len) < len)

            i = findPattern("else",file,i,len) 
            
            # check for else if
            if_dex = findPattern("if",file,i,len)

            # found the else if
            if (if_dex < findPattern("\n",file,i,len))
                i = if_dex
                num_of_blocks += 1
            else 
                num_of_blocks +=1
            end
        end

        i+=1
    end
    return num_of_blocks
end

# traverse the code until you find another else 
# if you find an else if keep going
function hasElse(file::String,i::Int)
    len = length(file)

    # if there is an else if, keep going
    first_else = findPattern("else",file,i,len)
    if first_else > len
        return false
    end

    # if there is an if following the code block, there is no else
    if first_else > findPattern("if",file,i,len)
        return false
    end

    # go until you find an if before the \n
    while findPattern("if",file,first_else,len) < findPattern("\n",file,first_else,len)
        # when the if is connected to the else
        first_else = findPattern("else",file,first_else+1,len)
    end

    #once you get through the else if's check for another else
    if findPattern("else",file,i,len) < len
        return true
    end
end

function getIfBlock(file::String,i::Int)
    len = length(file)

    open_paren =findPattern("(",file,i,len)
    close_paren = findPattern(")",file,i,len)
    condition = file[open_paren:close_paren]
    
    # if you find a { before a alphanumeric char, then they are for that if
    brace_dex = findPattern("{",file, close_paren, len)
    if ( brace_dex > findPattern(";",file,close_paren,len))
        code_end = findPattern(";",file,close_paren,len)
        true_code = file[close_paren+1:code_end]

        return (code_end,if_block(condition,true_code,hasElse(file,code_end)))
    
    elseif (all(isspace, file[close_paren:brace_dex]))
        code_end = findPattern(";",file,close_paren,len)
        true_code = file[close_paren+1:code_end]

        return (code_end,if_block(condition,true_code,hasElse(file,code_end)))

    # get code in between braces
    else 
        code_start = findPattern("{",file,close_paren,len)
        code_end = findPattern("}",file,code_start,len)

        true_code = file[code_start:code_end]
        
        return (code_end,if_block(condition,true_code,hasElse(file,code_end)))
    end
end


# finds the end of a control block and inits it
# this code assumes it starts right after the if statement
function initBlock(file::String, i::Int, typ::String)
    # find the end of the block

    len = length(file)
    # get the condition and the code if true
    if (typ == "if")
        return getIfBlock(file,i)
    elseif (typ == "else if")
        return getElseIfBlock(file,i)

    elseif (typ == "else")
        return getElseBlock(file,i)
    else 
        throw(ArgumentError("Block type not recognized"))
    end
end

function getElseIfBlock(file::String,i::Int)
    len = length(file)

    open_paren =findPattern("(",file,i,len)
    close_paren = findPattern(")",file,i,len)
    condition = file[open_paren:close_paren]
    
    # if you find a { before a alphanumeric char, then they are for that if
    brace_dex = findPattern("{",file, close_paren, len)
    if ( brace_dex > len)
        code_end = findPattern(";",file,close_paren,len)
        true_code = file[close_paren:code_end]

        return code_end,if_else_block(condition,true_code,hasElse(file,code_end))
    
    elseif findPattern(";",file,close_paren,len) < findPattern("{",file,close_paren,len)
        code_end = findPattern(";",file,close_paren+1,len)
        true_code = file[close_paren+1:code_end]

        return code_end,if_else_block(condition,true_code,hasElse(file,code_end))

    # get code in between braces
    else 
        code_start = findPattern("{",file,close_paren,len)
        code_end = findPattern("}",file,code_start,len)

        true_code = file[code_start:code_end]
        
        return code_end,if_else_block(condition,true_code,hasElse(file,code_end))
    end
end

function getElseBlock(file::String,i::Int)
    len = length(file)

    # find the end of the else keyword
    code_start = findPattern("else",file,i,len)

    # if you find a { before a alphanumeric char, then they are for that if
    brace_dex = findPattern("{",file, code_start, len)
    if ( brace_dex > len)
        code_end = findPattern(";",file,code_start,len)
        true_code = file[code_start+4:code_end]

        return code_end,else_block(true_code)
    
    # if a semicolon is before a brace, then there are no braces
    elseif findPattern(";",file,code_start,len) < findPattern("{",file,code_start,len)
        code_end = findPattern(";",file,code_start,len)
        true_code = file[code_start+4:code_end]

        return code_end,else_block(true_code)

    # get code in between braces
    else
        code_start = findPattern("{",file,code_start,len)
        code_end = findPattern("}",file,code_start,len)

        true_code = file[code_start:code_end]
        
        return code_end,else_block(true_code)
    end
end

# finds the end of a control block and inits it
# this code assumes it starts right after the if statement
function initBlock(file::String, i::Int, typ::String)
    # find the end of the block
    len = length(file)
    # get the condition and the code if true
    if (typ == "if")
        return getIfBlock(file,i)
    elseif (typ == "else if")
        return getElseIfBlock(file,i)
        

    elseif (typ == "else")
        return getElseBlock(file,i)

    else 
        throw(ArgumentError("Block type not recognized"))
    end
end

# first, count the number of control blocks, allocate the array
# then return it after filling it with the proper contents
function parseCpp(file_contents::String)

    file_contents = filterComments(file_contents)

    #num_of_blocks::Int64 = getControlBlockNum(file_contents)

    i=1
    times = 1
    output = []
    i,block_type = findBlock(file_contents,i)

    # go until you hit the end of the file
    while block_type != "done"

        block = initBlock(file_contents,i,block_type)
        push!(output,block)
        i,block_type = findBlock(file_contents,i+1)
    end
    
    return output

end