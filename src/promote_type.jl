# promote_type/promote_typejoin already works for Identity and Nothing (aka Options)
# ==========================================================================

# promote_type
# ------------
# seamingly nothing todo, everything works out of the box
# probably as `Nothing` is already super well supported for promote_type and promote_typejoin


# promote_typejoin
# ----------------
# This does not seem to work out of the box however, a bit surprisingly.
# One reason seems to be that Identity is not a concrete type.

# only the abstract one is missing in Base
Base.promote_typejoin(::Type{Nothing}, ::Type{Identity}) = Option
Base.promote_typejoin(::Type{Identity}, ::Type{Nothing}) = Option

Base.promote_typejoin(::Type{Option{T1}}, ::Type{Identity{T2}}) where {T1, T2} = Option
Base.promote_typejoin(::Type{Identity{T2}}, ::Type{Option{T1}}) where {T1, T2} = Option

Base.promote_typejoin(::Type{Option{T}}, ::Type{Nothing}) where {T} = Option{T}
Base.promote_typejoin(::Type{Nothing}, ::Type{Option{T}}) where {T} = Option{T}

Base.promote_typejoin(::Type{Option}, ::Type{Nothing}) = Option
Base.promote_typejoin(::Type{Nothing}, ::Type{Option}) = Option






# promote_type/promote_typejoin should work with Identity and Const (aka Either)
# ==========================================================================

# promote_type ---------------------------------------------------------------------------------
# promote_type only has to deal with concrete types, including Unions in our case

# promote_type Const & Identity
# -----------------------------

Base.promote_rule(::Type{C}, ::Type{I}) where {C<:Const, I<:Identity} = Union{C, I}


# promote_type Const & Either
# -----------------------------

Base.promote_rule(::Type{Const}, ::Type{Either{L, R}}) where {L, R} = Either{<:Any, R}
Base.promote_rule(::Type{Const{L}}, ::Type{Either{L, R}}) where {L, R} = Either{L, R}
Base.promote_rule(::Type{Const{L1}}, ::Type{Either{L2, R}}) where {L1, R, L2 <: L1} = Either{L1, R}
Base.promote_rule(::Type{Const{L2}}, ::Type{Either{L1, R}}) where {L1, R, L2 <: L1} = Either{L1, R}
Base.promote_rule(::Type{Const{L2}}, ::Type{Either{L1, R}}) where {L1, R, L2} = Either{<:Any, R}

Base.promote_rule(::Type{Const}, ::Type{Either{L, <:Any}}) where {L} = Either
Base.promote_rule(::Type{Const{L}}, ::Type{Either{L, <:Any}}) where {L} = Either{L, <:Any}
Base.promote_rule(::Type{Const{L1}}, ::Type{Either{L2, <:Any}}) where {L1, L2 <: L1} = Either{L1, <:Any}
Base.promote_rule(::Type{Const{L2}}, ::Type{Either{L1, <:Any}}) where {L1, L2 <: L1} = Either{L1, <:Any}
Base.promote_rule(::Type{Const{L1}}, ::Type{Either{L2, <:Any}}) where {L1, L2} = Either

Base.promote_rule(::Type{Const}, ::Type{Either}) = Either


# promote_type Identity & Either
# -----------------------------

Base.promote_rule(::Type{Identity}, ::Type{Either{L, R}}) where {L, R} = Either{L, <:Any}
Base.promote_rule(::Type{Identity{R}}, ::Type{Either{L, R}}) where {L, R} = Either{L, R}
Base.promote_rule(::Type{Identity{R1}}, ::Type{Either{L, R2}}) where {L, R1, R2 <: R1} = Either{L, R1}
Base.promote_rule(::Type{Identity{R2}}, ::Type{Either{L, R1}}) where {L, R1, R2 <: R1} = Either{L, R1}
Base.promote_rule(::Type{Identity{R2}}, ::Type{Either{L, R1}}) where {L, R1, R2} = Either{L, <:Any}

