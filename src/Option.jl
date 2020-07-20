# we don't use Some because it does not behave like a container, but more like `Ref`
# for details/update see https://github.com/JuliaLang/julia/issues/35911
const Option{T} = Union{Const{Nothing}, Identity{T}}

Option{T}(::Const{Nothing}) where T = Const(nothing)
Option{T}(::Nothing) where T = Const(nothing)
Option{T}(a::T) where T = Identity{T}(a)
Option(::Const{Nothing}) = Const(nothing)
Option(::Nothing) = Const(nothing)
Option(a::T) where T = Identity{T}(a)
Option{T}() where T = Const(nothing)
Option() = Const(nothing)


function iftrue(func::Function, b::Bool)
  b ? Identity(func()) : Const(nothing)
end
function iftrue(b::Bool, t)
  b ? Identity(t) : Const(nothing)
end
function iffalse(func::Function, b::Bool)
  !b ? Identity(func()) : Const(nothing)
end
function iffalse(b::Bool, t)
  !b ? Identity(t) : Const(nothing)
end

isoption(::Const{Nothing}) = true
isoption(::Identity) = true
isoption(other) = false


Base.eltype(::Type{Option{T}}) where {T} = T
Base.eltype(::Type{Option}) = Any
