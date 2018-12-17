#syntax and feature tests

function main()

    test = Array{Int}(undef,100) 

    for n in 1:100
        test[n] = n*2
        println(test[n])
    end


end

main()