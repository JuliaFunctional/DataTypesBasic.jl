using Test
using DataTypesBasic

@test convert(Const, []) == Const(nothing)
@test_throws AssertionError convert(Const, [1,2,3])

@test convert(Vector, Identity("hello")) == ["hello"]
@test convert(Vector, Const(43)) == []
@test convert(Vector, @ContextManager cont -> cont(2)) == [2]
@test_throws MethodError convert(Vector, nothing)

@test convert(Identity, @ContextManager cont -> cont(2)) == Identity(2)
@test_throws MethodError convert(Identity, [1,2,3])

@test run(convert(ContextManager, Identity(4))) == 4
@test_throws MethodError convert(ContextManager, nothing)
@test_throws MethodError convert(ContextManager, Const(:error))
@test_throws MethodError convert(ContextManager, [1,2,3])


@test convert(Either{String, Float32}, Identity(1)) == Identity(Float32(1))
@test convert(Either{String, Int}, Identity(1)) == Identity(1)
@test_throws MethodError convert(Either{String, Int}, Identity("hi"))

@test convert(Either{Float32, Int}, Const(1)) == Const(Float32(1))
@test convert(Either{Int, Int}, Const(1)) == Const(Float32(1))
@test_throws MethodError convert(Either{String, Int}, Const(1))



@test convert(Either{String}, Identity(1)) == Identity(1)
@test convert(Either{String}, Const("hi")) == Const("hi")
@test convert(Either{Float32}, Const(1)) == Const(Float32(1))
@test_throws MethodError convert(Either{Float32}, Const("hi"))


@test convert(Either{<:Any, String}, Const(1)) == Const(1)
@test convert(Either{<:Any, String}, Identity("hi")) == Identity("hi")
@test convert(Either{<:Any, Float32}, Identity(1)) == Identity(Float32(1))
@test_throws MethodError convert(Either{<:Any, Float32}, Identity("hi"))
