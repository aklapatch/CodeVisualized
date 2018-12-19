include("cairoWrapper.jl")

# get a cr and surface
y = initCairo(200.0,400.0)
 
setLineWidthCairo(y,2.0)

drawRectCairo(y,.25,.25,50.0,50.0)

drawTextCairo(y, 40.0, 40.0, 20.0,"Sans", "Julia wrapper for Cairo")

drawDiamondCairo(y,100.0,100.0,50.0,50.0)

drawRelLineCairo(y,40.0,40.0,200.0,100.0)

drawArrowCairo(y,60.0,70.0,30.0,50.0,270.0)

destroyCairo(y)