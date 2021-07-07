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
@test length(Const(:hi)) == 0

@test @capture_out(for i in Const(true)
  println("i = $i")
end) == ""
@test @capture_out(foreach(println, Const(5))) == ""

@test eltype(Const(nothing)) == Any

@test Iterators.flatten(Const(5)) == Const(5)

@test convert(Const{Float32}, Const(1)) == Const(Float32(1))
@test convert(Const{Number}, Const(1)) == Const(1)

@test promote_type(Const{Int}, Const{Number}) == Const{Number}
@test promote_type(Const{Int}, Const{String}) == Const
@test promote_type(Const{Int}, Const) == Const
@test promote_type(Const, Const) == Const
