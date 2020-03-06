using DataTypesBasic
using IsDef
const logging = []
cm(i=4, prefix="") = @ContextManager function(cont)
  push!(logging, "$(prefix)before $i")
  r = cont(i)
  push!(logging, "$(prefix)after $i")
  r
end
@test eltype(cm()) == Int
# FunctorApplicativeMonad
# =======================

cm_cm = map(x -> cm(x*x), cm())
@test Out(cm_cm, typeof(x -> x)) <: ContextManager

empty!(logging)
@test Iterators.flatten(cm_cm)(x->x) == 16
@test logging == ["before 4", "before 16", "after 16", "after 4"]
