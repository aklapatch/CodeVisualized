include("dataStructure.jl")

include("parseCpp.jl")

error_message = "File extension not found"

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