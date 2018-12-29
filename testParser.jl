include("parseCpp.jl")

function  main()
    code = """
   /* test etdthad;lkfjtashd
atdsavapsodfiuase */

if ( y < 60)
    // do stuff
    ;

else if (y > 49) 
    // do more stuff
    ;
else 
    // do most stuff
    ;

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
    # test find pattern functions
    println("newline is at index ",findPattern("\n",code,1, len))

    # filter out comments
    code_wo_comments = filterComments(code)

    i = 1 
    str = ""
    while str != "done"
        # test block finding function
        i,str = findBlock(code_wo_comments,i+1)
        println(i," ",str)
    end

    # test the if block init function
    i = 1
    i,block = getIfBlock(code_wo_comments,i)
    println(block.condition,"\ntrue code:\n",block.true_code,"\nelse statement?\n",block.has_else)

    i,block = getElseIfBlock(code_wo_comments,i+1)
    println(block.condition,"\ntrue code:\n",block.true_code,"\nelse statement?\n",block.has_else)

    i,block = getElseBlock(code_wo_comments,i+1)
    println("\ntrue code:\n",block.code,"\n")

    # try the brace versions
    i,block = getIfBlock(code_wo_comments,i)
    println(block.condition,"\ntrue code:\n",block.true_code,"\nelse statement?\n",block.has_else)

    i,block = getElseIfBlock(code_wo_comments,i+1)
    println(block.condition,"\ntrue code:\n",block.true_code,"\nelse statement?\n",block.has_else)

    i,block = getElseBlock(code_wo_comments,i+1)
    println("\ntrue code:\n",block.code,"\n")


end

main()

