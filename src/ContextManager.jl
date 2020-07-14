"""
As ContextManager we denote a computation which has a pre-computation and possibly a cleaning up step
when run with x->x it is supposed to return x.
"""

"""
function which expects one argument, which itself is a function. Think of it like the following:
```
function contextmanagerready(cont)
  # ... do something before
  value = ... # create some value to work on later
  result = cont(value)  # pass the value to the continuation function (think like `yield`)
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

# ContextManager is just a wrapper
# pass through function call syntax
(c::ContextManager)(cont) = c.f(cont)
Base.run(cont, c::ContextManager) = c(cont)
Base.run(c::ContextManager) = c(identity)


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

Iterators.flatten(contextmanager::ContextManager) = @ContextManager cont -> begin
  # execute both nested ContextManagers in the nested manner
  contextmanager() do inner_contextmanager
    convert(ContextManager, inner_contextmanager)(cont)
  end
end
