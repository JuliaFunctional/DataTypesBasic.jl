using Test
using DataTypesBasic

# Const
# =====

@test promote_type(Const{Int}, Const{Number}) == Const{Number}
@test promote_type(Const{Int}, Const) == Const
@test promote_type(Const, Const) == Const

@test Base.promote_typejoin(Const{Number}, Const{Number}) == Const{Number}
@test Base.promote_typejoin(Const{Int}, Const{Number}) == Const
@test Base.promote_typejoin(Const{Int}, Const) == Const
@test Base.promote_typejoin(Const, Const) == Const

# Identity
# ========

@test promote_type(Identity{Int}, Identity{Number}) == Identity{Number}
@test promote_type(Identity{Int}, Identity) == Identity
@test promote_type(Identity, Identity) == Identity

@test Base.promote_typejoin(Identity{Number}, Identity{Number}) == Identity{Number}
@test Base.promote_typejoin(Identity{Int}, Identity{Number}) == Identity
@test Base.promote_typejoin(Identity{Int}, Identity) == Identity
@test Base.promote_typejoin(Identity, Identity) == Identity


# Option
# ======

@test promote_type(Identity{Int}, Const{Nothing}) == Union{Identity{Int}, Const{Nothing}}
@test promote_type(Const{Nothing}, Identity{<:Number}) == Union{Identity{<:Number}, Const{Nothing}}

@test Dict(:a => Identity(1), :b => Const(nothing)) isa Dict{Symbol, Option{Int}}


# Either
# ======

@test promote_type(Identity{String}, Const{Symbol}) == Union{Identity{String}, Const{Symbol}}
@test promote_type(Identity{AbstractString}, Const{Number}) == Union{Identity{AbstractString}, Const{Number}}

@test promote_type(Either{AbstractString}, Identity{Int}) == Either{AbstractString}
@test promote_type(Either{AbstractString}, Identity) == Either{AbstractString}
@test promote_type(Either{AbstractString}, Const{String}) == Either{AbstractString}

@test promote_type(Either{AbstractString}, Const) == Either
@test promote_type(Either{Integer}, Const{Number}) == Either{Number}
@test promote_type(Either{Number}, Const{Integer}) == Either{Number}
@test promote_type(Either{Number, String}, Const{Integer}) == Either{Number, String}

@test promote_type(Either{String, Integer}, Identity{Number}) == Either{String, Number}
@test promote_type(Either{String, Number}, Identity{Integer}) == Either{String, Number}
@test promote_type(Either{String, Integer}, Identity) == Either{String}
@test promote_type(Either{<:Any, Integer}, Identity) == Either
@test promote_type(Either{<:Any, Integer}, Identity{Number}) == Either{<:Any, Number}


# OptionEither
# ============

@test promote_type(Identity{Number}, Const{Int}, Const{Nothing}) == Union{Const, Identity{Number}}

@test promote_type(Either{Number}, Const{Nothing}) == Either
@test promote_type(Either{Number, AbstractString}, Const{Nothing}) == Either{<:Any, AbstractString}
@test promote_type(Const{String}, Option{Number}) == Either{<:Any, Number}

@test promote_type(Identity{Number}, Const{String}, Option{Integer}) == Either{<:Any, Number}
@test promote_type(Identity{Integer}, Const{String}, Option{Number}) == Either{<:Any, Number}

@test promote_type(Identity, Const{String}, Option{Number}) == Either
@test promote_type(Either{<:Any, Int}, Identity, Const, Const{Nothing}) == Either

# TODO understand why this promote_type is not working, while doing it one after the other actually works...
# @test promote_type(Identity, Const{String}, Nothing, Const{AbstractString}) == OptionEither{AbstractString}
@test promote_type(Identity, Const{String}, Const{Nothing}, Const{AbstractString}) == Either
@test promote_type(promote_type(Identity, Const{String}, Const{Nothing}), Const{AbstractString}) == Either


# promote_typejoin
# ================


@test Base.promote_typejoin(Identity, Const{String}) == Either{String}

@test Base.promote_typejoin(Const{Nothing}, Identity{Number}) == Option{Number}
@test Base.promote_typejoin(Const{String}, Either{AbstractString}) == Either
@test Base.promote_typejoin(Option{Number}, Identity{Int}) == Option
@test Base.promote_typejoin(Const{Nothing}, Option) == Option
@test Base.promote_typejoin(Const{Nothing}, Identity{Number}) == Option{Number}
@test Base.promote_typejoin(Const{Nothing}, Identity) == Option

@test Base.promote_typejoin(Const{Int}, Either{Number}) == Either
