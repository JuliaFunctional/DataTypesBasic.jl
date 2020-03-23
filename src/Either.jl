abstract type Either{L, R} end

# variable naming taken from Base.Some
struct Left{L, R} <: Either{L, R}
  value::L
end
Left{L}(x::L) where {L} = Left{L, Any}(x)
Left(x::L) where {L} = Left{L, Any}(x)
# TODO the typecast conflict with nested applications
# Left{L, R}(x::Left{L}) where {L, R} = Left{L, R}(x.value)
# Left{R}(x::Left{L}) where {L, R} = Left{L, R}(x.value)

struct Right{L, R} <: Either{L, R}
  value::R
end
Right{L}(x::R) where {L, R} = Right{L, R}(x)
Right(x::R) where {R} = Right{Any, R}(x)
# TODO the typecast conflict with nested applications
# Right{L}(x::Right{<:Any, R}) where {L, R} = Right{L, R}(x.value)

# TODO the typecast conflict with nested applications
# Either{L, R}(x::Left{L}) where {L, R} = Left{L, R}(x.value)
# Either{L, R}(x::Right{<:Any, R}) where {L, R} = Right{L, R}(x.value)
Either{L, R}(x::L) where {L, R} = Left{L, R}(x)
Either{L, R}(x::R) where {L, R} = Right{L, R}(x)
Either{L, R}(x::L) where {L, R} = Left{L, R}(x)
Either{L, R}(x::R) where {L, R} = Right{L, R}(x)

Either{L}(x::R) where {L, R} = Right{L, R}(x)
Either{L}(x::L) where {L} = Left{L, Any}(x)


# == controversy https://github.com/JuliaLang/julia/issues/4648
Base.:(==)(a::Either, b::Either) = either_compare(a, b)
either_compare(a::Right, b::Right) = a.value == b.value
either_compare(a::Left, b::Right) = false
either_compare(a::Right, b::Left) = false
either_compare(a::Left, b::Left) = a.value == b.value

# TypeClasses.unionall_implementationdetails(::Type{<:Either{L, R}}) where {L, R} = Either{L, R}
# Traits.leaftypes(::Type{Either}) = [Either{newtype(), newtype(), Left}, Either{newtype(), newtype(), Right}]
# Traits.leaftypes(::Type{Either{T}}) where T = [Either{T, newtype(), Left}, Either{T, newtype(), Right}]


function either(left_false::L, comparison::Bool, right_true::R) where {L, R}
  comparison ? Right{L, R}(right_true) : Left{L, R}(left_false)
end

flip(x::Left{L, R}) where {L, R} = Right{R, L}(x.value)
flip(x::Right{L, R}) where {L, R} = Left{R, L}(x.value)

Base.get(e::Either) = either_get(e)
either_get(e::Left) = nothing
either_get(e::Right) = e.value

getOption(e::Either) = either_getOption(e)
either_getOption(::Left{L, R}) where {L, R} = None{R}()
either_getOption(e::Right{L, R}) where {L, R} = Some{R}(e.value)

isleft(e::Either) = either_isleft(e)
either_isleft(e::Left) = true
either_isleft(e::Right) = false

isright(e::Either) = either_isright(e)
either_isright(e::Left) = false
either_isright(e::Right) = true

getleft(e::Either) = either_getleft(e)
either_getleft(e::Left) = e.value
either_getleft(e::Right) = nothing

getright(e::Either) = either_getright(e)
either_getright(e::Left) = nothing
either_getright(e::Right) = e.value

getleftOption(e::Either) = either_getleftOption(e)
either_getleftOption(e::Left{L, R}) where {L, R} = Some{L}(e.value)
either_getleftOption(e::Right{L, R}) where {L, R} = None{L}()

getrightOption(e::Either) = either_getrightOption(e)
either_getrightOption(e::Left{L, R}) where {L, R} = None{R}()
either_getrightOption(e::Right{L, R}) where {L, R} = Some{R}(e.value)

Base.convert(::Type{<:Option}, e::Either) = getrightOption(e)

Base.eltype(::Type{<:Either{L, R}}) where {L, R} = R
Base.eltype(::Type{<:Either}) = Any

Base.map(f, e::Either) = either_map(f, e)
either_map(f, x::Right{L}) where {L} = Right{L}(f(x.value))
either_map(f, x::Left{L, R}) where {L, R} = Left{L, Out(f, R)}(x.value)

Iterators.flatten(e::Either) = either_flatten(e)
either_flatten(x::Right{L, <:Either}) where {L} = x.value
either_flatten(x::Right{L, Any}) where {L} = Base.Iterators.flatten(Right{L}(x.value))
either_flatten(x::Left) = x
either_flatten(x::Left{L, E}) where {L, R, E <: Either{L, R}} = Left{L, R}(x.value)  # just to have better type support


# transform Option/Try to Either
getEither(v::Option) = option_getEither(v)
option_getEither(v::Some) = Right{Any}(v.value)
option_getEither(v::None{T}) where T = Left{Nothing, T}(nothing)

getEither(v::Try) = try_getEither(v)
try_getEither(v::Success) = Right{Any}(v.value)
try_getEither(v::Failure{T}) where T = Left{Failure, T}(v)

getEither(v::Either) = v
