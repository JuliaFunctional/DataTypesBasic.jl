using Test
using DataTypesBasic

@test convert(Vector, Identity("hello")) == ["hello"]
@test convert(Vector, nothing) == []
@test convert(Vector, Const(43)) == []
@test convert(Vector, @ContextManager cont -> cont(2)) == [2]

@test convert(Identity, Option()) == Option()
@test convert(Identity, Const(:error)) == Const(:error)
@test convert(Identity, @ContextManager cont -> cont(2)) == Identity(2)
@test_throws MethodError convert(Identity, [1,2,3])

@test run(convert(ContextManager, Identity(4))) == 4
@test_throws MethodError convert(ContextManager, nothing)
@test_throws MethodError convert(ContextManager, Const(:error))
@test_throws MethodError convert(ContextManager, [1,2,3])
