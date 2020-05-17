const Option{T} = Union{Nothing, Some{T}}

Option{T}(a::Nothing) where T = nothing
Option{T}(a::T) where T = Some{T}(a)
Option(a::Nothing) = nothing
Option(a::T) where T = Some{T}(a)
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

# we need to overwrite convert, because in the case that no conversion is possible, we currently get the super uninformative error
# ERROR: could not compute non-nothing type
# Stacktrace:
#  [1] nonnothingtype_checked(::Type) at ./some.jl:29
#  [2] convert(::Type{Union{Nothing, Some{T}} where T}, ::Int64) at ./some.jl:34
#  [3] top-level scope at none:0
# importantly, we should only add clauses for Type{Option} and not Type{<:Option} to not interfere with existing code
Base.convert(::Type{Option}, x) = throw(MethodError(Base.convert, (Option, x)))
Base.convert(::Type{Option}, x::Option) = x
# Option{T} seems to be already covered by normal Union, Some, Nothing conversions, no need to provide them

function iftrue(func::Function, b::Bool)
  b ? Some(func()) : nothing
end
function iftrue(b::Bool, t)
  b ? Some(t) : nothing
end
function iffalse(func::Function, b::Bool)
  !b ? Some(func()) : nothing
end
function iffalse(b::Bool, t)
  !b ? Some(t) : nothing
end

issomething(m::Nothing) = false
issomething(m::Some) = true

Base.get(m::Some) = m.value
Base.get(m::Nothing) = nothing

# Base.eltype is not well defined for Some, and always returns Any
Base.eltype(::Type{<:Option{T}}) where {T} = T
Base.eltype(::Type{Nothing}) = Any  # if we don't provide this clause, we get ERROR: UndefVarError: T not defined, as the above clause matches, but no T can be infered from Nothing


Base.iterate(o::Some) = o.value, nothing
Base.iterate(o::Some, state) = state
Base.iterate(o::Nothing) = nothing

Base.foreach(f, o::Some) = f(o.value); nothing
Base.foreach(f, o::Nothing) = nothing

Base.map(f, o::Some) = Some(f(o.value))
Base.map(f, ::Nothing) = nothing

Iterators.flatten(x::Nothing) = x
Iterators.flatten(x::Some) = convert(Option, x.value)
