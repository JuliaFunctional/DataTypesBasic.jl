abstract type Either{L, R} end

# variable naming taken from Base.Some
struct Left{L, R} <: Either{L, R}
  value::L
end
Left{L}(x::L) where {L} = Left{L, Any}(x)
Left(x::L) where {L} = Left{L, Any}(x)

struct Right{L, R} <: Either{L, R}
  value::R
end
Right{L}(x::R) where {L, R} = Right{L, R}(x)
Right(x::R) where {R} = Right{Any, R}(x)

Either{L, R}(x::Left{L}) where {L, R} = Left{L, R}(x.value)
Either{L, R}(x::Right{<:Any, R}) where {L, R} = Right{L, R}(x.value)
Either{L, R}(x::L) where {L, R} = Left{L, R}(x)
Either{L, R}(x::R) where {L, R} = Right{L, R}(x)
Either{L}(x::R) where {L, R} = Right{L, R}(x)
Either{L}(x::L) where {L} = Left{L, Any}(x)


# == controversy https://github.com/JuliaLang/julia/issues/4648
Base.:(==)(a::Right, b::Right) = a.value == b.value
Base.:(==)(a::Left, b::Right) = false
Base.:(==)(a::Right, b::Left) = false
Base.:(==)(a::Left, b::Left) = a.value == b.value

# TypeClasses.unionall_implementationdetails(::Type{<:Either{L, R}}) where {L, R} = Either{L, R}
# Traits.leaftypes(::Type{Either}) = [Either{newtype(), newtype(), Left}, Either{newtype(), newtype(), Right}]
# Traits.leaftypes(::Type{Either{T}}) where T = [Either{T, newtype(), Left}, Either{T, newtype(), Right}]


function either(left_false::L, comparison::Bool, right_true::R) where {L, R}
  comparison ? Right{L, R}(right_true) : Left{L, R}(left_false)
end

flip(x::Left{L, R}) where {L, R} = Right{R, L}(x.value)
flip(x::Right{L, R}) where {L, R} = Left{R, L}(x.value)


Base.get(e::Left) = nothing
Base.get(e::Right) = e.value
getOption(::Left{L, R}) where {L, R} = None{R}()
getOption(e::Right) = Some(e.value)

isleft(e::Left) = true
isleft(e::Right) = false

isright(e::Left) = false
isright(e::Right) = true

getleft(e::Left) = e.value
getleft(e::Right) = nothing

getright(e::Left) = nothing
getright(e::Right) = e.value

getleftOption(e::Left{L, R}) where {L, R} = Some{L}(e.value)
getleftOption(e::Right{L, R}) where {L, R} = None{L}()

getrightOption(e::Left{L, R}) where {L, R} = None{R}()
getrightOption(e::Right{L, R}) where {L, R} = Some{R}(e.value)

Base.convert(::Type{<:Option}, e::Either) = getrightOption(e)

Base.eltype(::Type{<:Either{L, R}}) where {L, R} = R
Base.eltype(::Type{<:Either}) = Any

Base.map(f, x::Right{L}) where {L} = Right{L}(f(x.value))
Base.map(f, x::Left{L, R}) where {L, R} = Left{L, Out(f, R)}(x.value)
