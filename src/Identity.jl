struct Identity{T}
  value::T
end

Base.get(a::Identity) = a.value
Base.eltype(::Type{<:Identity{T}}) where T = T
Base.eltype(::Type{<:Identity}) = Any

Base.iterate(a::Identity) = a.value, nothing
Base.iterate(a::Identity, state) = state
Base.foreach(f, a::Identity) = begin f(a); nothing; end
Base.map(f, a::Identity) = Identity(f(a.value))
Base.Iterators.flatten(a::Identity) = convert(Identity, a.value)
