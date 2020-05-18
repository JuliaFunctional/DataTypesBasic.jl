# conversions among Identity, Option, Try, Either, Vector
# =======================================================

# Vector
Base.convert(::Type{<:Vector}, x::Identity) = [x.value]
Base.convert(::Type{<:Vector}, x::Nothing) = []
Base.convert(::Type{<:Vector}, x::Stop) = []

# Stop
Base.convert(::Type{<:Stop}, x::Nothing) = Stop(nothing)
function Base.convert(::Type{Stop}, x::Vector)
  @assert !isempty(x) "can only convert empty Vector to Nothing, got $(x)"
  Stop([])
end

# Nothing
function Base.convert(::Type{Nothing}, x::Vector)
  @assert !isempty(x) "can only convert empty Vector to Nothing, got $(x)"
  nothing
end

# Identity
# Nothing and Stop are just passed through when asked to convert to identity
Base.convert(::Type{Identity}, x::Union{Nothing, Stop}) = x
