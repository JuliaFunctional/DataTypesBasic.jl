const logging = []
cm(i=4, prefix="") = @ContextManager function(cont)
  push!(logging, "$(prefix)before $i")
  r = cont(i)
  push!(logging, "$(prefix)after $i")
  r
end
@test feltype(cm()) == Int
# FunctorApplicativeMonad
# =======================

cm_cm = fmap(x -> ContextManager(cont -> cont(x*x)), cm())
@test Core.Compiler.return_type(cm_cm, Tuple{typeof(x -> x)}) <: ContextManager

empty!(logging)
@test fflatten(cm_cm)(x->x) == 16
@test logging == ["before 4", "after 4"]

@test pure(ContextManager, 3)(x -> x) == 3

# combining ContextManager with other monads
# ------------------------------------------

# ContextManager as main Monad

empty!(logging)
cm2 = @syntax_fflatmap begin
  i = cm()
  v = [i, i+1, i+3]
  @pure v + 2
end
@test cm2(x -> x) == [6,7,9]
@test logging == ["before 4", "after 4"]


# ContextManager as sub monad

empty!(logging)
h = @syntax_fflatmap begin
  i = [1,2,3]
  c = cm(i)
  @pure c + 2
end
@test h == [3, 4, 5]
@test logging == ["before 1", "after 1", "before 2", "after 2", "before 3", "after 3"]


# TODO this monadic expression is especially slow... try to understand why this is so
# this is enormously slow...
# even after precompilation...
# maybe this is because a global variable is adapted...
# or maybe this is because cm(i, "i") creates a new ContextManager for which the whole typeinference has to be done again

empty!(logging)
h = @syntax_fflatmap begin
  i = [1,2,3]
  c = cm(i, "i ")
  j = [c, c*c]
  c2 = cm(j, "j ")
  @pure c + c2
end

@test h == [2, 2, 4, 6, 6, 12]
@test logging == ["i before 1",
  "j before 1",
  "j after 1",
  "j before 1",
  "j after 1",
  "i after 1",
  "i before 2",
  "j before 2",
  "j after 2",
  "j before 4",
  "j after 4",
  "i after 2",
  "i before 3",
  "j before 3",
  "j after 3",
  "j before 9",
  "j after 9",
  "i after 3"]
