struct Left{L}
  value::L
end

struct Right{R}
  value::R
end

const Either{L, R} = Union{Left{L}, Right{R}}
Either{L, R}(x::L) where {L, R} = Left(x)
Either{L, R}(x::R) where {L, R} = Right(x)
Either{L}(x::R) where {L, R} = Right(x)
Either{L}(x::L) where {L} = Left(x)


# conversions/ promotions

# typejoin Left & Left
Base.typejoin(::Type{Left{L}}, ::Type{Left{L}}) where L = Left{L}
Base.typejoin(::Type{<:Left}, ::Type{<:Left}) = Left
# typejoin Right & Right
Base.typejoin(::Type{Right{R}}, ::Type{Right{R}}) where R = Right{R}
Base.typejoin(::Type{<:Right}, ::Type{<:Right}) = Right
# typejoin Left & Right
Base.typejoin(::Type{Left{L}}, ::Type{Right{R}}) where {L, R} = Either{L, R}
Base.typejoin(::Type{Right{R}}, ::Type{Left{L}}) where {L, R} = Either{L, R}
# typejoin Left & Either
Base.typejoin(::Type{Left{L}}, ::Type{<:Either{L, R}}) where {L, R} = Either{L, R}
Base.typejoin(::Type{<:Either{L, R}}, ::Type{Left{L}}) where {L, R} = Either{L, R}
Base.typejoin(::Type{<:Left}, ::Type{<:Either{<:Any, R}}) where {R} = Either{<:Any, R}
Base.typejoin(::Type{<:Either{<:Any, R}}, ::Type{<:Left}) where {R} = Either{<:Any, R}
# typejoin Right & Either
Base.typejoin(::Type{Right{R}}, ::Type{<:Either{L, R}}) where {L, R} = Either{L, R}
Base.typejoin(::Type{<:Either{L, R}}, ::Type{Right{R}}) where {L, R} = Either{L, R}
Base.typejoin(::Type{<:Right}, ::Type{<:Either{L}}) where {L} = Either{L}
Base.typejoin(::Type{<:Either{L}}, ::Type{<:Right}) where {L} = Either{L}
# typejoin Either & Either
Base.typejoin(::Type{<:Either{L, R}}, ::Type{<:Either{L, R}}) where {L, R} = Either{L, R}
Base.typejoin(::Type{<:Either{L}}, ::Type{<:Either{L}}) where {L} = Either{L}
Base.typejoin(::Type{<:Either{<:Any, R}}, ::Type{<:Either{<:Any, R}}) where {R} = Either{<:Any, R}
Base.typejoin(::Type{<:Either}, ::Type{<:Either}) = Either

# Left/Right are covariate
Base.convert(::Type{Right{T}}, x::Right{S}) where {S, T} = Right(Base.convert(T, x.value))
Base.convert(::Type{Left{T}}, x::Left{S}) where {S, T} = Left(Base.convert(T, x.value))
Base.convert(::Type{Either{L, R2}}, x::Right{R}) where {L, R, R2} = Right(Base.convert(R2, x.value))
Base.convert(::Type{Either{L2, R}}, x::Left{L}) where {L, L2, R} = Left(Base.convert(L2, x.value))
promote_rule(::Type{Left{T}}, ::Type{Left{S}}) where {T, S<:T} = Left{T}
promote_rule(::Type{Right{T}}, ::Type{Right{S}}) where {T, S<:T} = Right{T}


# == controversy https://github.com/JuliaLang/julia/issues/4648
Base.:(==)(a::Right, b::Right) = a.value == b.value
Base.:(==)(a::Left, b::Right) = false
Base.:(==)(a::Right, b::Left) = false
Base.:(==)(a::Left, b::Left) = a.value == b.value

# TypeClasses.unionall_implementationdetails(::Type{<:Either{L, R}}) where {L, R} = Either{L, R}
# Traits.leaftypes(::Type{Either}) = [Either{newtype(), newtype(), Left}, Either{newtype(), newtype(), Right}]
# Traits.leaftypes(::Type{Either{T}}) where T = [Either{T, newtype(), Left}, Either{T, newtype(), Right}]


function either(left_false, comparison::Bool, right_true)
  comparison ? Right(right_true) : Left(left_false)
end

flip_left_right(x::Left) = Right(x.value)
flip_left_right(x::Right) = Left(x.value)

isleft(e::Left) = true
isleft(e::Right) = false

isright(e::Left) = false
isright(e::Right) = true

getleft(e::Left) = e.value
getleft(e::Right) = nothing

getright(e::Left) = nothing
getright(e::Right) = e.value

getleftOption(e::Left{L}) where {L} = Some{L}(e.value)
getleftOption(e::Right) = nothing

getrightOption(e::Left) = nothing
getrightOption(e::Right{R}) where {R} = Some{R}(e.value)

Base.get(e::Either) = getright(e)
getOption(e::Either) = getrightOption(e)

Base.eltype(::Type{<:Either{L, R}}) where {L, R} = R
Base.eltype(::Type{<:Left{L}}) where L = Any  # we have to specify this clause as otherwise we get ERROR: UndefVarError: R not defined
Base.eltype(::Type{<:Either}) = Any

Base.iterate(e::Right) = e.value, nothing
Base.iterate(e::Right, state) = state
Base.iterate(e::Left) = nothing

Base.foreach(f, x::Right) = f(x.value); nothing
Base.foreach(f, x::Left) = nothing

Base.map(f, x::Right) = Right(f(x.value))
Base.map(f, x::Left) = x

Iterators.flatten(x::Right) = convert(Either, x.value)
Iterators.flatten(x::Left) = x
