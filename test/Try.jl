@test issuccess(@Try 5)
@test !issuccess(@Try error("hi"))
@test isfailure(@Try error("hi"))
@test !isfailure(@Try 5)

@test (@Try error("hi")) isa Stop{<:Failure}


me = MultipleExceptions(ErrorException("hi"))
@test me.exceptions == (ErrorException("hi"),)
@test MultipleExceptions(me, ErrorException("ho")).exceptions == (ErrorException("hi"), ErrorException("ho"))


@test eltype(Try{Int}) == Int
@test eltype(Identity{Int}) == Int
@test eltype(Failure) == Any
@test eltype(Stop{Failure}) == Any
