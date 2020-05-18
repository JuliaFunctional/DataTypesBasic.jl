# conversions among Identity, Option, Try, Either, Vector
# =======================================================

# Vector
Base.convert(::Type{<:Vector}, x::Identity) = [x.value]
Base.convert(::Type{<:Vector}, x::Nothing) = []
Base.convert(::Type{<:Vector}, x::Const) = []

# Const
Base.convert(::Type{<:Const}, x::Nothing) = Const(nothing)
function Base.convert(::Type{Const}, x::Vector)
  @assert !isempty(x) "can only convert empty Vector to Nothing, got $(x)"
  Const([])
end

# Nothing
function Base.convert(::Type{Nothing}, x::Vector)
  @assert !isempty(x) "can only convert empty Vector to Nothing, got $(x)"
  nothing
end

# Identity
# Nothing and Const are just passed through when asked to convert to identity
Base.convert(::Type{Identity}, x::Union{Nothing, Const}) = x
