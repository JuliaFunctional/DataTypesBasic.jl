const Either{L, R} = Union{Stop{L}, Identity{R}}
Either{L, R}(x::L) where {L, R} = Stop(x)
Either{L, R}(x::R) where {L, R} = Identity(x)
Either{L}(x::R) where {L, R} = Identity(x)
Either{L}(x::L) where {L} = Stop(x)

# Stop is covariate
Base.convert(::Type{Stop{T}}, x::Stop) where {T} = Stop(Base.convert(T, x.value))
promote_rule(::Type{Stop{T}}, ::Type{Stop{S}}) where {T, S<:T} = Stop{T}


# TypeJoin should work with Identity and Either

# typejoin Stop & Identity
Base.typejoin(::Type{Stop{L}}, ::Type{Identity{R}}) where {L, R} = Either{L, R}
Base.typejoin(::Type{Identity{R}}, ::Type{Stop{L}}) where {L, R} = Either{L, R}
# typejoin Stop & Either
Base.typejoin(::Type{Stop{L}}, ::Type{<:Either{L, R}}) where {L, R} = Either{L, R}
Base.typejoin(::Type{<:Either{L, R}}, ::Type{Stop{L}}) where {L, R} = Either{L, R}
Base.typejoin(::Type{<:Stop}, ::Type{<:Either{<:Any, R}}) where {R} = Either{<:Any, R}
Base.typejoin(::Type{<:Either{<:Any, R}}, ::Type{<:Stop}) where {R} = Either{<:Any, R}
# typejoin Identity & Either
Base.typejoin(::Type{Identity{R}}, ::Type{<:Either{L, R}}) where {L, R} = Either{L, R}
Base.typejoin(::Type{<:Either{L, R}}, ::Type{Identity{R}}) where {L, R} = Either{L, R}
Base.typejoin(::Type{<:Identity}, ::Type{<:Either{L}}) where {L} = Either{L}
Base.typejoin(::Type{<:Either{L}}, ::Type{<:Identity}) where {L} = Either{L}
# typejoin Either & Either
Base.typejoin(::Type{<:Either{L, R}}, ::Type{<:Either{L, R}}) where {L, R} = Either{L, R}
Base.typejoin(::Type{<:Either{L}}, ::Type{<:Either{L}}) where {L} = Either{L}
Base.typejoin(::Type{<:Either{<:Any, R}}, ::Type{<:Either{<:Any, R}}) where {R} = Either{<:Any, R}
Base.typejoin(::Type{<:Either}, ::Type{<:Either}) = Either

# Conversion should also work with Either
Base.convert(::Type{Either{L, R}}, x::Identity) where {L, R} = Identity(Base.convert(R, x.value))
Base.convert(::Type{Either{L, R}}, x::Stop) where {L, R} = Stop(Base.convert(L, x.value))

Base.eltype(::Type{<:Either{L, R}}) where {L, R} = R
Base.eltype(::Type{<:Either{<:Any, R}}) where {R} = R
Base.eltype(::Type{<:Either}) = Any


# Helpers for Either
# ------------------

function either(left_false, comparison::Bool, right_true)
  comparison ? Identity(right_true) : Stop(left_false)
end

flip_left_right(x::Stop) = Identity(x.value)
flip_left_right(x::Identity) = Stop(x.value)

isleft(e::Stop) = true
isleft(e::Identity) = false

isright(e::Stop) = false
isright(e::Identity) = true

getleft(e::Stop) = e.value
# getleft(e::Identity) = nothing  # throw an error if getleft is called on Identity

# getright(e::Stop) = nothing  # throw an error if getright is called on Stop
getright(e::Identity) = e.value

getleftOption(e::Stop{L}) where {L} = Identity{L}(e.value)
getleftOption(e::Identity) = nothing

getrightOption(e::Stop) = nothing
getrightOption(e::Identity{R}) where {R} = e
