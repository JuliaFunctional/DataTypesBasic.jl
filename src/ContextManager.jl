"""
As ContextManager we denote a computation which has a pre-computation and possibly a cleaning up step
when run with x->x it is supposed to return x.

Because Julia's typeinference is and stays inaccurate, we cannot really work with TypeTags denoting the elementtype.
The reason is that for a ContextManager there is no way to get from a ``ContextManager{ElemType=Any}`` to a
``ContextManager{ElemType=ContextManager}`` in case Any was just ContextManager. This runtime type cast is impossible
because we would have to run the contextmanager for it, which we don`t want to.

Hence we fallback to using runtime approach, and don't need the elemtype as typetag
"""

"""
function which expects one argument, which itself is a function. Think of it like the following:
```
function contextmanagerready(cont)
  # ... do something before
  value = ... # create some value to work on later
  result = cont(value)  # pass the value to the continuation function (think like ``yield``)
  # ... do something before exiting, e.g. cleaning up
  result # IMPORTANT: always return the result of the `cont` function
end
```
Now you can wrap it into `ContextManager(contextmanagerready)` and you can use all the context manager
functionalities right away
"""
struct ContextManager{F}
  f::F
end

# one pair of parantheses less
macro ContextManager(func)
  quote
    ContextManager($(esc(func)))
  end
end

"""
we denote flattening by simply checking for this wrapper when executing a ContextManager

if it is FlattenMe{ContextManager}, we will flatten it out, otherwise the FlattenMe will be output
so that other monads can flatten it later
"""
struct FlattenMe{T}
  value::T
end


# ContextManager is just a wrapper
# pass through function call syntax
# in addition we do flattening at runtime
function (c::ContextManager)(cont)
  # in words:
  # cont is the function provided from the outside,
  # i.e. think about calling this resulting context with cont=identity ``resultingcontext(identity)``

  # flattening something means that the context managers are executed in order
  # first both preparations in order (1, 2) and then both cleanups in reverse order (2, 1)
  # if no inner contextmanager is to be called, we found the inner value to return outside
  function recfunc(inner)
    if inner isa FlattenMe{<:ContextManager}
      # TODO check whether inner.value(recfunc) is lethal
      # .f should be safer, i.e. lead to less recursion
      inner.value.f(recfunc)
    else
      cont(inner)
    end
  end
  c.f(recfunc)
end


function Base.eltype(::Type{<:ContextManager{F}}) where F
  Out(apply, F, typeof(identity))
end
Base.eltype(::Type{<:ContextManager}) = Any


function Base.foreach(f, c::ContextManager)
  Base.map(f, c)(x -> x)
  nothing
end

Base.map(f, c::ContextManager) = @ContextManager cont -> begin
  c(x -> cont(f(x)))
end

# we do flatten via a mere TypeWrapper to be able to do flattening at runtime if type inference is not good enough
Iterators.flatten(c::ContextManager) = map(FlattenMe, c)
