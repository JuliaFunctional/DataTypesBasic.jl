const Either{L, R} = Union{Const{L}, Identity{R}}
Either{L, R}(x::L) where {L, R} = Const(x)
Either{L, R}(x::R) where {L, R} = Identity(x)
Either{L}(x::R) where {L, R} = Identity(x)
Either{L}(x::L) where {L} = Const(x)

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
