using Test
using DataTypesBasic

# Const
# =====

@test promote_type(Const{Int}, Const{Number}) == Const{Number}
@test promote_type(Const{Int}, Const) == Const
@test promote_type(Const, Const) == Const

@test Base.promote_typejoin(Const{Number}, Const{Number}) == Const{Number}
@test Base.promote_typejoin(Const{Int}, Const{Number}) == Const
@test Base.promote_typejoin(Const{Number}, Const{Int}) == Const
@test Base.promote_typejoin(Const, Const{Int}) == Const
@test Base.promote_typejoin(Const, Const) == Const


# Identity
# ========

@test promote_type(Identity{Int}, Identity{Number}) == Identity{Number}
@test promote_type(Identity{Int}, Identity) == Identity
@test promote_type(Identity, Identity) == Identity

@test Base.promote_typejoin(Identity{Number}, Identity{Number}) == Identity{Number}
@test Base.promote_typejoin(Identity{Int}, Identity{Number}) == Identity
@test Base.promote_typejoin(Identity{Number}, Identity{Int}) == Identity
@test Base.promote_typejoin(Identity{Int}, Identity) == Identity
@test Base.promote_typejoin(Identity, Identity{Int}) == Identity
@test Base.promote_typejoin(Identity, Identity) == Identity


# Option
# ======

@test promote_type(Identity{Int}, Const{Nothing}) == Union{Identity{Int}, Const{Nothing}}
@test promote_type(Const{Nothing}, Identity{<:Number}) == Union{Identity{<:Number}, Const{Nothing}}

@test Dict(:a => Identity(1), :b => Const(nothing)) isa Dict{Symbol, Option{Int}}

@test Base.promote_typejoin(Const{Nothing}, Identity{Number}) == Option{Number}
@test Base.promote_typejoin(Identity{Number}, Const{Nothing}) == Option{Number}
@test Base.promote_typejoin(Option{Number}, Identity{Int}) == Option
@test Base.promote_typejoin(Identity{Int}, Option{Number}) == Option
@test Base.promote_typejoin(Const{Nothing}, Option) == Option
@test Base.promote_typejoin(Option, Const{Nothing}) == Option
@test Base.promote_typejoin(Const{Nothing}, Identity{Number}) == Option{Number}
@test Base.promote_typejoin(Identity{Number}, Const{Nothing}) == Option{Number}
@test Base.promote_typejoin(Const{Nothing}, Identity) == Option
@test Base.promote_typejoin(Identity, Const{Nothing}) == Option



# Either
# ======


# Const & Identity
# ----------------

@test promote_type(Identity{String}, Const{Symbol}) == Union{Identity{String}, Const{Symbol}}
@test promote_type(Identity{AbstractString}, Const{Number}) == Union{Identity{AbstractString}, Const{Number}}

@test Base.promote_typejoin(Identity{Int}, Const{String}) == Either{String, Int}
@test Base.promote_typejoin(Const{String}, Identity{Int}) == Either{String, Int}
@test Base.promote_typejoin(Identity{Int}, Const) == Either{<:Any, Int}
@test Base.promote_typejoin(Const, Identity{Int}) == Either{<:Any, Int}
@test Base.promote_typejoin(Identity, Const{String}) == Either{String}
@test Base.promote_typejoin(Const{String}, Identity) == Either{String}
@test Base.promote_typejoin(Const, Identity) == Either
@test Base.promote_typejoin(Identity, Const) == Either


# Const & Either
# --------------

@test promote_type(Const{Int}, Either{Number}) == Either{Number}
@test promote_type(Const{Number}, Either{Int}) == Either{Number}
@test promote_type(Const{Number}, Either{Int}) == Either{Number}
@test promote_type(Const{Number}, Either{Int, String}) == Either{Number, String}
@test promote_type(Const{Int}, Either{Number, String}) == Either{Number, String}
@test promote_type(Const{Int}, Either{Number, String}) == Either{Number, String}
@test promote_type(Const{Int}, Either{<:Any, String}) == Either{<:Any, String}
@test promote_type(Const{Int}, Either) == Either