Base.promote_rule(::Type{Identity}, ::Type{Either{<:Any, R}}) where {R} = Either
Base.promote_rule(::Type{Identity{R}}, ::Type{Either{<:Any, R}}) where {R} = Either{<:Any, R}
Base.promote_rule(::Type{Identity{R1}}, ::Type{Either{<:Any, R2}}) where {R1, R2 <: R1} = Either{<:Any, R1}
Base.promote_rule(::Type{Identity{R2}}, ::Type{Either{<:Any, R1}}) where {R1, R2 <: R1} = Either{<:Any, R1}
Base.promote_rule(::Type{Identity{R2}}, ::Type{Either{<:Any, R1}}) where {R1, R2} = Either

Base.promote_rule(::Type{Identity}, ::Type{Either}) = Either


# promote_type Either & Either
# -----------------------------

# we need to be cautious here, as we cannot dispatch on Type{<:Either{<:Any, R}} or similar, because R might not be defined
Base.promote_rule(::Type{Either{L, R}}, ::Type{Either{L, R}}) where {L, R} = Either{L, R}
Base.promote_rule(::Type{Either{L1, R}}, ::Type{Either{L2, R}}) where {L1, R, L2 <: L1} = Either{L1, R}
Base.promote_rule(::Type{Either{L, R1}}, ::Type{Either{L, R2}}) where {L, R1, R2 <: R1} = Either{L, R1}
Base.promote_rule(::Type{Either{L1, R1}}, ::Type{Either{L2, R2}}) where {L1, R1, L2 <: L1, R2 <: R1} = Either{L1, R1}
Base.promote_rule(::Type{Either{L2, R1}}, ::Type{Either{L1, R2}}) where {L1, R1, L2 <: L1, R2 <: R1} = Either{L1, R1}

Base.promote_rule(::Type{Either{L1, R}}, ::Type{Either{L2, R}}) where {L1, R, L2} = Either{<:Any, R}
Base.promote_rule(::Type{Either{L, R1}}, ::Type{Either{L, R2}}) where {L, R1, R2} = Either{L, <:Any}
Base.promote_rule(::Type{Either{L1, R1}}, ::Type{Either{L2, R2}}) where {L1, R1, L2, R2} = Either

Base.promote_rule(::Type{Either{L, <:Any}}, ::Type{Either{L, <:Any}}) where {L} = Either{L, <:Any}
Base.promote_rule(::Type{Either{L1, <:Any}}, ::Type{Either{L2, <:Any}}) where {L1, L2 <: L1} = Either{L1, <:Any}
Base.promote_rule(::Type{Either{L1, <:Any}}, ::Type{Either{L2, <:Any}}) where {L1, L2} = Either

Base.promote_rule(::Type{Either{<:Any, R}}, ::Type{Either{<:Any, R}}) where {R} = Either{<:Any, R}
Base.promote_rule(::Type{Either{<:Any, R1}}, ::Type{Either{<:Any, R2}}) where {R1, R2 <: R1} = Either{<:Any, R1}
Base.promote_rule(::Type{Either{<:Any, R1}}, ::Type{Either{<:Any, R2}}) where {R1, R2} = Either

# NOTE we cannot use `Base.promote_rule(::Type{<:Either}, ::Type{<:Either}) = Either` as apparently this interferes
# with more concrete implementations of promote_rule
# promote_type seem to assume, that you really only define promote_rule for concrete types
Base.promote_rule(::Type{Either}, ::Type{Either}) = Either


# promote_typejoin ---------------------------------------------------------------
# promote_typejoin never converts types, but always returns the next abstract type in the hierarchy, including Unions
# further, promote_typejoin(A, B) and promote_typejoin(B, A) need both to be defined (unlike promote_rule)

# promote_typejoin Const & Identity
# -----------------------------

Base.promote_typejoin(::Type{C}, ::Type{I}) where {C<:Const, I<:Identity} = Union{C, I}
Base.promote_typejoin(::Type{I}, ::Type{C}) where {C<:Const, I<:Identity} = Union{C, I}


# promote_typejoin Const & Either
# -----------------------------

