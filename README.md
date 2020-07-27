# DataTypesBasic

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaFunctional.github.io/DataTypesBasic.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://JuliaFunctional.github.io/DataTypesBasic.jl/dev)
[![Build Status](https://github.com/JuliaFunctional/DataTypesBasic.jl/workflows/CI/badge.svg)](https://github.com/JuliaFunctional/DataTypesBasic.jl/actions)
[![Coverage](https://codecov.io/gh/JuliaFunctional/DataTypesBasic.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaFunctional/DataTypesBasic.jl)

This package defines julia implementations for the common types `Option` (aka `Maybe`), `Either` and `Try`, as well as one extra type `ContextManager` which mimics Python's `with`-ContextManager.


## Installation

The package is soon going to be registered at General, until then you can use it by adding a custom registry.
```julia
using Pkg
pkg"registry add https://github.com/JuliaRegistries/General"  # central julia registry
pkg"registry add https://github.com/schlichtanders/SchlichtandersJuliaRegistry.jl"  # custom registry
pkg"add DataTypesBasic"
```

Use it like
```julia
using DataTypesBasic
```

For more details check out the [documentation](https://JuliaFunctional.github.io/DataTypesBasic.jl/dev/).
