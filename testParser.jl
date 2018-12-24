include("parseCpp.jl")

code = """
   /* test etdthad;lkfjtashd
atdsavapsodfiuase */

if ( y < 60)
    // do stuff

else if (y > 49) 
    // do more stuff

else 
    // do most stuff


if ( y < 32){
    // do stuff
}
else if (y > 42) {
    // do more stuff
}
else {
    // do most stuff
}
"""

len = length(code)
println("newline is at index ",findPattern("\n",code,1, len))

code_wo_comments = filterComments(code)

i,str = findBlock(code_wo_comments,1)

println(i," ",str)

i,str = findBlock(code_wo_comments,i+1)

println(i," ",str)
