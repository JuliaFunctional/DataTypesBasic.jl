const Either{L, R} = Union{Const{L}, Identity{R}}
Either{L, R}(x::L) where {L, R} = Const(x)
Either{L, R}(x::R) where {L, R} = Identity(x)
Either{L}(x::R) where {L, R} = Identity(x)
Either{L}(x::L) where {L} = Const(x)


# TypeJoin should work with Identity and Either

# typejoin Const & Identity
Base.typejoin(::Type{Const{L}}, ::Type{Identity{R}}) where {L, R} = Either{L, R}
Base.typejoin(::Type{Identity{R}}, ::Type{Const{L}}) where {L, R} = Either{L, R}
# typejoin Const & Either
Base.typejoin(::Type{Const{L}}, ::Type{<:Either{L, R}}) where {L, R} = Either{L, R}
Base.typejoin(::Type{<:Either{L, R}}, ::Type{Const{L}}) where {L, R} = Either{L, R}
Base.typejoin(::Type{<:Const}, ::Type{<:Either{<:Any, R}}) where {R} = Either{<:Any, R}
Base.typejoin(::Type{<:Either{<:Any, R}}, ::Type{<:Const}) where {R} = Either{<:Any, R}
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
Base.convert(::Type{Either{L, R}}, x::Const) where {L, R} = Const(Base.convert(L, x.value))

Base.eltype(::Type{Either{L, R}}) where {L, R} = R
Base.eltype(::Type{Either{<:Any, R}}) where {R} = R
Base.eltype(::Type{Either}) = Any


# Helpers for Either
# ------------------

function either(left_false, comparison::Bool, right_true)
  comparison ? Identity(right_true) : Const(left_false)
end

flip_left_right(x::Const) = Identity(x.value)
flip_left_right(x::Identity) = Const(x.value)

isleft(e::Const) = true
isleft(e::Identity) = false

isright(e::Const) = false
isright(e::Identity) = true

getleft(e::Const) = e.value
# getleft(e::Identity) = nothing  # throw an error if getleft is called on Identity

# getright(e::Const) = nothing  # throw an error if getright is called on Const
getright(e::Identity) = e.value

getleftOption(e::Const{L}) where {L} = Identity{L}(e.value)
getleftOption(e::Identity) = nothing

getrightOption(e::Const) = nothing
getrightOption(e::Identity{R}) where {R} = e