Base.promote_typejoin(::Type{Const}, ::Type{Either{L, R}}) where {L, R} = Either{<:Any, R}
Base.promote_typejoin(::Type{Either{L, R}}, ::Type{Const}) where {L, R} = Either{<:Any, R}

Base.promote_typejoin(::Type{Const{L}}, ::Type{Either{L, R}}) where {L, R} = Either{L, R}
Base.promote_typejoin(::Type{Either{L, R}}, ::Type{Const{L}}) where {L, R} = Either{L, R}

Base.promote_typejoin(::Type{Const{L2}}, ::Type{Either{L1, R}}) where {L1, R, L2} = Either{<:Any, R}
Base.promote_typejoin(::Type{Either{L1, R}}, ::Type{Const{L2}}) where {L1, R, L2} = Either{<:Any, R}


Base.promote_typejoin(::Type{Const}, ::Type{Either{L, <:Any}}) where {L} = Either
Base.promote_typejoin(::Type{Either{L, <:Any}}, ::Type{Const}) where {L} = Either

Base.promote_typejoin(::Type{Const{L}}, ::Type{Either{L, <:Any}}) where {L} = Either{L, <:Any}
Base.promote_typejoin(::Type{Either{L, <:Any}}, ::Type{Const{L}}) where {L} = Either{L, <:Any}

Base.promote_typejoin(::Type{Const{L1}}, ::Type{Either{L2, <:Any}}) where {L1, L2} = Either
Base.promote_typejoin(::Type{Either{L2, <:Any}}, ::Type{Const{L1}}) where {L1, L2} = Either


Base.promote_typejoin(::Type{Const}, ::Type{Either}) = Either
Base.promote_typejoin(::Type{Either}, ::Type{Const}) = Either


# promote_typejoin Identity & Either
# -----------------------------

Base.promote_typejoin(::Type{Identity}, ::Type{Either{L, R}}) where {L, R} = Either{L, <:Any}
Base.promote_typejoin(::Type{Either{L, R}}, ::Type{Identity}) where {L, R} = Either{L, <:Any}

Base.promote_typejoin(::Type{Identity{R}}, ::Type{Either{L, R}}) where {L, R} = Either{L, R}
Base.promote_typejoin(::Type{Either{L, R}}, ::Type{Identity{R}}) where {L, R} = Either{L, R}

Base.promote_typejoin(::Type{Identity{R2}}, ::Type{Either{L, R1}}) where {L, R1, R2} = Either{L, <:Any}
Base.promote_typejoin(::Type{Either{L, R1}}, ::Type{Identity{R2}}) where {L, R1, R2} = Either{L, <:Any}


Base.promote_typejoin(::Type{Identity}, ::Type{Either{<:Any, R}}) where {R} = Either
Base.promote_typejoin(::Type{Either{<:Any, R}}, ::Type{Identity}) where {R} = Either

Base.promote_typejoin(::Type{Identity{R}}, ::Type{Either{<:Any, R}}) where {R} = Either{<:Any, R}
Base.promote_typejoin(::Type{Either{<:Any, R}}, ::Type{Identity{R}}) where {R} = Either{<:Any, R}

Base.promote_typejoin(::Type{Identity{R2}}, ::Type{Either{<:Any, R1}}) where {R1, R2} = Either
Base.promote_typejoin(::Type{Either{<:Any, R1}}, ::Type{Identity{R2}}) where {R1, R2} = Either


Base.promote_typejoin(::Type{Identity}, ::Type{Either}) = Either
Base.promote_typejoin(::Type{Either}, ::Type{Identity}) = Either


# promote_type Either & Either
# -----------------------------

# we need to be cautious here, as we cannot dispatch on Type{<:Either{<:Any, R}} or similar, because R might not be defined
Base.promote_typejoin(::Type{Either{L, R}}, ::Type{Either{L, R}}) where {L, R} = Either{L, R}

Base.promote_typejoin(::Type{Either{L1, R}}, ::Type{Either{L2, R}}) where {L1, R, L2} = Either{<:Any, R}

