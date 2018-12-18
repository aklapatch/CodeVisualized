include("cairoWrapper.jl")

y = initCairo(300.0,200.0)
setLineWidthCairo(y,2.0)
drawRectCairo(y,.25,.25,50.0,50.0)
drawTextCairo(y, 40.0, 40.0, 20.0,"Sans", "Julia wrapper for Cairo")
drawDiamondCairo(y,100.0,100.0,50.0,50.0)
drawRelLineCairo(y,40.0,40.0,200.0,100.0)
destroyCairo(y)