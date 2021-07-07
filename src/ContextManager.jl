@doc raw"""
    ContextManager(func)

As ContextManager we denote a computation which has a pre-computation and possibly a cleaning up step.

The single argument is supposed to be a function which expects one argument, the continuation function.
Think of it like the following:
```julia
function contextmanagerready(cont)
  # ... do something before
  value = ... # create some value to work on later
  result = cont(value)  # pass the value to the continuation function (think like `yield`)
  # ... do something before exiting, e.g. cleaning up
  result # IMPORTANT: always return the result of the `cont` function
end
```
Now you can wrap it into `ContextManager(contextmanagerready)` and you can use all the context manager
functionalities right away.

There is a simple `@ContextManager` for writing less parentheses
```julia
mycontextmanager(value) = @ContextManager function(cont)
  println("got value = $value")
  result = cont(value)
  println("finished value = $value")
  result
end
```

----------------

You can run it in two ways, either by just passing `Base.identity` as the continuation function
```julia
julia> mycontextmanager(4)(x -> x)
got value = 4
finished value = 4
```
or for convenience we also overload `Base.run`
```julia
# without any extra arguments runs the contextmanager with Base.identity
run(mycontextmanager(4))
# also works with a given continuation, which makes for a nice do-syntax
run(x -> x, mycontextmanager(4))
run(mycontextmanager(4)) do x
  x
end
```
"""
struct ContextManager{F}
  f::F
end



@doc raw"""
    @ContextManager function(cont); ...; end

There is a simple `@ContextManager` for writing less parentheses

```julia
mycontextmanager(value) = @ContextManager function(cont)
  println("got value = $value")
  result = cont(value)
  println("finished value = $value")
  result
end
```
"""
macro ContextManager(func)
  quote
    ContextManager($(esc(func)))
  end
end

# ContextManager is just a wrapper
# pass through function call syntax
(c::ContextManager)(cont) = c.f(cont)
# in principle `cont` could be anything, as anything could be a function, however we have an ambiguity with Base AbstractCmd, and as this is mainly used for do-syntax
# it should be fine to restrict to `Function` 
Base.run(cont::Function, c::ContextManager) = c(cont)
Base.run(c::ContextManager) = c(identity)


function Base.eltype(::Type{<:ContextManager{F}}) where F
  Base.promote_op((f, arg) -> f(arg), F, typeof(identity))
end
Base.eltype(::Type{<:ContextManager}) = Any

function Base.foreach(f, c::ContextManager)
  c(f)
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
