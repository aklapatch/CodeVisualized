include("dataStructure.jl")

include("parseCpp.jl")

error_message = "File extension not found"

# iterate through the array from right to left, returning all text before the . of the file extension
function getFileExtension(filename::String)::String
    # specify global variable
    global error_message

    i::Int = length(filename)

    while i > 0
        if (filename[i-1] == '.')
            return filename[i:end]
        end

        i -= 1
    end
    return error_message
end

function parseFiles(filenames::Array{String})::AbstractArray{control_block}

    # specify global error message
    global error_message

    # preallocate the return array from the number of filenames
    output = AbstractArray{control_block,length(filenames)}

    # go through all the files
    for name in filenames
        # grab file contents for parser
        handle = open(name)

        # convert to string, the output is a array of UInt8's
        contents = String(read(handle))
        close(handle)

        # get the file extension to select parser
        ext = getFileExtension(name)

        # select parser based on file extension
        if (ext =="cpp")
            control_blocks = parseCpp(contents)
        
        else
            # if no parser was found for that file
            println("Parser not found for $name, skipping $name.")
        end
    end

    return output
end

parseFiles(["test.cpp"])