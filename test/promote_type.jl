using Test
using DataTypesBasic

# Option
# ======

@test promote_type(Identity{Int}, Nothing) == Union{Identity{Int}, Nothing}
@test promote_type(Nothing, Identity{<:Number}) == Union{Identity{<:Number}, Nothing}


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



# promote_typejoin
# ================

multiple_args = [
    (Identity, Const{String}),
    (Nothing, Identity{Number}),
    (Identity{Number}, OptionEither),
    (Const{String}, Either{AbstractString}),
    (Option{Number}, Identity{Int}),
    (Nothing, Option),
]
for args in multiple_args
    @test Base.promote_typejoin(args...) == promote_type(args...)
end

# TODO test promote_typejoin more intense as soon as it differs from promote_type
