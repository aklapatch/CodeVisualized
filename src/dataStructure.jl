
mutable struct IfBlock
    condition::String # condition for code to run
    true_code::String # code that runs if true
end

mutable struct IfElseBlock
    condition::String # condition for code to run
    true_code::String # code that runs if true
end

mutable struct ElseBlock
    true_code::String
end

mutable struct LogicBlock 

    # condition and code for if statement
    ifBlock::IfBlock

    nestedifBlock::LogicBlock # for code in the if statement

    # array for if elses
    ifElseBlock::Vector{IfElseBlock}

    nestedIfElseBlock::Vector{LogicBlock} # for code in if else statements

    # code for the else block
    else_code::String

    nestedElseBlock::LogicBlock
end
