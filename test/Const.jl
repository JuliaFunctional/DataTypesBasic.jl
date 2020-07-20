using DataTypesBasic
using Test
using Suppressor

@test map(Const(3)) do x
  x*x
end == Const(3)

@test isconst(Const(3))
@test !isconst(Identity(3))

@test repr(Const(4)) == "Const(4)"

@test collect(Const(4)) == []

@test eltype(Const(nothing)) == Any

@test Iterators.flatten(Const(5)) == Const(5)

@test @capture_out(foreach(println, Const(5))) == ""
