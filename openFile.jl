include("dataStructure.jl")

function parseFile(filenames::Array{String})
    # preallocate the return array from the number of filenames
    output = Array{control_block}(undef, length(filenames))

    # go through all the files
    for file in filenames
        handle = open(file)

        
        # select parser based on file extension
        
        close(file)
    end
end