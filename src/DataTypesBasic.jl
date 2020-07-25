"""
NOTE: in julia we can represent closed abstract types with two different systems:
1. either Union{Type1, Type2}
2. or with a standard abstract type, where all type definitions are on the abstract type level
  (if you would only define functions on the concretetypes, the the inference engine will do weird things
   as it assumes there might be another concretetype in the future)

Approach 1.
===========

Advantages: Providing definitions for the concrete is actually enough for typeinference. More code reuse.
Disadvantages: The typeinference like for `Dict(:a => Some(1), :b => None())` would infer
  `Dict{Symbol, Any}` instead of `Dict{Symbol, Union{Some, None}}`.

  The internal details for this is that in many cases `Base.promote_typejoin(type1, type2)` is used to come up
  with a common type.
  While the type hierarchy is used for this, `Base.promote_typejoin` of two unrelated types will always result in `Any`.

  You would need to overload `promote_typejoin` to support
  `Dict(:a => Identity(1), :b => nothing) isa Dict{Symbol, Option{Int}}`.


Approach 2.
===========

Advantages: `Dict(:a => Some(1), :b => None())` would indeed infer `Dict{Symbol, Option}`
Disadvantages: you need to be careful to always implement functionalities first on separate functions unique to the
  sealed type, and then point generic functions to the specific one via `genericfunction(o::Option) = optionfunction(o)`


As we managed to make the promote_typejoin work as intended for `Union`, we follow Approach 1, in order to enable way
higher code-reuse and datatype-reuse.
"""
module DataTypesBasic

export Identity, isidentity, Const,
  Option, isoption, issome, isnone, iftrue, iffalse, getOption,
  Either, either, @either, iseither, isleft, isright, getleft, getright, getOption, getleftOption, getrightOption, flip_left_right,
  Try, @Try, @TryCatch, istry, issuccess, isexception, Thrown, MultipleExceptions,
  ContextManager, @ContextManager

using Compat

# type definitions
include("Identity.jl")
include("Const.jl")
include("Option.jl")
include("Try.jl")
include("Either.jl")
include("ContextManager.jl")

# interoperability between types
include("promote_type.jl")
include("convert.jl")

end # module
