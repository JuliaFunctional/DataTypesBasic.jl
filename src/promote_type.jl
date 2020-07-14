# promote_type/promote_typejoin already works for Identity and Nothing (aka Options)
# ==========================================================================

# nothing todo, as `Nothing` is already super well supported for promote_type and promote_typejoin


# promote_type/promote_typejoin should work with Identity and Const (aka Either)
# ==========================================================================

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

Base.promote_rule(::Type{Const}, ::Type{Either{L, <:Any}}) where {L} = Either
Base.promote_rule(::Type{Const{L}}, ::Type{Either{L, <:Any}}) where {L} = Either{L, <:Any}
Base.promote_rule(::Type{Const{L1}}, ::Type{Either{L2, <:Any}}) where {L1, L2 <: L1} = Either{L1, <:Any}
Base.promote_rule(::Type{Const{L2}}, ::Type{Either{L1, <:Any}}) where {L1, L2 <: L1} = Either{L1, <:Any}

Base.promote_rule(::Type{Const}, ::Type{Either}) = Either


# promote_type Identity & Either
# -----------------------------

Base.promote_rule(::Type{Identity}, ::Type{Either{L, R}}) where {L, R} = Either{L, <:Any}
Base.promote_rule(::Type{Identity{R}}, ::Type{Either{L, R}}) where {L, R} = Either{L, R}
Base.promote_rule(::Type{Identity{R1}}, ::Type{Either{L, R2}}) where {L, R1, R2 <: R1} = Either{L, R1}
Base.promote_rule(::Type{Identity{R2}}, ::Type{Either{L, R1}}) where {L, R1, R2 <: R1} = Either{L, R1}

Base.promote_rule(::Type{Identity}, ::Type{Either{<:Any, R}}) where {R} = Either
Base.promote_rule(::Type{Identity{R}}, ::Type{Either{<:Any, R}}) where {R} = Either{<:Any, R}
Base.promote_rule(::Type{Identity{R1}}, ::Type{Either{<:Any, R2}}) where {R1, R2 <: R1} = Either{<:Any, R1}
Base.promote_rule(::Type{Identity{R2}}, ::Type{Either{<:Any, R1}}) where {R1, R2 <: R1} = Either{<:Any, R1}

Base.promote_rule(::Type{Identity}, ::Type{Either}) = Either


# promote_type Either & Either
# -----------------------------

# we need to be cautious here, as we cannot dispatch on Type{<:Either{<:Any, R}} or similar, because R might not be defined
Base.promote_rule(::Type{Either{L, R}}, ::Type{Either{L, R}}) where {L, R} = Either{L, R}
Base.promote_rule(::Type{Either{L1, R}}, ::Type{Either{L2, R}}) where {L1, R, L2 <: L1} = Either{L1, R}
Base.promote_rule(::Type{Either{L, R1}}, ::Type{Either{L, R2}}) where {L, R1, R2 <: R1} = Either{L, R1}
Base.promote_rule(::Type{Either{L1, R1}}, ::Type{Either{L2, R2}}) where {L1, R1, L2 <: L1, R2 <: R1} = Either{L1, R1}
Base.promote_rule(::Type{Either{L2, R1}}, ::Type{Either{L1, R2}}) where {L1, R1, L2 <: L1, R2 <: R1} = Either{L1, R1}

Base.promote_rule(::Type{Either{L, <:Any}}, ::Type{Either{L, <:Any}}) where {L} = Either{L, <:Any}
Base.promote_rule(::Type{Either{L1, <:Any}}, ::Type{Either{L2, <:Any}}) where {L1, L2 <: L1} = Either{L1, <:Any}

Base.promote_rule(::Type{Either{<:Any, R}}, ::Type{Either{<:Any, R}}) where {L, R} = Either{<:Any, R}
Base.promote_rule(::Type{Either{<:Any, R1}}, ::Type{Either{<:Any, R2}}) where {L, R1, R2 <: R1} = Either{<:Any, R1}

# NOTE we cannot use `Base.promote_rule(::Type{<:Either}, ::Type{<:Either}) = Either` as apparently this interferes
# with more concrete implementations of promote_rule
# promote_type seem to assume, that you really only define promote_rule for concrete types
Base.promote_rule(::Type{Either}, ::Type{Either}) = Either


# promote_typejoin
# -----------------------------

# We also support `promote_typejoin`, as the semantics between promote_typejoin and promote_type overlap
# in our case of Unions (similar to how they are already defined for Nothing and Missing in Base).
# In addition note that `promote_typejoin` has to be defined for both flipped and non-flipped versions.
# We solve this by referring to the symmetric `promote_type` instead of the asymmtric `promote_rule`.
Base.promote_typejoin(::Type{E1}, ::Type{E2}) where {E1<:OptionEither, E2<:OptionEither} = promote_type(E1, E2)
# TODO typejoin should actually not combine Identity{AbstractString} and Identity{String} to Identity{AbstractString}
# hence we really need to redefine everything alike to be safe.


# promote_type/promote_typejoin should work with all three Identity, Nothing and Const (aka OptionEither)
# ==========================================================================

# nothing todo, as `Nothing` is already super well supported for promote_type and promote_typejoin
