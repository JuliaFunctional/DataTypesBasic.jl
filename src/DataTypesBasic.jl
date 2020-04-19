"""
NOTE: in julia we can represent closed abstract types with two different systems:
1. either Union{Type1, Type2}
2. or with a standard abstract type, where all type definitions are on the abstract type level
  (if you would only define functions on the concretetypes, the the inference engine will do weird things
   as it assumes there might be another concretetype in the future)

Approach 1.
===========

Advantages: Providing definitions for the concrete is actually enough for typeinference
Disadvantages: The typeinference like for ``Dict(:a => Some(1), :b => None())`` would infer
  ``Dict{Symbol, Any}`` instead of `Dict{Symbol, Union{Some, None}}`.

  The internal details for this is that in many cases `Base.promote_typejoin(type1, type2)` is used to come up
  with a common type.
  While the type hierarchy is used for this, `Base.promote_typejoin` of two unrelated types will always result in `Any`.


Approach 2.
===========

Advantages: ``Dict(:a => Some(1), :b => None())`` would indeed infer ``Dict{Symbol, Option}``
Disadvantages: you need to be careful to always implement functionalities first on separate functions unique to the
  sealed type, and then point generic functions to the specific one via `genericfunction(o::Option) = optionfunction(o)`

As Approach 2 is best with typeinference currently, and the overhead is at least restricted to kind-of-internal
functions, we go with Approach 2. That applies to Option, Try and Either.
"""
module DataTypesBasic

export @overwrite_Base, @overwrite_Some,
  Const,
  Identity,
  Option, None, Some, issomething, iftrue, iffalse, getOption, # isnothing comes from Base
  Either, Left, Right, either, isleft, isright, getleft, getright, getleftOption, getrightOption, getEither,
  Try, Success, Failure, @Try, @TryCatch, issuccess, isfailure, MultipleExceptions,
  ContextManager, @ContextManager

using IsDef

include("Const.jl")
include("Identity.jl")
include("Option.jl")
include("Try.jl")
include("Either.jl")
include("ContextManager.jl")

macro overwrite_Base()
  esc(quote
    const Some = DataTypesBasic.Some
    nothing
  end)
end

macro overwrite_Some()
  esc(quote
    const Some = DataTypesBasic.Some
    nothing
  end)
end

end # module
