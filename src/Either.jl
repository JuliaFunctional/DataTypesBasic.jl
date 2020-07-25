"""
    Either{L, R} = Union{Const{L}, Identity{R}}
    Either{Int, Bool}(true) == Identity(true)
    Either{Int, Bool}(1) == Const(1)
    Either{String}("left") == Const("left")
    Either{String}(:anythingelse) == Identity(:anythingelse)

A very common type to represent Result or Failure.
We reuse [`Identity`](@ref) as representing "Success" and [`Const`](@ref) for "Failure".
"""
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

"""
    either(:left, bool_condition, "right")

If `bool_condition` is true, it returns the right value, wrapped into [Identity](@ref).
Else returns left side, wrapped into [Const](@ref).

Example
-------
```jldoctest
either(:left, 1 < 2, "right") == Identity("right")
```
"""
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


"""
    flip_left_right(Const(1)) == Identity(1)
    flip_left_right(Identity(:whatever)) == Const(:whatever)

exchanges left and right, i.e. what was Const, becomes an Identity and the other way around.
"""
flip_left_right(x::Const) = Identity(x.value)
flip_left_right(x::Identity) = Const(x.value)

"""
    iseither(::Const) = true
    iseither(::Identity) = true
    iseither(other) = false

check whether something is an [`Either`](@ref)
"""
iseither(::Const) = true
iseither(::Identity) = true
iseither(other) = false

"""
    isleft(::Const) = true
    isleft(::Identity) = false

Identical to [`isconst`](@ref), but might be easier to read when working with `Either`.
"""
isleft(::Const) = true
isleft(::Identity) = false


"""
    isright(::Const) = false
    isright(::Identity) = true

Identical to [`isidentity`](@ref), but might be easier to read when working with `Either`.
"""
isright(::Const) = false
isright(::Identity) = true

"""
    getleft(Const(:something)) == :something
    getleft(Identity(23))  # throws MethodError

Extract a value from a "left" `Const` value. Will result in loud error when used on anything else.
"""
getleft(e::Const) = e.value

"""
    getright(Identity(23)) == 23
    getright(Const(:something))  # throws MethodError

Extract a value from a "right" `Identity` value. Will result in loud error when used on anything else.
Identical to `Base.get` but explicit about the site (and not defined for other things)
"""
getright(e::Identity) = e.value


"""
    getleftOption(Identity(23)) == Option()
    getleftOption(Const(:something)) == Option(:something)

Convert to option, assuming you want to have the left value be preserved.
"""
getleftOption(e::Const) = Option(e.value)
getleftOption(e::Identity) = Option()

"""
    getrightOption(Identity(23)) == Option(23)
    getrightOption(Const(:something)) == Option()

Convert to option, assuming you want to have the right value be preserved.
Identical to `getOption`, just explicit about the site.
"""
getrightOption(e::Const) = Option()
getrightOption(e::Identity) = e



"""
    getOption(Identity(23)) == Option(23)
    getOption(Const(:something)) == Option()

Convert to option, assuming you want to have the right value be preserved, and the left value represented as
`Option()`.
"""
getOption(e::Const) = Option()
getOption(e::Identity) = e