Base.promote_typejoin(::Type{Either{L, R1}}, ::Type{Either{L, R2}}) where {L, R1, R2} = Either{L, <:Any}

Base.promote_typejoin(::Type{Either{L1, R1}}, ::Type{Either{L2, R2}}) where {L1, R1, L2, R2} = Either


Base.promote_typejoin(::Type{Either{L, <:Any}}, ::Type{Either{L, <:Any}}) where {L} = Either{L, <:Any}

Base.promote_typejoin(::Type{Either{L1, <:Any}}, ::Type{Either{L2, <:Any}}) where {L1, L2} = Either


Base.promote_typejoin(::Type{Either{<:Any, R}}, ::Type{Either{<:Any, R}}) where {L, R} = Either{<:Any, R}

Base.promote_typejoin(::Type{Either{<:Any, R1}}, ::Type{Either{<:Any, R2}}) where {R1, R2} = Either


Base.promote_typejoin(::Type{Either}, ::Type{Either}) = Either





# promote_type/promote_typejoin should work with all three Identity, Nothing and Const (aka OptionEither)
# ==========================================================================

# promote_type
# ------------
# nothing todo, as `Nothing` is already super well supported for promote_type and promote_typejoin


# promote_typejoin
# ----------------

# we have to do something here

# Nothing
# - - - -

Base.promote_typejoin(::Type{Nothing}, ::Type{OptionEither{L, R}}) where {L, R} = OptionEither{L, R}
Base.promote_typejoin(::Type{OptionEither{L, R}}, ::Type{Nothing}) where {L, R} = OptionEither{L, R}

Base.promote_typejoin(::Type{Nothing}, ::Type{OptionEither{L, <:Any}}) where {L} = OptionEither{L, <:Any}
Base.promote_typejoin(::Type{OptionEither{L, <:Any}}, ::Type{Nothing}) where {L} = OptionEither{L, <:Any}

Base.promote_typejoin(::Type{Nothing}, ::Type{OptionEither{<:Any, R}}) where {R} = OptionEither{<:Any, R}
Base.promote_typejoin(::Type{OptionEither{<:Any, R}}, ::Type{Nothing}) where {R} = OptionEither{<:Any, R}

Base.promote_typejoin(::Type{Nothing}, ::Type{OptionEither}) = OptionEither
Base.promote_typejoin(::Type{OptionEither}, ::Type{Nothing}) = OptionEither


# Const
# - - -

Base.promote_typejoin(::Type{Const{L}}, ::Type{OptionEither{L, R}}) where {L, R} = OptionEither{L, R}
Base.promote_typejoin(::Type{OptionEither{L, R}}, ::Type{Const{L}}) where {L, R} = OptionEither{L, R}

Base.promote_typejoin(::Type{Const{L1}}, ::Type{OptionEither{L2, R}}) where {L1, L2, R} = OptionEither{<:Any, R}
Base.promote_typejoin(::Type{OptionEither{L2, R}}, ::Type{Const{L1}}) where {L1, L2, R} = OptionEither{<:Any, R}

Base.promote_typejoin(::Type{Const{L}}, ::Type{OptionEither{<:Any, R}}) where {L, R} = OptionEither{<:Any, R}
Base.promote_typejoin(::Type{OptionEither{<:Any, R}}, ::Type{Const{L}}) where {L, R} = OptionEither{<:Any, R}

Base.promote_typejoin(::Type{Const{L}}, ::Type{OptionEither{L, <:Any}}) where {L} = OptionEither{L, <:Any}
Base.promote_typejoin(::Type{OptionEither{L, <:Any}}, ::Type{Const{L}}) where {L, R} = OptionEither{L, <:Any}

Base.promote_typejoin(::Type{Const{L1}}, ::Type{OptionEither{L2, <:Any}}) where {L1, L2} = OptionEither
Base.promote_typejoin(::Type{OptionEither{L2, <:Any}}, ::Type{Const{L1}}) where {L1, L2} = OptionEither

