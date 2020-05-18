"""
wrapper to indicate that a computation should stop, including information about the stop
"""
struct Stop{T}
  value::T
end
# Stop with no args is just nothing
Stop() = nothing

# == controversy https://github.com/JuliaLang/julia/issues/4648
Base.:(==)(a::Stop, b::Stop) = a.value == b.value
# Stop is a non-container, hence has always eltype Any
Base.eltype(::Type{<:Stop}) = Any

isstop(::Stop) = true
isstop(other) = false
Base.iterate(e::Stop) = nothing
Base.foreach(f, x::Stop) = nothing
Base.map(f, x::Stop) = x
Iterators.flatten(x::Stop) = x

# Stop is covariate
Base.convert(::Type{Stop{T}}, x::Stop) where {T} = Stop(Base.convert(T, x.value))
promote_rule(::Type{Stop{T}}, ::Type{Stop{S}}) where {T, S<:T} = Stop{T}

# we need this for safety, if someone overwrites typejoin for Unions with Stop
Base.typejoin(::Type{Stop{T}}, ::Type{Stop{T}}) where T = Stop{T}
Base.typejoin(::Type{<:Stop}, ::Type{<:Stop}) = Stop
