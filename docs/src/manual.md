Manual
======

This package defines julia implementations for the common types `Option` (aka `Maybe`), `Either` and `Try`, as well as one extra type `ContextManager` which mimics Python's `with`-ContextManager.


## Option

`Option{T} = Union{Identity{T}, Nothing}`

Use it like
```julia
using DataTypesBasic

fo(a::Identity{String}) = a.value * "!"
fo(a::Nothing) = "fallback behaviour"

fo(Option("hi"))  # "hi!"
fo(Option(nothing))  # "fallback behaviour"
fo(Option())  # "fallback behaviour"
```

The real power of `Option` comes from generic functionalities which you can define on it. `DataTypesBasic` already defines the following:
`Base.iterate`, `Base.foreach`, `Base.map`, `Base.get`, `DataTypesBasic.iftrue`, `DataTypesBasic.iffalse`, `Base.isnothing`, `DataTypesBasic.issomething`. Please
consult the respective function definition for details.

Here an example for such a higher level perspective
```julia
using DataTypesBasic

flatten(a::Identity) = a.value
flatten(a::Nothing) = a

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
end  # Identity("hi there")

map2(Option(1), Option()) do a, b
  a + b
end  # nothing
```

The package `TypeClasses.jl` (soon to come) implements a couple of such higher level concepts of immense use
(like Functors, Applicatives and Monads).


## [TODO] Try

Please see the tests `test/Try.jl`.

## [TODO] Either

Please see the tests `test/Either.jl`.

## [TODO] ContextManager

Please see the tests `test/ContextManager.jl`.

## [TODO] Other

For abstraction purposes, there is also `Const` and `Identity` defined.

Please see the tests `test/Const.jl` and `test/Identity.jl` respectively.
