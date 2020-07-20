using Test
using DataTypesBasic

@test isidentity(Option(5))
@test !isidentity(Option(nothing))
@test isconst(Option(nothing))
@test !isconst(Option(5))

@test iftrue(2==3) do
  54
end == Option{Int}()
@test iffalse(2==3, 54) == Option{Int}(54)

@test eltype(Option{Int}) == Int
@test eltype(Option) == Any
