Manual
======

This package defines julia implementations for the common types `Option` (aka `Maybe`), `Either` and `Try`, as well as
one extra type `ContextManager` which mimics Python's `with`-ContextManager.

Unlike typical implementations of `Option`, and `Either` which define them as new separate
type-hierarchies, in `DataTypesBasic` both actually share a common parts: `Identity` and `Const`.


Identity
--------

`Identity` is the most basic container you can imagine. It just contains one value and always one value. It is similar
to `Base.Some`, however with one notable difference. While `Some([]) != Some([])` (because it is treated more
like `Ref`), for `Identity` we have `Identity([]) == Identity([])`, as `Identity` works like a Container.

```jldoctest
julia> a = Identity(3)
Identity(3)
julia> map(x -> 2x, a)
Identity(6)
julia> foreach(println, a)
3
julia> for i in Identity("hello")
         print("$i world")
       end
hello world
```

Think of `Identity` as lifting a value into the world of containers. `DataTypesBasic` knows a lot about how to convert
an `Identity` container to a `Vector` or else. This will come in handy soon. For now it is important to understand
that wrapping some value `42` into `Identity(42)` makes it interactable on a container-level.


Const
-----

`Const` looks like `Identity`, but behaves like an empty container. Its name suggests that whatever is in it will stay
**const**ant. Alternatively, it can also be interpreted as aborting a program. Use `Const(nothing)` to represent an empty Container. `Const(...)` is in this sense an empty container with additional information.

```julia
struct Identity{T}
  value::T
end
struct Const{T}
  value::T
end
```

```jldoctest
julia> a = Const(3)
Const(3)
julia> map(x -> 2x, a)
Const(3)
julia> foreach(println, a)

julia> for i in Identity("hello")
         print("$i world")
       end

```

*******

Option
-------

Option is a container which has either 1 value or 0. Having `Identity` and `Const{Nothing}` already at hand, it is defined as
```julia
Option{T} = Union{Identity{T}, Const{Nothing}}
```

Use it like
```julia
using DataTypesBasic

fo(a::Identity{String}) = a.value * "!"
fo(a::Const{Nothing}) = "fallback behaviour"

fo(Option("hi"))  # "hi!"
fo(Option(nothing))  # "fallback behaviour"
fo(Option())  # "fallback behaviour"
```

The real power of `Option` comes from generic functionalities which you can define on it. `DataTypesBasic` already
defines the following:
`Base.iterate`, `Base.foreach`, `Base.map`, `Base.get`, `Base.Iterators.flatten`, `DataTypesBasic.iftrue`,
`DataTypesBasic.iffalse`, `Base.isnothing`, `DataTypesBasic.issomething`.
Please consult the respective function definition for details.

Here an example for such a higher level perspective
```julia
using DataTypesBasic

flatten(a::Identity) = a.value
flatten(a::Const) = a

# map a function over 2 Options, getting an option back
function map2(f, a::Option, b::Option)
  nested_option = map(a) do a′
    map(b) do b′
      f(a′, b′)
    end
  end
  flatten(nested_option)
end

map2(Option("hi"), Option("there")) do a, b
  "$a $b"
end  # Identity("hi there")

map2(Option(1), Option()) do a, b
  a + b
end  # Const(nothing)
```

The package `TypeClasses.jl` (soon to come) implements a couple of such higher level concepts of immense use
(like Functors, Applicatives and Monads).

For further details, don't hesitate to consult the source code `src/Option.jl` or take a look at the tests
`test/Option.jl`.


Either
------

`Either` is exactly like `Option ` a container which has either 1 value or 0. In addition to `Option`, the `Either`
data type captures extra information about the empty case.

As such it is defined as a union of the two types `Identity` and `Const`.
```julia
Either{Left, Right} = Union{Const{Left}, Identity{Right}}
```

It is typical to describe the `Const` part as "Left" in the double meaning of being the left type-parameter as well as
a hint about its semantics of describing the empty case, like "what is finally left". On the other hand "Right" also has
its double meaning of being the right type-parameter, and also the "the right value" in the sense of correct (no abort).


Use it like
```julia
using DataTypesBasic

fe(a::Identity{Int}) = a.value * a.value
fe(a::Const{String}) = "fallback behaviour '$(a.value)'"

fe(Either{String}(7))  # 49
fe(Either{String}("some error occured"))  # "fallback behaviour 'some error occured'"

myeither = either("error", 2 > 3, 42)
fe(myeither)  # "fallback behaviour 'error'"
```

You also have support for `Iterators.flatten` in order to work "within" Either, and combine everything correctly.
```julia
check_threshold(a) = a < 15 ? Const((a, "threshold not reached")) : Identity("checked threshold successfully")

map(check_threshold, Identity(30)) |> Iterators.flatten  # Identity("checked threshold successfully")
map(check_threshold, Identity(12)) |> Iterators.flatten  # Const((12, "threshold not reached"))
# when working within another Const, think of it as if the first abort always "wins"
map(check_threshold, Const("something different already happend")) |> Iterators.flatten  # Const("something different already happend")
```

