# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.3.0] - 2020-03-23
### Changed
- flatten on ContextManager is now realised at runtime (the reason was that inaccurate typeinference could not be resolved for ContextManager before). Concretely, if you call `Iterators.flatten(...)` on the ContextManager, a tag `FlattenMe` will be mapped onto the ContextManager. When the ContextManager is run, then a FlattenMe result will be further flattened out. Note that this wrapper is also applied to non-contextmanager types for advanced later flattening of complex nested flatten structures.

### Fixed
- typeinference for Option, Try, Either is now massively improved

## [0.2.0] - 2020-03-06

initial release
