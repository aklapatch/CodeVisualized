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

    b_types = Vector{Int64}(undef,3)
    b_types[1] = findPattern("if",file,i,len)
    b_types[2]= findPattern("else",file,i,len)
    b_types[3] = findPattern("else if",file,i,len)

    # find the closest block
    smallest = 1
    j = 1
    while j < 4
        if b_types[j] < b_types[smallest]
            smallest = j
        end
        j+=1
    end

    if smallest == 1
        return b_types[1],"if"

    elseif smallest == 2
        return b_types[2],"else"

    elseif smallest == 3
        return b_types[3],"else if"
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

function getIfBlock(file::String,i::Int)
    len = length(file)

    open_paren =findPattern("(",file,i,len)
    close_paren = findPattern(")",file,i,len)
    condition = file[open_paren:close_paren]
    
    # if you find a { before a alphanumeric char, then they are for that if
    brace_dex = findPattern("{",file, close_paren, len)
    if ( brace_dex > len)
        code_end = findPattern(";",file,close_paren,len)
        true_code = file[close_paren:code_end]

        # find if there is an else block
        if findBlock(file,code_end)[2] == "else"
            
            return (code_end,if_block(condition,true_code,true))
        else 
            return (code_end,if_block(condition,true_code,false))
        end
    
    elseif (all(isspace, file[close_paren:brace_dex]))
        code_end = findPattern(";",file,close_paren,len)
        true_code = file[close_paren:code_end]

        # find if there is an else block
        if findBlock(file,code_end)[2] == "else"
    
            return (code_end,if_block(condition,true_code,true))
        else 
            return (code_end,if_block(condition,true_code,false))
        end

    # get code in between braces
    else 
        code_start = findPattern("{",file,close_paren,len)
        code_end = findPattern("}",file,code_start,len)

        true_code = file[code_start:code_end]
        
        # find if there is an else block
        if findBlock(file,code_end)[2] == "else"
    
            return (code_end,if_block(condition,true_code,true))
        else 
            return (code_end,if_block(condition,true_code,false))
        end
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


    elseif (typ == "else")

    else 
        throw(ArgumentError("Block type not recognized"))
    end
end

function getIfElseBlock(file::String,i::Int)
    len = length(file)

    open_paren =findPattern("(",file,i,len)
    close_paren = findPattern(")",file,i,len)
    condition = file[open_paren:close_paren]
    
    # if you find a { before a alphanumeric char, then they are for that if
    brace_dex = findPattern("{",file, close_paren, len)
    if ( brace_dex > len)
        code_end = findPattern(";",file,close_paren,len)
        true_code = file[close_paren:code_end]

        # find if there is an else block
        if findBlock(file,code_end)[2] == "else"
            
            return (code_end,if_block(condition,true_code,true))
        else 
            return (code_end,if_block(condition,true_code,false))
        end
    
    elseif (all(isspace, file[close_paren:brace_dex]))
        code_end = findPattern(";",file,close_paren,len)
        true_code = file[close_paren:code_end]

        # find if there is an else block
        if findBlock(file,code_end)[2] == "else"
    
            return (code_end,if_block(condition,true_code,true))
        else 
            return (code_end,if_block(condition,true_code,false))
        end

    # get code in between braces
    else 
        code_start = findPattern("{",file,close_paren,len)
        code_end = findPattern("}",file,code_start,len)

        true_code = file[code_start:code_end]
        
        # find if there is an else block
        if findBlock(file,code_end)[2] == "else"
    
            return (code_end,if_block(condition,true_code,true))
        else 
            return (code_end,if_block(condition,true_code,false))
        end
    end
end

function getElseBlock(file::String,i::Int)
    len = length(file)

    open_paren =findPattern("(",file,i,len)
    close_paren = findPattern(")",file,i,len)
    condition = file[open_paren:close_paren]
    
    # if you find a { before a alphanumeric char, then they are for that if
    brace_dex = findPattern("{",file, close_paren, len)
    if ( brace_dex > len)
        code_end = findPattern(";",file,close_paren,len)
        true_code = file[close_paren:code_end]

        # find if there is an else block
        if findBlock(file,code_end)[2] == "else"
            
            return (code_end,if_block(condition,true_code,true))
        else 
            return (code_end,if_block(condition,true_code,false))
        end
    
    elseif (all(isspace, file[close_paren:brace_dex]))
        code_end = findPattern(";",file,close_paren,len)
        true_code = file[close_paren:code_end]

        # find if there is an else block
        if findBlock(file,code_end)[2] == "else"
    
            return (code_end,if_block(condition,true_code,true))
        else 
            return (code_end,if_block(condition,true_code,false))
        end

    # get code in between braces
    else 
        code_start = findPattern("{",file,close_paren,len)
        code_end = findPattern("}",file,code_start,len)

        true_code = file[code_start:code_end]
        
        # find if there is an else block
        if findBlock(file,code_end)[2] == "else"
    
            return (code_end,if_block(condition,true_code,true))
        else 
            return (code_end,if_block(condition,true_code,false))
        end
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
        return getIfElseBlock(file,i)
        

    elseif (typ == "else")
        return getElseBlock(file,i)

    else 
        throw(ArgumentError("Block type not recognized"))VH
    end
end

# first, count the number of control blocks, allocate the array
# then return it after filling it with the proper contents
function parseCpp(file_contents::String)
    delim::Char = ';'

    file_contents = filterComments(file_contents)

    #num_of_blocks::Int64 = getControlBlockNum(file_contents)

    i=1
    times = 1
    output = []
    block_tuple = findBlock(file_contents,i)

    # go until you hit the end of the file
    while block_tuple[2] != "done"

        block = initBlock(file_contents,i)
        output = vcat[output, initBlock(block_tuple[2])]
        block_tuple = findBlock(file_contents,block_tuple[1])
    end
    

    return output

end