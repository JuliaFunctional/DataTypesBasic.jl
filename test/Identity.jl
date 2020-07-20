using DataTypesBasic
using Suppressor

@test map(Identity(3)) do x
  x + 4
end == Identity(3 + 4)

@test repr(Identity(4)) == "Identity(4)"

@test eltype(Identity("hello")) == String
@test eltype(Identity{Int}) == Int

@test collect(Identity(1)) == [1]

@test isidentity(Identity(4))
@test !isidentity(Const(3))

@test Iterators.flatten(Identity(Identity(5))) == Identity(5)
# special support for Const:
@test Iterators.flatten(Identity(Const(5))) == Const(5)

@test @capture_out(foreach(print, Identity(5))) == "5"
