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

"""
    @either true ? "right" : Symbol("left")
    @either if false
      "right"
    else
      :left
    end

Simple macro to reuse ? operator and simple if-else for constructing Either.
"""
macro either(expr::Expr)
  @assert expr.head == :if && length(expr.args) == 3 "@either macro only works on ? or simple if-else."
  if isa(expr.args[3], Expr) && (expr.args[3].head == :elseif)
    error("Found elseif, however can only deal with simple if-else.")
  end
  esc(quote
    DataTypesBasic.either($(expr.args[3]), $(expr.args[1]), $(expr.args[2]))
  end)
end

flip_left_right(x::Const) = Identity(x.value)
flip_left_right(x::Identity) = Const(x.value)

iseither(::Const) = true
iseither(::Identity) = true
iseither(other) = false

isleft(::Const) = true
isleft(::Identity) = false

isright(::Const) = false
isright(::Identity) = true

getleft(e::Const) = e.value
# getleft(e::Identity) = nothing  # throw an error if getleft is called on Identity

# getright(e::Const) = nothing  # throw an error if getright is called on Const
getright(e::Identity) = e.value

getleftOption(e::Const) = Option(e.value)
getleftOption(e::Identity) = Option()

getrightOption(e::Const) = Option()
getrightOption(e::Identity) = e
