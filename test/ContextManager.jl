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
@test eltype(typeof(cm())) == Int
@test eltype(ContextManager) == Any


empty!(logging)
@test run(cm(1)) == 1
@test logging == ["before 1", "after 1"]

empty!(logging)
@test run(x -> 3x, cm(2)) == 6
@test logging == ["before 2", "after 2"]

empty!(logging)
@test foreach(x -> push!(logging, "x = $x"), cm(2)) == nothing
@test logging == ["before 2", "x = 2", "after 2"]


# FunctorApplicativeMonad
# =======================

cm_cm = map(x -> cm(x*x), cm())

# TODO check why the typeinference is worse now
# @test Out(cm_cm, typeof(x -> x)) <: ContextManager
empty!(logging)
@test Iterators.flatten(cm_cm)(x->x) == 16
@test logging == ["before 4", "before 16", "after 16", "after 4"]
