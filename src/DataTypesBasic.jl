module DataTypesBasic

export @overwrite_Base,
  Const,
  Identity,
  Option, None, Some, issomething, iftrue, iffalse, # isnothing comes from Base
  Either, Left, Right, either, isleft, isright, getleft, getright, getleftOption, getrightOption,
  Try, Success, Failure, @Try, @TryCatch, issuccess, isexception, isfailure, getOption, MultipleExceptions,
  ContextManager, @ContextManager

include("Utils.jl")
using .Utils

include("Const.jl")
include("Identity.jl")
include("Option.jl")
include("Either.jl")
include("Try.jl")
include("ContextManager.jl")

macro overwrite_Base()
  esc(quote
    const Some = DataTypesBasic.Some
  end)
end

end # module
