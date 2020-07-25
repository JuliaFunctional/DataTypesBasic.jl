# DataTypesBasic.jl

This package defines julia implementations for the common types `Option` (aka `Maybe`), `Either` and `Try`, as well as one extra type `ContextManager` which mimics Python's `with`-ContextManager.


## Installation

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


## Manual Outline

```@contents
Pages = ["manual.md"]
```

## [Library Index](@id main-index)

```@index
Pages = ["library.md"]
```
