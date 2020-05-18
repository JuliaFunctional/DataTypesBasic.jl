struct Identity{T}
  value::T
end
# == controversy https://github.com/JuliaLang/julia/issues/4648
Base.:(==)(a::Identity, b::Identity) = a.value == b.value

function Base.show(io::IO, x::Identity)
  print(io, "Identity($(repr(x.value)))")
end

isidentity(::Identity) = true
isidentity(other) = false


Base.get(a::Identity) = a.value
Base.eltype(::Type{<:Identity{T}}) where T = T
Base.eltype(::Type{<:Identity}) = Any

Base.iterate(a::Identity) = a.value, nothing
Base.iterate(a::Identity, state) = state
Base.foreach(f, a::Identity) = begin f(a); nothing; end
Base.map(f, a::Identity) = Identity(f(a.value))
Base.Iterators.flatten(a::Identity) = convert(Identity, a.value)

# Identity is covariate
Base.convert(::Type{Identity{T}}, x::Identity) where {T} = Identity(Base.convert(T, x.value))
promote_rule(::Type{Identity{T}}, ::Type{Identity{S}}) where {T, S<:T} = Identity{T}

# we need this for safety, if someone overwrites typejoin for Unions with Identiy
Base.typejoin(::Type{Identity{T}}, ::Type{Identity{T}}) where T = Identity{T}
Base.typejoin(::Type{<:Identity}, ::Type{<:Identity}) = Identity
