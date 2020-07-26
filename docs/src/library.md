```@meta
CurrentModule = DataTypesBasic
```

# Public API

```@index
```

## Identity

```@docs
Identity
isidentity
```

## Const

```@docs
Const
Base.isconst(::Const)
```

## Option

```@docs
Option
isoption
issome
isnone
iftrue
iffalse
getOption
```

## Either

```@docs
Either
iseither
isleft
isright
either
@either
getleft
getright
getleftOption
getrightOption
```

## Try

```@docs
Try
@Try
@TryCatch
istry
issuccess
isfailure
```

## ContextManager
```@docs
ContextManager
@ContextManager
```
