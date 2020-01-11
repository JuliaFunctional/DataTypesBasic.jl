# FunctorApplicativeMonad
# =======================

@test fmap(Identity(3)) do x
  x + 4
end == Identity(3 + 4)

@test mapn(Identity(3), Identity(4)) do x, y
  x + y
end == Identity(3 + 4)

@test pure(Identity, 5) == Identity(5)

h = @syntax_fflatmap begin
  x = Identity(3)
  y = Identity(4)
  @pure x + y
end
@test h == Identity(3 + 4)

# MonoidAlternative
# =================

@test neutral(Identity{String}) == Identity("")
@test Identity("hi") ⊕ Identity("ho") == Identity("hiho")


# Sequence
# ========

@test Sequence <: traitsof(Identity{Vector{Int}})
@test !(Sequence <: traitsof(Identity{String}))
@test sequence(Identity([1,2,3,4])) == Identity.([1,2,3,4])
