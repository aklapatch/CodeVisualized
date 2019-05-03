#!/usr/bin/julia
using ArgParse

function empty(input::String)
    println(input)
end

# selects a parser based on extension, if there is a match, then that parser is
# handed the file's raw text
function selectParser(file_names)

    # get all the file extensions and select a parser based on them
    for name in file_names
        ext = getExtension(name)
        parse_function = empty
        if ext == "cpp"

        # place holder for later parsers
        elseif false


        else
            println("parser not found for $name, skipping $name .")

        end

        # open the file and hand it off to the parser
        if parse_function != empty


            try
                src_file = open(name,"r")
                contents = read(src_file,String)
                close(src_file)
                parse_function(contents)
            catch e
                
                println(sprint(showerror, e, catch_backtrace()))

            finally
            end

        end
    end
end

function getExtension(file_name::String)::String

    # get the last . and then return if the extension matches
    dot_index = findlast(isequal('.'),file_name)
    if typeof(dot_index) == Nothing
        return ""
    end

    return SubString(file_name,dot_index+1,length(file_name))
end

# iterate through the array from right to left, returning all text before the . of the file extension
function extensionMatches(filename::String,extenstion::String)::Bool

    file_ext = getExtension(filename)

    return file_ext == extenstion
end

function main(args)

    settings = ArgParseSettings("test text")

    @add_arg_table settings begin
        "-r" 
        help = "Step through all directories, scanning all files in them"
        action = :store_true

        "-o"
        help = "Specify the output file name like this -o outputFile.svg"
        arg_type = String
        default = "controlFlow.svg"

        "filenames"
        nargs = '*'
        help = " a list of files to parse"
        required = true
        
        "--ext"
        nargs = 1
        help = "file extensions to search, such as cpp, c, py, pl, jl, js, etc. Example usage: \"--ext cpp \". Only accepts one argument"
        arg_type = String
    end

    parsed_args = parse_args(args, settings)
    
    # recursive mode
    if parsed_args["r"]

        if parsed_args["ext"][1] == ""
            println("The --ext argument is required for recursive mode.")
            exit()
        end

        file_list = []
        for file_name in parsed_args["filenames"]
            if extensionMatches(file_name,parsed_args["ext"])
                push!(file_list,file_name)
            end
        end
        if length(file_list) == 0
            println("No files with the extension $(parsed_args["ext"]) were found")
        end
    
    # not recursive mode
    else
        selectParser(parsed_args["filenames"])
    end
end

# run the program
main(ARGS)