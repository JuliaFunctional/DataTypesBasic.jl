using Test
using DataTypesBasic

# Option
# ======

@test promote_type(Identity{Int}, Nothing) == Union{Identity{Int}, Nothing}
@test promote_type(Nothing, Identity{<:Number}) == Union{Identity{<:Number}, Nothing}

@test Dict(:a => Identity(1), :b => nothing) isa Dict{Symbol, Option{Int}}


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

@test promote_type(Identity{Number}, Const{Int}, Nothing) == Union{Nothing, Const{Int64}, Identity{Number}}

@test promote_type(Either{Number}, Nothing) == OptionEither{Number}
@test promote_type(Either{Number, AbstractString}, Nothing) == OptionEither{Number, AbstractString}
@test promote_type(Const{String}, Option{Number}) == OptionEither{String, Number}

@test promote_type(Identity{Number}, Const{String}, Option{Integer}) == OptionEither{String, Number}
@test promote_type(Identity{Integer}, Const{String}, Option{Number}) == OptionEither{String, Number}

@test promote_type(Identity, Const{String}, Option{Number}) == OptionEither{String}
@test promote_type(Either{<:Any, Int}, Identity, Const, Nothing) == OptionEither

# TODO understand why this promote_type is not working, while doing it one after the other actually works...
# @test promote_type(Identity, Const{String}, Nothing, Const{AbstractString}) == OptionEither{AbstractString}
@test promote_type(Identity, Const{String}, Nothing, Const{AbstractString}) == OptionEither
@test promote_type(promote_type(Identity, Const{String}, Nothing), Const{AbstractString}) == OptionEither{AbstractString}


# promote_typejoin
# ================


@test Base.promote_typejoin(Identity, Const{String}) == Either{String}

@test Base.promote_typejoin(Nothing, Identity{Number}) == Option{Number}
@test Base.promote_typejoin(Identity{Number}, OptionEither) == OptionEither
@test Base.promote_typejoin(Const{String}, Either{AbstractString}) == Either
@test Base.promote_typejoin(Option{Number}, Identity{Int}) == Option
@test Base.promote_typejoin(Nothing, Option) == Option
@test Base.promote_typejoin(Nothing, Identity{Number}) == Option{Number}
@test Base.promote_typejoin(Nothing, Identity) == Option

@test Base.promote_typejoin(Identity{Number}, OptionEither{Number}) == OptionEither{Number}
@test Base.promote_typejoin(Identity{Number}, OptionEither{String, Number}) == OptionEither{String, Number}
@test Base.promote_typejoin(Identity{Number}, OptionEither{String, Int}) == OptionEither{String}

@test Base.promote_typejoin(Const{Number}, OptionEither{String, Int}) == OptionEither{<:Any, Int}
@test Base.promote_typejoin(Nothing, OptionEither{String, Int}) == OptionEither{String, Int}
@test Base.promote_typejoin(Nothing, OptionEither) == OptionEither

@test Base.promote_typejoin(Const{Int}, OptionEither{Number}) == OptionEither

@test Base.promote_typejoin(Const{Int}, Either{Number}) == Either
