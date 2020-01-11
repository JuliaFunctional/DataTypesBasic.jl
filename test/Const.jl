@test fmap(Const(3)) do x
  x*x
end == Const(3)
