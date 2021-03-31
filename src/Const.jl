"""
    Const("anything")

DataType which behaves constant among `map`, `foreach` and the like. Just like an empty container,
however with additional information about which kind of empty.
"""
struct Const{T}
  value::T
  Const(value) = new{typeof(value)}(value)
end

# == controversy https://github.com/JuliaLang/julia/issues/4648
Base.:(==)(a::Const, b::Const) = a.value == b.value

function Base.show(io::IO, x::Const)
  print(io, "Const($(repr(x.value)))")
end

"""
    isconst(Const(3)) -> true
    isconst("anythingelse") -> false

returns true only if given an instance of  [`DataTypesBasic.Const`](@ref)
"""
Base.isconst(::Const) = true
Base.isconst(other) = false

Base.length(::Const) = 0

# as the length of Const is 0, we intentionally do not support `Base.get`

# const just does nothing, i.e. leaves everything constant
Base.iterate(c::Const) = nothing
Base.foreach(f, c::Const) = nothing
Base.map(f, c::Const) = c
Iterators.flatten(c::Const) = c

Base.eltype(::Type{<:Const}) = Any

Base.convert(::Type{Const{T}}, x::Const{T}) where {T} = x
Base.convert(::Type{Const{T}}, x::Const) where {T} = Const{T}(convert(T, x.value))

# Const is covariate
# promote_rule only works on concrete types, more general checks Type{<:Const} may overwrite
# unintentionally more specific promote_rule types
Base.promote_rule(::Type{Const{T}}, ::Type{Const{S}}) where {T, S<:T} = Const{T}
Base.promote_rule(::Type{Const{T}}, ::Type{Const}) where T = Const
Base.promote_rule(::Type{Const}, ::Type{Const}) = Const

# we need this for safety, if someone overwrites promote_typejoin for Unions with Const
Base.promote_typejoin(::Type{Const{T}}, ::Type{Const{T}}) where T = Const{T}
Base.promote_typejoin(::Type{<:Const}, ::Type{<:Const}) = Const
