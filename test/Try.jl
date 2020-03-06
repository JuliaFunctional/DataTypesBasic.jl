@test issuccess(@Try 5)
@test !issuccess(@Try error("hi"))
@test isexception(@Try error("hi"))
@test !isexception(@Try 5)

@test (@Try error("hi")) isa Failure{Any}
@test (@Try Int error("hi")) isa Failure{Int}


me = MultipleExceptions(ErrorException("hi"))
@test me.exceptions == [ErrorException("hi")]
@test MultipleExceptions(me, ErrorException("ho")).exceptions == [ErrorException("hi"), ErrorException("ho")]
