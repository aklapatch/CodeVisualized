include("drawBlocks.jl")

function main()

    env = initCairo("out.svg",400.0,400.0)

    setLineWidthCairo(env ,1.0)

    #test a text box
    drawTextBox(env, "Text that needs \n to be split up to really \n this will a             lso just serve as a test",
                10.0,10.0)


    # draw diamond
    drawTextDiamond(env,"Text that needs \n to be split up",
                    100.0,200.0)            


    destroyCairo(env)


end

main()