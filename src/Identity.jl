"""
    Identity(:anything)

Identity is a simple wrapper, which works as a single-element container.

It can be used as the trivial Monad, and as such can be helpful in monadic
abstractions. For those who don't know about Monads, just think of it like
container-abstractions.
"""
struct Identity{T}
  value::T
  Identity(value) = new{typeof(value)}(value)
end
# == controversy https://github.com/JuliaLang/julia/issues/4648
Base.:(==)(a::Identity, b::Identity) = a.value == b.value

function Base.show(io::IO, x::Identity)
  print(io, "Identity($(repr(x.value)))")
end

"""
    isidentity(Identity(3)) -> true
    isidentity("anythingelse") -> false

returns true only if given an instance of  [Identity](@ref)
"""
isidentity(::Identity) = true
isidentity(other) = false

Base.length(::Identity) = 1

Base.get(a::Identity) = a.value
Base.getindex(a::Identity) = a.value

Base.eltype(::Type{<:Identity{T}}) where T = T
Base.eltype(::Type{<:Identity}) = Any

Base.iterate(a::Identity) = a.value, nothing
Base.iterate(a::Identity, state::Nothing) = state
Base.foreach(f, a::Identity) = begin f(a.value); nothing; end
Base.map(f, a::Identity) = Identity(f(a.value))
# for convenience, Identity does not use convert, whatever monad is returned is valid, providing maximum flexibility.
Base.Iterators.flatten(a::Identity) = a.value

Base.convert(::Type{Identity{T}}, x::Identity{T}) where {T} = x
Base.convert(::Type{Identity{T}}, x::Identity) where {T} = Identity(convert(T, x.value))

# Identity is covariate
# promote_rule only works on concrete types, more general checks Type{<:Const} may overwrite
# unintentionally more specific promote_rule types
Base.promote_rule(::Type{Identity{T}}, ::Type{Identity{S}}) where {T, S<:T} = Identity{T}
Base.promote_rule(::Type{Identity{T}}, ::Type{Identity}) where T = Identity
Base.promote_rule(::Type{Identity}, ::Type{Identity}) = Identity

# we need this for safety, if someone overwrites typejoin for Unions with Identiy
Base.promote_typejoin(::Type{Identity{T}}, ::Type{Identity{T}}) where T = Identity{T}
Base.promote_typejoin(::Type{<:Identity}, ::Type{<:Identity}) = Identity
