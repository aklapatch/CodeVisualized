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
    while i + pat_len < done
        # return the ending index of the match
        #@show(search_me[i:i+pat_len])
        if(pattern == search_me[i:i+pat_len])
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
    
    while i <= len

        # find the first occurence of a comment
        if (findPattern("//",str,i,len) < len && findPattern("//",str,i,len) < findPattern("/*",str,i,len))
            # filter out //
            j = findPattern("//",str,i,len)

            # first time
            if (output == "")
                i = findPattern("\n",str,j,len)

                if (findPattern("//", str,i,len) == len+1)
                    output = str[1:j-1] * str[i+1:len]
                else
                    output = str[1:j-1] * str[i+1:findPattern("//", str,i,len-1)-1]
                end

            else 
                i = findPattern("\n",str,j,len)

                if (findPattern("//", str,i,len) >= len)
                    output = output * str[i+1:len]
                else
                    output = output * str[i:findPattern("//", str,i,len-1)-1]
                end
                
            end
        # filter out the 
        elseif (findPattern("/*",str,i,len) < len)
            # filter out //
            j = findPattern("/*",str,i,len)

            # first time
            if (output == "")
                i = findPattern("*/",str,j,len)

                if (findPattern("/*", str,i,len) == len+1)
                    output = str[1:j-1] * str[i+2:len]
                else
                    output = str[1:j-1] * str[i+2:findPattern("/*", str,i,len-1)-1]
                end

            else 
                i = findPattern("*/",str,j,len)
                if (findPattern("/*", str,i,len) > len)
                    
                    output = output * str[i+2:len]
                else
                    println("her")
                    output = output * str[i:findPattern("/*", str,i,len-1)-1]
                end 
            end
        end
        i+=1
    end

    return output
end

# return type of block and its index in the array
function findBlock(file::String, start::Int)::(Int,String)
    i = start
    len = length(file)
    while i <= len
        # count return first if
        if (findPattern("if",file,i,len) < len)
            return (findPattern("if",file,i,len),"if")
        end

        if (findPattern("else",file,i,len) < len)

            i = findPattern("else",file,i,len) 
            
            # check for else if
            if_dex = findPattern("if",file,i,len)

            # found the else if
            if (if_dex < findPattern("\n",file,i,len))
                return (i,"else if")
                
            # is an else    
            else 
                return (i, "else")
            end
        end

        i+=1
    end
    # no blocks found
    return (i,"done")
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
    
    else if (all(isspace, file[close_paren:brace_dex]))
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
    else if (typ == "else if")

    else if (typ == "else")

    else 
        throw(ArgumentError("Block type not recognized"))
    end
end

            


# first, count the number of control blocks, allocate the array
# then return it after filling it with the proper contents
function parseCpp(file_contents::String)
    delim::Char = ';'

    file_contents = filterComments(file_contents)

    num_of_blocks::Int64 = getControlBlockNum(file_contents)

    i=1
    times = 1
    # see if there are blocks
    if (findBlock(file_contents,i)[0] == "done")
        return []

    else if (times==1)
        output = []


    

    return output

end

println(filterComments(" /*  tashdtasdh  asdl;fkj */ /*  kljh */  a"))