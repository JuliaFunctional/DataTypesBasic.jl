# promote_type/promote_typejoin should work with Identity and Const (aka Either, but also for Option)

# promote_type
# ============

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

# It turns out for this symmetric case we need to define both versions of promote_rule, including the flipped one
# This is needed, because `promote_type` assumes promote_rule to fallback to the general fallback returning Union{}
# for its feature "you only need to define one" to work out correctly.

# It turns out further, that there is a major bug in Julia, not allowing for these kinds of dispatch as of now
# see https://github.com/JuliaLang/julia/issues/36804 the issue and possible future updates

# As a workaround, we overload `promote_type` to deal with our symmetric case
function Base.promote_type(::Type{Either{L1, R1}}, ::Type{Either{L2, R2}}) where {L1, R1, L2, R2}
    Base.@_inline_meta
    T = Either{L1, R1}
    S = Either{L2, R2}
    # we use typeintersect, as we get an Either for the non-fitting site,
    # thanks to Base.promote_rule(::Type{Either{L1, R1}}, ::Type{Either{L2, R2}}) where {L1, R1, L2, R2} = Either
    typeintersect(promote_rule(T, S), promote_rule(S, T))
end

function Base.promote_type(::Type{Either{<:Any, R1}}, ::Type{Either{<:Any, R2}}) where {R1, R2}
    Base.@_inline_meta
    T = Either{<:Any, R1}
    S = Either{<:Any, R2}
    # we use typeintersect, as we get an Either for the non-fitting site,
    # thanks to Base.promote_rule(::Type{Either{<:Any, R1}}, ::Type{Either{<:Any, R2}}) where {R1, R2} = Either
    typeintersect(promote_rule(T, S), promote_rule(S, T))
end

function Base.promote_type(::Type{Either{L1, <:Any}}, ::Type{Either{L2, <:Any}}) where {L1, L2}
    Base.@_inline_meta
    T = Either{L1, <:Any}
    S = Either{L2, <:Any}
    # we use typeintersect, as we get an Either for the non-fitting site,
    # thanks to Base.promote_rule(::Type{Either{L1, <:Any}}, ::Type{Either{L2, <:Any}}) where {L1, L2} = Either
    typeintersect(promote_rule(T, S), promote_rule(S, T))
end

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


# promote_typejoin
# ================

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