Base.promote_typejoin(::Type{Const{L}}, ::Type{OptionEither}) where {L} = OptionEither
Base.promote_typejoin(::Type{OptionEither}, ::Type{Const{L}}) where {L} = OptionEither



Base.promote_typejoin(::Type{Const}, ::Type{OptionEither{L, R}}) where {L, R} = OptionEither{<:Any, R}
Base.promote_typejoin(::Type{OptionEither{L, R}}, ::Type{Const}) where {L, R} = OptionEither{<:Any, R}

Base.promote_typejoin(::Type{Const}, ::Type{OptionEither{L, <:Any}}) where {L} = OptionEither
Base.promote_typejoin(::Type{OptionEither{L, <:Any}}, ::Type{Const}) where {L} = OptionEither

Base.promote_typejoin(::Type{Const}, ::Type{OptionEither{<:Any, R}}) where {R} = OptionEither{<:Any, R}
Base.promote_typejoin(::Type{OptionEither{<:Any, R}}, ::Type{Const}) where {R} = OptionEither{<:Any, R}

Base.promote_typejoin(::Type{Const}, ::Type{OptionEither}) = OptionEither
Base.promote_typejoin(::Type{OptionEither}, ::Type{Const}) = OptionEither


# Identity
# - - - - -


Base.promote_typejoin(::Type{Identity{R}}, ::Type{OptionEither{L, R}}) where {L, R} = OptionEither{L, R}
Base.promote_typejoin(::Type{OptionEither{L, R}}, ::Type{Identity{R}}) where {L, R} = OptionEither{L, R}

Base.promote_typejoin(::Type{Identity{R1}}, ::Type{OptionEither{L, R2}}) where {L, R1, R2} = OptionEither{L, <:Any}
Base.promote_typejoin(::Type{OptionEither{L, R2}}, ::Type{Identity{R1}}) where {L, R1, R2} = OptionEither{L, <:Any}

Base.promote_typejoin(::Type{Identity{R}}, ::Type{OptionEither{L, <:Any}}) where {L, R} = OptionEither{L, <:Any}
Base.promote_typejoin(::Type{OptionEither{L, <:Any}}, ::Type{Identity{R}}) where {L, R} = OptionEither{L, <:Any}

Base.promote_typejoin(::Type{Identity{R}}, ::Type{OptionEither{<:Any, R}}) where {R} = OptionEither{<:Any, R}
Base.promote_typejoin(::Type{OptionEither{<:Any, R}}, ::Type{Identity{R}}) where {L, R} = OptionEither{<:Any, R}

Base.promote_typejoin(::Type{Identity{R1}}, ::Type{OptionEither{<:Any, R2}}) where {R1, R2} = OptionEither
Base.promote_typejoin(::Type{OptionEither{<:Any, R2}}, ::Type{Identity{R1}}) where {R1, R2} = OptionEither

Base.promote_typejoin(::Type{Identity{R}}, ::Type{OptionEither}) where {R} = OptionEither
Base.promote_typejoin(::Type{OptionEither}, ::Type{Identity{R}}) where {R} = OptionEither



Base.promote_typejoin(::Type{Identity}, ::Type{OptionEither{L, R}}) where {L, R} = OptionEither{L, <:Any}
Base.promote_typejoin(::Type{OptionEither{L, R}}, ::Type{Identity}) where {L, R} = OptionEither{L, <:Any}

Base.promote_typejoin(::Type{Identity}, ::Type{OptionEither{<:Any, R}}) where {R} = OptionEither
Base.promote_typejoin(::Type{OptionEither{<:Any, R}}, ::Type{Identity}) where {R} = OptionEither

Base.promote_typejoin(::Type{Identity}, ::Type{OptionEither{L, <:Any}}) where {L} = OptionEither{L, <:Any}
Base.promote_typejoin(::Type{OptionEither{L, <:Any}}, ::Type{Identity}) where {L} = OptionEither{L, <:Any}

Base.promote_typejoin(::Type{Identity}, ::Type{OptionEither}) = OptionEither
Base.promote_typejoin(::Type{OptionEither}, ::Type{Identity}) = OptionEither