@test promote_type(Either{AbstractString}, Const{String}) == Either{AbstractString}
@test promote_type(Either{AbstractString}, Const) == Either
@test promote_type(Either{Integer}, Const{Number}) == Either{Number}
@test promote_type(Either{Number}, Const{Integer}) == Either{Number}
@test promote_type(Either{Number, String}, Const{Integer}) == Either{Number, String}


@test Base.promote_typejoin(Const, Either{Number, String}) == Either{<:Any, String}
@test Base.promote_typejoin(Either{Number, String}, Const) == Either{<:Any, String}

@test Base.promote_typejoin(Const{Number}, Either{Number, String}) == Either{Number, String}
@test Base.promote_typejoin(Either{Number, String}, Const{Number}) == Either{Number, String}

@test Base.promote_typejoin(Const{Int}, Either{Number, String}) == Either{<:Any, String}
@test Base.promote_typejoin(Either{Number, String}, Const{Int}) == Either{<:Any, String}

@test Base.promote_typejoin(Const, Either{Number}) == Either
@test Base.promote_typejoin(Either{Number}, Const) == Either
@test Base.promote_typejoin(Const{Int}, Either{Number}) == Either
@test Base.promote_typejoin(Either{Number}, Const{Int}) == Either

@test Base.promote_typejoin(Const, Either) == Either
@test Base.promote_typejoin(Either, Const) == Either


# Identity & Either
# -----------------

@test promote_type(Either{AbstractString}, Identity{Int}) == Either{AbstractString}
@test promote_type(Either{AbstractString}, Identity) == Either{AbstractString}
@test promote_type(Identity{Int}, Either{<:Any, Number}) == Either{<:Any, Number}
@test promote_type(Identity{Number}, Either{<:Any, Int}) == Either{<:Any, Number}
@test promote_type(Identity{Number}, Either{<:Any, Int}) == Either{<:Any, Number}
@test promote_type(Identity{Number}, Either{String, Int}) == Either{String, Number}
@test promote_type(Identity{Int}, Either{String, Number}) == Either{String, Number}
@test promote_type(Identity{Int}, Either{String, Number}) == Either{String, Number}
@test promote_type(Identity{Int}, Either{String, <:Any}) == Either{String, <:Any}
@test promote_type(Identity{Int}, Either) == Either

@test promote_type(Either{String, Integer}, Identity{Number}) == Either{String, Number}
@test promote_type(Either{String, Number}, Identity{Integer}) == Either{String, Number}
@test promote_type(Either{String, Integer}, Identity) == Either{String}
@test promote_type(Either{<:Any, Integer}, Identity) == Either
@test promote_type(Either{<:Any, Integer}, Identity{Number}) == Either{<:Any, Number}

@test Base.promote_typejoin(Identity, Either{String, Int}) == Either{String, <:Any}
@test Base.promote_typejoin(Either{String, Int}, Identity) == Either{String, <:Any}
@test Base.promote_typejoin(Identity{Int}, Either{String, Int}) == Either{String, Int}
@test Base.promote_typejoin(Either{String, Int}, Identity{Int}) == Either{String, Int}
@test Base.promote_typejoin(Identity{Number}, Either{String, Int}) == Either{String, <:Any}
@test Base.promote_typejoin(Either{String, Int}, Identity{Number}) == Either{String, <:Any}

@test Base.promote_typejoin(Identity, Either{<:Any, Int}) == Either
@test Base.promote_typejoin(Either{<:Any, Int}, Identity) == Either
@test Base.promote_typejoin(Identity{Int}, Either{<:Any, Int}) == Either{<:Any, Int}
@test Base.promote_typejoin(Either{<:Any, Int}, Identity{Int}) == Either{<:Any, Int}
@test Base.promote_typejoin(Identity{Number}, Either{<:Any, Int}) == Either
@test Base.promote_typejoin(Either{<:Any, Int}, Identity{Number}) == Either

