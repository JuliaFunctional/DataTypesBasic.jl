struct Identity{T}
  value::T
end

Base.get(a::Identity) = a.value
Base.eltype(::Type{<:Identity{T}}) where T = T
Base.eltype(::Type{<:Identity}) = Any
Base.map(f, a::Identity) = Identity(f(a.value))
Base.Iterators.flatten(a::Identity) = a.value
