using DataTypesBasic
using Test


const logging = []
cm(i=4, prefix="") = @ContextManager function(cont)
  push!(logging, "$(prefix)before $i")
  result = cont(i)
  push!(logging, "$(prefix)after $i")
  result
end
@test eltype(cm()) == Int

# FunctorApplicativeMonad
# =======================

cm_cm = map(x -> cm(x*x), cm())

# TODO check why the typeinference is worse now
# @test Out(cm_cm, typeof(x -> x)) <: ContextManager
empty!(logging)
@test Iterators.flatten(cm_cm)(x->x) == 16
@test logging == ["before 4", "before 16", "after 16", "after 4"]
