include("drawFlow.jl")

function main()

    # set up a block series to test the flow drawing method
    blocks= []

    push!(blocks,String("raw string code",))

    push!(blocks,if_block("y==4","code to run",true))

    push!(blocks,if_else_block("y==7","code (else if) to run",true))

    push!(blocks,else_block("(code else) to run"))

    drawFlow(blocks,"out.svg",1.0)
end

main()