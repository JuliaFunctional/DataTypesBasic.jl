# DataTypesBasic

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaFunctional.github.io/DataTypesBasic.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://JuliaFunctional.github.io/DataTypesBasic.jl/dev)
[![Build Status](https://github.com/JuliaFunctional/DataTypesBasic.jl/workflows/CI/badge.svg)](https://github.com/JuliaFunctional/DataTypesBasic.jl/actions)
[![Coverage](https://codecov.io/gh/JuliaFunctional/DataTypesBasic.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaFunctional/DataTypesBasic.jl)

This package defines julia implementations for the common types `Option` (aka `Maybe`), `Either` and `Try`, as well as one extra type `ContextManager` which mimics Python's `with`-ContextManager.


## Usage

Here an example using `Try` to handle errors programmatically. Similar to `Option`, a `Try` is either a `Const`, denoting an error, or an `Identity`
value, which denotes success.

```julia
using DataTypesBasic  # defines Try

@Try div(1, 0)  # Const(Thrown(DivideError()))
@Try div(8, 3)  # Identity(2)
```

Using another helper package [`Monadic`](https://github.com/JuliaFunctional/Monadic.jl/tree/main). We can combine these
into nice syntax.
```julia
using Monadic  # defines @monadic

# flatmap is also defined in TypeClasses.jl
flatmap(f, x) = Iterators.flatten(map(f, x))
tryit = @monadic map flatmap begin
  a = @Try div(8, 3)
  b = @Try isodd(a) ? 100 + a : error("fail")
  @pure a, b
end
# Const(Thrown(ErrorException("fail")))
```

For more details check out the [documentation](https://JuliaFunctional.github.io/DataTypesBasic.jl/dev/).
