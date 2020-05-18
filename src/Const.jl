struct Const{T}
  value::T
end

# == controversy https://github.com/JuliaLang/julia/issues/4648
Base.:(==)(a::Const, b::Const) = a.value == b.value

function Base.show(io::IO, x::Const)
  print(io, "Const($(repr(x.value)))")
end

isconst(::Const) = true
isconst(other) = false


# const just does nothing, i.e. leaves everything constant
Base.iterate(c::Const) = nothing
Base.foreach(f, c::Const) = nothing
Base.map(f, c::Const) = c
Iterators.flatten(c::Const) = c

Base.eltype(::Type{<:Const}) = Any

# Const is covariate
Base.convert(::Type{Const{T}}, x::Const) where {T} = Const(Base.convert(T, x.value))
promote_rule(::Type{Const{T}}, ::Type{Const{S}}) where {T, S<:T} = Const{T}

# we need this for safety, if someone overwrites typejoin for Unions with Const
Base.typejoin(::Type{Const{T}}, ::Type{Const{T}}) where T = Const{T}
Base.typejoin(::Type{<:Const}, ::Type{<:Const}) = Const
