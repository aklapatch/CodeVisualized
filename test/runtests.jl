println("Testing...")

include("../src/drawBlocks.jl")
println("Testing drawBlocks.jl")

env = initCairo("out.svg",400.0,400.0)

setLineWidthCairo(env ,1.0)

#test a text box
drawTextBox(env, "Text that needs \n to be split up to really \n this will a   lso just serve as a test",
            10.0,10.0, true)

# draw diamond
drawTextDiamond(env,"Text that needs to be split up",
                100.0,200.0)            

destroyCairo(env)

# =============================================================================
#println("Testing drawFlow.jl")
# set up a block series to test the flow drawing method
blocks= []

code = """
/* test etdthad;lkfjtashd
atdsavapsodfiuase */

if ( y < 60)
 // do stuff
 printf(test);

else if (y > 49) 
 // do more stuff
 test = 32 + 3;
else 
 // do most stuff
 yadda ydadda yadda;

if ( y < 32){
 // do stuff


 test text for the block
}
else if (y > 42) {
 // do more stuff

 more teset text for this stuff
}
else {
 // do most stuff
 wohooo
 test text for this
}
"""