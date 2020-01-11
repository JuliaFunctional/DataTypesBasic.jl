@test isright(either("hi", true, 3))
@test isright(Either{String}(3))
@test !isleft(Either{String}(3))
@test getright(Either{String}(3)) == 3
@test getleft(Either{String}(3)) == nothing
@test getrightMaybe(Either{String}(3)) == Maybe(3)
@test getleftMaybe(Either{String}(3)) == Maybe{String}(nothing)


# MonoidAlternative
# =================

# orelse
@test Either{String, Int}("hi") ⊛ Either{String, Int}(1) == Either{String, Int}(1)
@test Either{String, Int}("hi") ⊛ Either{String, Int}("ho") == Either{String, Int}("ho")

# combine
@test Either{Int, String}("hi") ⊕ Either{Int, String}("ho") == Either{Int, String}("hiho")
@test Either{Int, String}(3) ⊕ Either{Int, String}("ho") == Either{Int, String}(3)
@test Either{Int, String}("hi") ⊕ Either{Int, String}(4) == Either{Int, String}(4)

@test Either{String, Int}("hi") ⊕ Either{String, Int}("ho") == Either{String, Int}("hiho")
@test Either{String, Int}(3) ⊕ Either{String, Int}("ho") == Either{String, Int}("ho")
@test Either{String, Int}("hi") ⊕ Either{String, Int}(4) == Either{String, Int}("hi")


# FunctorApplicativeMonad
# =======================

@test feltype(Either{Int, String}) == String
@test feltype(Either{Int, String, Success}) == String
@test change_eltype(Either{Int, String, Success}, Bool) == Either{Int, Bool, Success}
@test change_eltype(Either{Int, String}, Bool) == Either{Int, Bool}


@test fmap(Either{String}(3)) do x
  x * x
end == Either{String}(9)

@test fmap(Either{String, Int}("hi")) do x
  x * x
end == Either{String, Int}("hi")

@test mapn(Either{String, Int}(2), Either{String, Int}("ho")) do x, y
  x + y
end == Either{String, Any}("ho")
# TODO we loose type information here, however it is tough to infer through the generic curry function constructed by mapn

@test mapn(Either{String, Int}("hi"), Either{String, Int}(3)) do x, y
  x + y
end == Either{String, Any}("hi")

@test mapn(Either{String, Int}("hi"), Either{String, Int}("ho")) do x, y
  x + y
end == Either{String, Any}("hi")


h = @syntax_fflatmap begin
  a = Either{String, Int}(2)
  b = Either{String, Int}(4)
  @pure a + b
end
@test h == Either{String}(6)


h = @syntax_fflatmap begin
  a = Either{String, Int}("hi")
  b = Either{String, Int}(4)
  @pure a + b
end
@test h == Either{String, Int}("hi")


h = @syntax_fflatmap begin
  a = Either{String, Int}(2)
  b = Either{String, Int}("ho")
  @pure a + b
end
@test h == Either{String, Int}("ho")


@test pure(Either{String}, 3) == Either{String}(3)
@test pure(Either, 3) == Either{Any}(3)


# Sequence
# ========
