# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.0.0] - 2021-07-15
### Added
- `Base.get` and `Base.getindex` are now both implemented for `Const` (like they are implemented already for `Identity`), to simplify working with `Const`.
- Vector conversions (`convert`) are now more generic and support AbstractArray in general 

### Fixed
- `Option(3)` works now
- The constructors `Const{ElementType}(value)` and `Identity{ElementType}(value)` had been removed already, however were still used. Maybe this now gave errors because of newer julia version, don't know, but now everything uses `Const(value)` and `Identity(value)` instead.
- fixed a couple of disambiguation errors which magically appeared after switching to Julia 1.6

### Changed
- Thrown now parameterises also the type of the stacktrace. This is going to change in upcoming julia version 1.7.

### Removed
- `Option{T}(value::T)` didn't work and is removed now, as it does not provide any benefit anylonger, which is a breaking change
- `Option{T}()` is also removed for completeness, which is a breaking change
- `Const` no longer converts to `Identity`. This was added originally so that a `Const` nested within an `Identity` can be flattened. However, there is a better alternative, namely now the `flatmap` operator on `Identity` just strips away the outer Identity, without any call to `convert`. This is simpler and more convenient approach which also makes the hacky conversion no longer needed. This is a breaking change.

## [1.0.0] - 2020-07-19
### Added
- CI via GitHubActions
- Documentation via Documenter.jl and GitHubActions
- Codecoverage via GitHubActions and Codecov
- extensive Testing
- TagBot and CompatHelper GitHubActions
- extensive `promote_rule` and `promote_typejoin` implementations have been added for Identity,
  Const, Option, Either, OptionEither.
- `@either` macro with which you can construct `Either` using ? operator or if-else.

### Changed
- Option is now represented as Union of Identity and Const{Nothing}
- Either is now represented as `Union` of Identity and Const
- Try is now represented as `Union` of Identity and Const{<:Exception}
- flatten in general is now unified to use `convert` for interoperability between similar
  container types
- flatten of ContextManager is again reverted back to not use `FlattenMe` anymore. Instead the
  inner result value is explicitly converted to `ContextManager`, following the general principle
  now.

### Fixed
- foreach for Identity is fixed
- convert for Identity and Const preserves the container type now
- equality == for Thrown works now
- promote_type for Either (was too imprecise)

## [0.3.0] - 2020-03-23
### Changed
- flatten on ContextManager is now realised at runtime (the reason was that inaccurate typeinference could not be resolved for ContextManager before). Concretely, if you call `Iterators.flatten(...)` on the ContextManager, a tag `FlattenMe` will be mapped onto the ContextManager. When the ContextManager is run, then a FlattenMe result will be further flattened out. Note that this wrapper is also applied to non-contextmanager types for advanced later flattening of complex nested flatten structures.

### Fixed
- typeinference for Option, Try, Either is now massively improved

## [0.2.0] - 2020-03-06

initial release
