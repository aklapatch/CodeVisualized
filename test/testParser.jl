include("parseCpp.jl")

function  main()
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

    
    output = parseCpp(code)
    
    for block in output
        
        println(block[2].true_code)
        
    end

end

main()

