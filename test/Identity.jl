using DataTypesBasic

@test map(Identity(3)) do x
  x + 4
end == Identity(3 + 4)

@test eltype(Identity("hello")) == String
