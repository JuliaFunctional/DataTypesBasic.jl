using DataTypesBasic
@test map(Const(3)) do x
  x*x
end == Const(3)
