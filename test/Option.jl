using Test
using DataTypesBasic

@test issomething(Option(5))
@test !issomething(Option(nothing))
@test isnothing(Option(nothing))
@test !isnothing(Option(5))

@test iftrue(2==3) do
  54
end == Option{Int}(nothing)
@test iffalse(2==3, 54) == Option{Int}(54)

@test eltype(Option{Int}) == Int
@test eltype(Identity{Int}) == Int
@test eltype(Option) == Any
@test eltype(Nothing) == Any
