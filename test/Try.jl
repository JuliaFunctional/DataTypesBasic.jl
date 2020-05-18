@test issuccess(@Try 5)
@test !issuccess(@Try error("hi"))
@test isexception(@Try error("hi"))
@test !isexception(@Try 5)

@test (@Try error("hi")) isa Const{<:Thrown}


me = MultipleExceptions(ErrorException("hi"))
@test me.exceptions == (ErrorException("hi"),)
@test MultipleExceptions(me, ErrorException("ho")).exceptions == (ErrorException("hi"), ErrorException("ho"))


@test eltype(Try{Int}) == Int
@test eltype(Identity{Int}) == Int
@test eltype(Thrown) == Any
@test eltype(Const{Thrown}) == Any
