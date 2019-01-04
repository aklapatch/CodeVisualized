include("cairoWrapper.jl")

# get a cr and surface
y = initCairo(200.0,400.0)
 
setLineWidthCairo(y,2.0)

drawRectCairo(y,140.0,140.0,50.0,50.0)

drawTextCairo(y,3.0, 40.0, 20.0,"Sans", "Julia wrapper for Cairo")

drawDiamondCairo(y,100.0,330.0,50.0,50.0)

drawRelLineCairo(y,40.0,200.0,200.0,100.0)

drawArrowCairo(y,60.0,130.0,30.0,50.0,270.0)

drawArrowLineCairo(y,100.0,300.0,-30.0,-30.0,10.0,10.0)

destroyCairo(y)