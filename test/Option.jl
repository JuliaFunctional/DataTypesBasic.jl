using Test
using DataTypesBasic

@test isidentity(Option(5))
@test !isidentity(Option(nothing))
@test isconst(Option(nothing))
@test !isconst(Option(5))

@test iftrue(false) do
  54
end == Option()
@test iftrue(true) do
  54
end == Option(54)
@test iftrue(false, :Something) == Option()
@test iftrue(true, :Something) == Option(:Something)

@test iffalse(false, 54) == Option(54)
@test iffalse(true, 54) == Option()
@test iffalse(() -> "hi", false) == Option("hi")
@test iffalse(() -> "hi", true) == Option()

@test eltype(Option{Int}) == Int
@test eltype(Option) == Any

@test isoption(Identity(3))
@test isoption(Option())
@test !isoption(Const("anything but nothing"))

@test issome(Option(3))
@test !issome(Option())
@test_throws MethodError issome(Const("other"))

@test !isnone(Option(3))
@test isnone(Option())
@test_throws MethodError isnone(Const("other"))
