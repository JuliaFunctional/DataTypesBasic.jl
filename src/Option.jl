# we don't use Some because it does not behave like a container, but more like `Ref`
# for details/update see https://github.com/JuliaLang/julia/issues/35911
const Option{T} = Union{Nothing, Identity{T}}

Option{T}(a::Nothing) where T = nothing
Option{T}(a::T) where T = Identity{T}(a)
Option(a::Nothing) = nothing
Option(a::T) where T = Identity{T}(a)
Option{T}() where T = nothing
Option() = nothing


function iftrue(func::Function, b::Bool)
  b ? Identity(func()) : nothing
end
function iftrue(b::Bool, t)
  b ? Identity(t) : nothing
end
function iffalse(func::Function, b::Bool)
  !b ? Identity(func()) : nothing
end
function iffalse(b::Bool, t)
  !b ? Identity(t) : nothing
end

issomething(m::Nothing) = false
issomething(m::Identity) = true

Base.eltype(::Type{Option{T}}) where {T} = T
Base.eltype(::Type{Option}) = Any
