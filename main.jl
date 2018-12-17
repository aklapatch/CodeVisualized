using ArgParse

function parseArgs()
    settings = ArgParseSettings()

    @add_arg_table settings begin
        "-r" 
        help = "Step through all directories, scanning all files in them"
        action = :store_true

        "--filter"
        help = "file extensions to search, such as cpp, c, py, pl, jl, js, etc. Example usage: \"--filter cpp c\""
        arg_type = String
        required = true

        "-o"
        help = "Specify the output file name like this -o outputFile.svg"
        arg_type = String
        default = "controlFlow.svg"

        "filenames"
        help = " a list of files to parse"
        required = true
    end
    return parse_args(settings)
end

function main()
    args = parseArgs()
    for (arg, val) in args 
        println(" $arg = $val")
    end
end

# run the program
main()