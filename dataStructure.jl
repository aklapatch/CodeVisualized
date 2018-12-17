abstract type control_block end

mutable struct if_block <: control_block
    condition::String # condition for code to run
    true_code::String # code that runs if true
    has_else::Bool # if there is an else block or not elseifs count as else blocks
end

mutable struct if_else_block <: control_block
    condition::String # condition for code to run
    true_code::String # code that runs if true
    has_else::Bool # if there is an else block or not elseifs count as else blocks
end

mutable struct else_block <: control_block
    code::String
end