# we don't use Some because it does not behave like a container, but more like `Ref`
# for details/update see https://github.com/JuliaLang/julia/issues/35911
const Option{T} = Union{Nothing, Identity{T}}

Option{T}(a::Nothing) where T = nothing
Option{T}(a::T) where T = Identity{T}(a)
Option(a::Nothing) = nothing
Option(a::T) where T = Identity{T}(a)
Option{T}() where T = nothing
Option() = nothing

# we don't need any extra typejoin rules, as they are already provided by Base.promote_typejoin


"""
overwrite `Base.:(==)` and `Base.hash` for `Base.Some`

as the default version is uninuitive and leads to surprising errors if you have the same intuition as me

Unfortunately this may breaks existing Julia code, but the semantics of Some is more a container, then a `Ref`.
For further discussion see https://discourse.julialang.org/t/is-this-a-bug-some-some/39541
"""

Base.:(==)(a::Some, b::Some) = a.value == b.value
Base.hash(a::Some) = hash(a.value)

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
