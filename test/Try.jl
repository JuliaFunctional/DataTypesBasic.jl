using DataTypesBasic
using Test

@test Try(4) == Identity(4)
@test Try(ErrorException("hi")) == Const(ErrorException("hi"))

@test istry(Identity(4))
@test istry(Const(ErrorException("hi")))
@test istry(@Try error("an error"))
@test istry(@Try :value)
@test istry(@TryCatch ErrorException error("an error"))
@test istry(@TryCatch ErrorException :value)
@test !istry(Some(4))

@test issuccess(@Try 5)
@test !issuccess(@Try error("hi"))
@test_throws MethodError issuccess(Const("other"))

@test isfailure(@Try error("hi"))
@test !isfailure(@Try 5)
@test_throws MethodError isfailure(Const("other"))

@test Thrown(ErrorException("one"), []) == Thrown(ErrorException("one"), [])
@test repr(Thrown(ErrorException("some"), [])) == """Thrown(ErrorException("some"))"""



@test (@Try error("hi")) isa Const{<:Thrown}
@test (@TryCatch ErrorException error("hi")) isa Const{<:Thrown}
@test_throws ArgumentError (@TryCatch ErrorException throw(ArgumentError("bad")))

me = MultipleExceptions(ErrorException("hi"))
@test me.exceptions == (ErrorException("hi"),)
@test MultipleExceptions(me, ErrorException("ho")).exceptions == (ErrorException("hi"), ErrorException("ho"))

e1 = Thrown(ErrorException("one"), [])
e2 = AssertionError("error")
@test merge(e1, e2) == MultipleExceptions(e1, e2)
@test merge(e2, e1) == MultipleExceptions(e2, e1)
@test merge(e1, e1) == MultipleExceptions(e1, e1)
m12 = MultipleExceptions(e1, e2)
@test merge(e2, m12) == MultipleExceptions(e2, e1, e2)
@test merge(m12, e2) == MultipleExceptions(e1, e2, e2)
@test merge(m12, m12) == MultipleExceptions(e1, e2, e1, e2)


@test eltype(Try{Int}) == Int
@test eltype(Identity{Int}) == Int
@test eltype(Thrown) == Any
@test eltype(Const{Thrown}) == Any
@test eltype(Try) == Any
