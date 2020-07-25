# we don't use Some because it does not behave like a container, but more like `Ref`
# for details/update see https://github.com/JuliaLang/julia/issues/35911

"""
    Option{T} = Union{Const{Nothing}, Identity{T}}
    Option(nothing) == Const(nothing)
    Option("anything but nothing") == Identity("anything but nothing")
    Option() == Const(nothing)

Like `Union{T, Nothing}`, however with container semantics. While `Union{T, Nothing}` can be thought of like
a value which either exists or not, `Option{T} = Union{Identity{T}, Const{Nothing}}` is a container which
is either empty or has exactly one element.

We reuse [`Identity`](@ref) as representing the single-element-container and `Const(nothing)` as the empty container.
"""
const Option{T} = Union{Const{Nothing}, Identity{T}}

Option{T}(::Nothing) where T = Const(nothing)
Option{T}(a::T) where T = Identity{T}(a)
Option(::Nothing) = Const(nothing)
Option(a::T) where T = Identity{T}(a)
Option{T}() where T = Const(nothing)
Option() = Const(nothing)


"""
    iftrue(bool_condition, value)
    iftrue(func, bool_condition)
    iftrue(bool_condition) do
      # only executed if bool_condition is true
    end

Helper to create an Option based on some condition. If `bool_condition` is
true, the function `func` is called with no arguments, and its result wrapped into `Identity`.
If `bool_condition` is false, `Option()` is returned.
"""
function iftrue(func::Function, b::Bool)
  b ? Identity(func()) : Const(nothing)
end
function iftrue(b::Bool, t)
  b ? Identity(t) : Const(nothing)
end

"""
    iffalse(bool_condition, value)
    iffalse(func, bool_condition)
    iffalse(bool_condition) do
      # only executed if bool_condition is true
    end

Helper to create an Option based on some condition. If `bool_condition` is
false, the function `func` is called with no arguments, and its result wrapped into `Identity`.
If `bool_condition` is true, `Option()` is returned.

Precisely the opposite of [`iftrue`](@ref).
"""
function iffalse(func::Function, b::Bool)
  !b ? Identity(func()) : Const(nothing)
end
function iffalse(b::Bool, t)
  !b ? Identity(t) : Const(nothing)
end

"""
    isoption(::Const{Nothing}) = true
    isoption(::Identity) = true
    isoption(other) = false

check whether something is an [`Option`](@ref)
"""
isoption(::Const{Nothing}) = true
isoption(::Identity) = true
isoption(other) = false


"""
    issome(::Identity) = true
    issome(::Const{Nothing}) = false

Similar to [`isright`](@ref), but only defined for `Const{Nothing}`. Will
throw MethodError when applied on other `Const`.
"""
issome(::Identity) = true
issome(::Const{Nothing}) = false

"""
    isnone(::Identity) = false
    isnone(::Const{Nothing}) = true

Similar to [`isleft`](@ref), but only defined for `Const{Nothing}`. Will
throw MethodError when applied on other `Const`.
"""
isnone(::Identity) = false
isnone(::Const{Nothing}) = true


Base.eltype(::Type{Option{T}}) where {T} = T
Base.eltype(::Type{Option}) = Any
