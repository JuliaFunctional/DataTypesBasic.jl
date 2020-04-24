# conversions among Identity, Option, Try, Either, Vector
# =======================================================

# Identity
Base.convert(::Type{<:Option}, x::Identity) = Option(x.value)
Base.convert(::Type{<:Try}, x::Identity) = Success(x.value)
Base.convert(::Type{<:Either}, x::Identity) = Right(x.value)
Base.convert(::Type{<:Vector}, x::Identity) = [x.value]

# Option
Base.convert(::Type{<:Vector}, x::Option) = option_asVector(x)
option_asVector(x::Some) = [x.value]
option_asVector(x::None) = []
Base.convert(::Type{<:Either}, x::Option) = option_asEither(x)
option_asEither(x::Some) = Right{Nothing}(x.value)
option_asEither(x::None{T}) where T = Left{Nothing, T}(nothing)


# Try
Base.convert(::Type{<:Option}, x::Try) = getOption(x)
Base.convert(::Type{<:Either}, x::Try) = try_asEither(x)
try_asEither(x::Success) = Right{Failure}(x.value)
try_asEither(x::Failure{T}) where T = Left{Failure, T}(x.value)
Base.convert(::Type{<:Vector}, x::Try) = try_asVector(x)
try_asVector(t::Success) = [t.value]
try_asVector(t::Failure) = []

# Either
Base.convert(::Type{<:Option}, e::Either) = getOption(e)
Base.convert(::Type{<:Vector}, e::Either) = either_asVector(e)
either_asVector(e::Right) = [e.value]
either_asVector(e::Left) = []