Similar like for `Option`, there are many higher-level concepts (like Functors, Applicatives and Monads) which power
unfold also over `Either`. Checkout the package `TypeClasses.jl` (soon to come) for a collection of standard helpers
and interfaces.

For further details, don't hesitate to consult the source code `src/Either.jl` or take a look at the tests
`test/Either.jl`.


Try
----

`Try` is another special case of `Either`, where `Const` can only bear Exceptions.
```julia
Try{T} = Union{Const{<:Exception}, Identity{T}}
```

This is very handy. It gives you the possibility to work with errors just as you would do with other values, no need for
dealing with `try`-`catch`.

Use it like
```julia
using DataTypesBasic

ft(a::Identity) = a.value * a.value
ft(a::Const{<:Exception}) = "got an error '$(a.value)'"

ft(@Try 1/0)  # Inf
ft(@TryCatch ErrorException error("some error"))  # "got an error 'Thrown(ErrorException(\"some error\"))'"

ft(@TryCatch ArgumentError error("another error"))  # raises the error as normal
```

There are many higher-level concepts (like Functors, Applicatives and Monads) which power also applies to `Try`.
Checkout the package `TypeClasses.jl` (soon to come) for a collection of standard helpers and interfaces.

For further details, don't hesitate to consult the source code `src/Try.jl` or take a look at the tests
`test/Try.jl`.


*************

ContextManager
--------------

Finally there is the context-manager. It is quite separate from the others, however still one of my major containers
which I used a lot in my passed in other programming languages. For instance in Python context-managers have the extra
`with` syntax, which allows you to wrap code blocks very simply with some Initialization & Cleanup, handled by the
context-manager.

The way we represent a contextmanager is actually very compact.
"""
function which expects one argument, which itself is a function. Think of it like the following:
```julia
struct ContextManager{Func}
  f::Func
end
```
It just takes a function. However the function needs to follow some rules
```julia
function contextmanagerready_func(cont)  # take only a single argument, the continuation function `cont`
  # ... do something before
  value = ... # create some value to work on later
  result = cont(value)  # pass the value to the continuation function (think like `yield`, but call exactly once)
  # ... do something before exiting, e.g. cleaning up
  result # IMPORTANT: always return the result of the `cont` function
end
```
Now you can wrap it into `ContextManager(contextmanagerready)` and you can use all the context manager
functionalities right away.

Let's create some ContextManagers
```julia
using DataTypesBasic
context_print(value) = ContextManager(function(cont)
  println("initializing value=$value")
  result = cont(value)
  println("finalizing value=$value, got result=$result")
  result
end)

# for convenience we also provide a `@ContextManager` macro which is the same as plain `ContextManager`,
# however you can leave out the extra parantheses.
context_ref(value) = @ContextManager function(cont)
  refvalue = Ref{Any}(value)
  println("setup Ref $refvalue")
  result = cont(refvalue)
  refvalue[] = nothing
  println("destroyed Ref $refvalue")
  result
end

# we can try out a contextmanager, by providing `identity` as the continuation `cont`
context_print("value")(identity)  # 4
# initializing value=4
# finalizing value=4, got result=4

# or alternatively we can use Base.run
run(context_ref(4))  # Base.RefValue{Any}(nothing)
# setup Ref Base.RefValue{Any}(4)
# destroyed Ref Base.RefValue{Any}(nothing)
```

In a sense, these ContextManagers are a simple value with some sideeffects before and after. In functional programming
it is key to cleanly captualize such side effects. That is also another reason why Option, Either, and Try are so
common.

Using `Monadic.jl` we can actually work on ContextManagers as they would be values.
```julia
using Monadic
flatmap(f, x) = Iterators.flatten(map(f, x))
combined_context = @monadic map flatmap begin
  a = context_print(4)
  b = context_ref(a + 100)
  @pure a * b[]
end

run(combined_context)  # 416
# initializing value=4
# setup Ref Base.RefValue{Any}(104)
# destroyed Ref Base.RefValue{Any}(nothing)
# finalizing value=4, got result=416
```

As you see, the contextmanager properly nest into one-another. And everything is well captured in the background by
the `@monadic` syntax. This working pattern is very common and can also be used for `Option`, `Either` and `Try`.
The syntax is called `monadic`, as `map` and `flatmap` define what in functional programming is called a `Monad` (think
  of it as a container which knows how to flatten out itself).

The package [`TypeClasses.jl`](https://github.com/JuliaFunctional/TypeClasses.jl) captures this idea in more depth. There you can also find a syntax `@syntax_flatmap`
 which refers to exactly the above use of `@monadic`.

For further details, don't hesitate to consult the source code `src/ContextManager.jl` or take a look at the tests
`test/ContextManager.jl`.
