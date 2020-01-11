@test issomething(Maybe(5))
@test !issomething(Maybe(nothing))
@test isnothing(Maybe(nothing))
@test !isnothing(Maybe(5))

@test iftrue(2==3) do
  54
end == Maybe{Int}(nothing)
@test iffalse(2==3, 54) == Maybe{Int}(54)


# MonoidAlternative
# =================

@test neutral(Maybe) == Maybe(nothing)

@test Maybe(3) ⊛ Maybe(4) == Maybe(3)  # take the first non-nothing
@test Maybe{Int}(nothing) ⊛ Maybe(4) == Maybe(4)  # take the first non-nothing
@test Maybe(nothing) ⊛ Maybe(4) == Maybe(4)  # take the first non-nothing

@test Maybe{String}("hi") ⊕ Maybe{String}("ho") == Maybe{String}("hiho")


# FunctorApplicativeMonad
# =======================

@test feltype(Maybe{Int}) == Int
@test feltype(Maybe{Int, Some}) == Int
@test feltype(Maybe{Int, Nothing}) == Int
@test change_eltype(Maybe{Int, Some}, Bool) == Maybe{Bool, Some}
@test change_eltype(Maybe{Int}, Bool) == Maybe{Bool}

@test fmap(Maybe(3)) do x
  x*x
end == Maybe(9)

@test fmap(Maybe(nothing)) do x
  x*x
end == Maybe(nothing)

@test mapn(Maybe(3), Maybe("hi")) do x, y
  "$x, $y"
end == Maybe("3, hi")

@test mapn(Maybe(3), Maybe(nothing)) do x, y
  "$x, $y"
end == Maybe(nothing)

h = @syntax_fflatmap begin
  a = Maybe(3)
  b = Maybe("hi")
  @pure "$a, $b"
end
@test h == Maybe("3, hi")

h = @syntax_fflatmap begin
  a = Maybe(3)
  b = Maybe(nothing)
  @pure "$a, $b"
end
@test h == Maybe{String}(nothing)


@test pure(Maybe, 4) == Maybe(4)

# Sequence
# ========

# TODO
