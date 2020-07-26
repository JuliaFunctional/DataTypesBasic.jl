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
getOption
```

## Try

```@docs
Try
@Try
@TryCatch
istry
issuccess
isfailure
getOption
```

## ContextManager
```@docs
ContextManager
@ContextManager
```
