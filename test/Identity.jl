using DataTypesBasic
using Suppressor

@test map(Identity(3)) do x
  x + 4
end == Identity(3 + 4)

@test repr(Identity(4)) == "Identity(4)"

@test eltype(Identity("hello")) == String
@test eltype(Identity{Int}) == Int
@test eltype(Identity) == Any

@test collect(Identity(1)) == [1]
@test length(Identity([1,2,3,4])) == 1

@test get(Identity(42)) == 42
@test Identity(42)[] == 42

@test isidentity(Identity(4))
@test !isidentity(Const(3))

@test Iterators.flatten(Identity(Identity(5))) == Identity(5)
# special support for Const:
@test Iterators.flatten(Identity(Const(5))) == Const(5)

@test @capture_out(foreach(print, Identity(5))) == "5"
@test @capture_out(for i in Identity(5)
  print(5)
end) == "5"

@test convert(Identity{Float32}, Identity(1)) == Identity(Float32(1))
@test convert(Identity{Number}, Identity(1)) == Identity(1)

@test promote_type(Identity{Int}, Identity{Number}) == Identity{Number}
@test promote_type(Identity{Int}, Identity{String}) == Identity
@test promote_type(Identity{Int}, Identity) == Identity
@test promote_type(Identity, Identity) == Identity
