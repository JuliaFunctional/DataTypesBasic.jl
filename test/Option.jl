@test issomething(Option(5))
@test !issomething(Option(nothing))
@test isnothing(Option(nothing))
@test !isnothing(Option(5))

@test iftrue(2==3) do
  54
end == Option{Int}(nothing)
@test iffalse(2==3, 54) == Option{Int}(54)
