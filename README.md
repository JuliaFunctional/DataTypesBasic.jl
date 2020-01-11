DataTypesBasic
--------------

This package defines julia implementations for the common types ``Option`` (aka ``Maybe``), ``Either`` and ``Try``.

Use it like
```julia
using DataTypesBasic
DataTypesBasic.@overwrite_Base
```
The macro `@overwrite_Base` assigns ``Some`` to `DataTypesBasic.Some` (this is for consisting naming [following Scala](https://www.scala-lang.org/api/current/scala/Option.html)).


Option
------

``Option{T}`` Type is like ``Union{T, Nothing}``, plus that you can dispatch on it more easily.

It is literally defined like an abstract type with two instances ``None`` and ``Some``
```julia
abstract type Option{T} end
struct None{T} <: Option{T} end
struct Some{T} <: Option{T}
  value::T
end
```
as you can see, ``None{T}`` captures the information ``"no value"`` of Type `T`, and  ``Some{T}`` guarantees to have
a value of Type `T`.

Use it like
```julia
using DataTypesBasic
DataTypesBasic.@overwrite_Base

fo(a::Some{String}) = a.value * "!"
fo(a::None{String}) = "fallback behaviour"

f(Option("hi"))  # "hi!"
f(Option{String}())  # "fallback behaviour"
# f(Option{Int}())  # not implemented
```

The real power of `Option` comes from generic functionalities which you can define on it. `DataTypesBasic` already defines the following:
`Base.iterate`, `Base.foreach`, `Base.map`, `Base.get`, `DataTypesBasic.iftrue`, `DataTypesBasic.iffalse`, `Base.isnothing`, `DataTypesBasic.issomething`. Please
consult the respective function definition for details.

Here an example for such a higher level perspective
```julia
using DataTypesBasic
DataTypesBasic.@overwrite_Base

flatten(a::Some) = a.value
flatten(a::None) = a

function map2(f, a::Option{S}, b::Option{T}) where {S, T}  # this comes
  nested_option = map(a) do a′
    map(b) do b′
      f(a′, b′)
    end
  end
  flatten(nested_option)
end

map2(Option("hi"), Option("there")) do a, b
  "$a $b"
end  # Some{String}("hi there")

map2(Option(1), Option()) do a, b
  a + b
end  # None{Any}()
```

The package ``TypeClasses.jl`` (soon to come) implements a couple of such higher level concepts of immense use
(like Functors, Applicatives and Monads).


[TODO] Try
---


[TODO] Either
------


[TODO] ContextManager
--------------


Other
-----

For abstraction purposes, there is also ``Const`` and ``Identity`` defined.
