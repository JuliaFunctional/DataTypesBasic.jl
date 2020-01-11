@test issuccess(@Try 5)
@test !issuccess(@Try error("hi"))
@test isexception(@Try error("hi"))
@test !isexception(@Try 5)

@test Try(ErrorException("hi")) == @Try error("hi")
@test Try{Int}(ErrorException("hi")) == @Try Int error("hi")


me = MultipleExceptions(ErrorException("hi"))
@test me.exceptions == [ErrorException("hi")]
@test MultipleExceptions(me, ErrorException("ho")).exceptions == [ErrorException("hi"), ErrorException("ho")]


# MonoidAlternative
# =================

# combine Exceptions
@test neutral(Exception) == MultipleExceptions()
@test ErrorException("hi") ⊕ ErrorException("ho") == MultipleExceptions(ErrorException("hi"), ErrorException("ho"))

# orelse Try
@test Try(3) ⊛ Try(4) == Try(3)  # take the first non-ErrorException("error")
@test Try{Int}(ErrorException("error")) ⊛ Try(4) == Try(4)  # take the first non-ErrorException("error")
@test Try(ErrorException("error")) ⊛ Try(4) == Try(4)  # take the first non-ErrorException("error")

# combine Try
@test Try("hi") ⊕ Try("ho") == Try("hiho")
@test Try{Int}(ErrorException("error")) ⊕ Try(4) == Try{Int}(ErrorException("error"))
@test Try{Int}(ErrorException("error")) ⊕ Try{Int}(ErrorException("exception")) == Try{Int}(MultipleExceptions(ErrorException("error"), ErrorException("exception")))


# FunctorApplicativeMonad
# =======================

@test feltype(Try{Int}) == Int
@test feltype(Try{Int, Success}) == Int
@test feltype(Try{Int, Exception}) == Int
@test change_eltype(Try{Int, Success}, Bool) == Try{Bool, Success}
@test change_eltype(Try{Int}, Bool) == Try{Bool}

@test fmap(Try(3)) do x
  x*x
end == Try(9)

@test fmap(Try(ErrorException("error"))) do x
  x*x
end == Try(ErrorException("error"))

@test mapn(Try(3), Try("hi")) do x, y
  "$x, $y"
end == Try("3, hi")

@test mapn(Try(3), Try(ErrorException("error"))) do x, y
  "$x, $y"
end == Try(ErrorException("error"))

h = @syntax_fflatmap begin
  a = Try(3)
  b = Try("hi")
  @pure "$a, $b"
end
@test h == Try("3, hi")

h = @syntax_fflatmap begin
  a = Try(3)
  b = Try(ErrorException("error"))
  @pure "$a, $b"
end
@test h == Try{String}(ErrorException("error"))

@test pure(Try, 4) == Try(4)


# Sequence
# ========

# TODO
