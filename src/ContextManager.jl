# as ContextManager we denote a computation which has a pre-computation and possibly a cleaning up step
# when run with x->x it is supposed to return x

# T is the normal functor Typevariable
struct ContextManager{T, F}  # we use extra F typeparameter to have better inference support for the many callable types
  # function which expects one argument, which itself is a function.
  # Think like ContextManager being a Generator and you are passing the implementation of `yield`
  f::F
end
function ContextManager(f::F) where F
  T = Out(f, typeof(x->x))
  ContextManager{T, F}(f)
end
# TypeClasses.unionall_implementationdetails(::Type{<:ContextManager{T}}) where T = ContextManager{T}
# Traits.leaftypes(::Type{ContextManager}) = [ContextManager{newtype(), newtype()}]
# Traits.leaftypes(::Type{ContextManager{T}}) where T = [ContextManager{T, newtype()}]

# one pair of parantheses less
macro ContextManager(func)
  quote
    ContextManager($(esc(func)))
  end
end


# ContextManager is just a wrapper
# pass through function call syntax
(c::ContextManager)(cont) = c.f(cont)


Base.eltype(::Type{<:ContextManager{T}}) where T = T
Base.eltype(::Type{<:ContextManager}) = Any


function Base.foreach(f, c::ContextManager)
  Base.map(f, c)(x -> x)
  nothing
end

Base.map(f, c::ContextManager) = @ContextManager cont -> begin
  c(x -> cont(f(x)))
end

function Iterators.flatten(c::ContextManager{T, F}) where {T <: ContextManager, F}
  @ContextManager cont -> begin
    # execute both nested ContextManagers in the nested manner
    c() do cc
      cc(cont)
    end
  end
end

# TODO it is pity, but type-inference is still that bad, that we have to support the general case directly
# TODO this fails if type-inference fails for cases where we actually don't have nested ContextManagers but
# e.g. a ContextManager with an Option inside (we get an Error "objects of type Option are not callable")
function Iterators.flatten(c::ContextManager)
  @ContextManager cont -> begin
    # execute both nested ContextManagers in the nested manner
    c() do cc
      cc(cont)
    end
  end
end