@test Base.promote_typejoin(Identity, Either{Int, <:Any}) == Either{Int, <:Any}
@test Base.promote_typejoin(Either{Int, <:Any}, Identity) == Either{Int, <:Any}

@test Base.promote_typejoin(Identity, Either) == Either
@test Base.promote_typejoin(Either, Identity) == Either


# Either & Either
# ---------------

@test promote_type(Either{String, Integer}, Either{String, Integer}) == Either{String, Integer}
@test promote_type(Either{Integer, AbstractString}, Either{Integer, String}) == Either{Integer, AbstractString}
@test promote_type(Either{Integer, AbstractString}, Either{Number, String}) == Either{Number, AbstractString}
@test promote_type(Either{AbstractString, Integer}, Either{String, Integer}) == Either{AbstractString, Integer}
@test promote_type(Either{AbstractString, Integer}, Either{String, Number}) == Either{AbstractString, Number}
@test promote_type(Either{Number, String}, Either{Integer, AbstractString}) == Either{Number, AbstractString}

@test promote_type(Either{Integer, AbstractString}, Either{Integer, Bool}) == Either{Integer, <:Any}
@test promote_type(Either{Integer, AbstractString}, Either{Number, Bool}) == Either{Number, <:Any}
@test promote_type(Either{Integer, String}, Either{String, String}) == Either{<:Any, String}
@test promote_type(Either{Integer, AbstractString}, Either{String, String}) == Either{<:Any, AbstractString}

@test promote_type(Either{<:Any, Integer}, Either{<:Any, Integer}) == Either{<:Any, Integer}
@test promote_type(Either{<:Any, Integer}, Either{<:Any, Number}) == Either{<:Any, Number}
@test promote_type(Either{String, <:Any}, Either{String, <:Any}) == Either{String, <:Any}
@test promote_type(Either{String, <:Any}, Either{AbstractString, <:Any}) == Either{AbstractString, <:Any}
@test promote_type(Either, Either) == Either

@test Base.promote_typejoin(Either{Int, String}, Either{Int, String}) == Either{Int, String}

@test Base.promote_typejoin(Either{Int, String}, Either{Number, String}) == Either{<:Any, String}
@test Base.promote_typejoin(Either{Number, String}, Either{Int, String}) == Either{<:Any, String}
@test Base.promote_typejoin(Either{Number, String}, Either{Int, AbstractString}) == Either

@test Base.promote_typejoin(Either{String, Int}, Either{String, Number}) == Either{String, <:Any}
@test Base.promote_typejoin(Either{String, Number}, Either{String, Int}) == Either{String, <:Any}
@test Base.promote_typejoin(Either{String, Number}, Either{AbstractString, Int}) == Either

@test Base.promote_typejoin(Either{Int, <:Any}, Either{Int, <:Any}) == Either{Int, <:Any}
@test Base.promote_typejoin(Either{Int, <:Any}, Either{Number, <:Any}) == Either
@test Base.promote_typejoin(Either{Number, <:Any}, Either{Int, <:Any}) == Either

@test Base.promote_typejoin(Either{<:Any, Int}, Either{<:Any, Int}) == Either{<:Any, Int}
@test Base.promote_typejoin(Either{<:Any, Int}, Either{<:Any, Number}) == Either
@test Base.promote_typejoin(Either{<:Any, Number}, Either{<:Any, Int}) == Either

@test Base.promote_typejoin(Either{<:Any, Int}, Either) == Either
@test Base.promote_typejoin(Either, Either{<:Any, Int}) == Either
@test Base.promote_typejoin(Either{Int, <:Any}, Either) == Either
@test Base.promote_typejoin(Either, Either{Int, <:Any}) == Either
@test Base.promote_typejoin(Either, Either) == Either
