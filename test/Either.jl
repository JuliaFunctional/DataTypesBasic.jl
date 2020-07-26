@test Either{String, Int}(4) == Identity(4)
@test Either{String, Int}("left") == Const("left")
@test Either{Symbol}(true) == Identity(true)
@test Either{Symbol}(:fallback) == Const(:fallback)

@test @either(true ? 4 : "else") == Identity(4)
@test @either(false ? 4 : "else") == Const("else")
@test @either(if true
    4
else
    "else"
end) == Identity(4)
@test @either(if false
    4
else
    "else"
end) == Const("else")

@test iseither(Identity(4))
@test iseither(Const("hi"))
@test !iseither(Base.Some(nothing))

@test isright(either("hi", true, 3))
@test isright(Either{String}(3))
@test !isleft(Either{String}(3))

@test getright(Either{String}(3)) == 3
@test_throws MethodError getright(Either{String}("hi"))

@test getleft(Either{String}("hi")) == "hi"
@test_throws MethodError getleft(Either{String}(3))

@test getrightOption(Either{String}(3)) == Option(3)
@test getrightOption(Either{String}("fallback")) == Option()

@test getleftOption(Either{String}(3)) == Option()
@test getleftOption(Either{String}("fallback")) == Option("fallback")

@test getOption(Either{String}(3)) == Option(3)
@test getOption(Either{String}("fallback")) == Option()


@test eltype(Either{Int, String}) == String
@test eltype(Either{<:Any, String}) == String
@test eltype(Either) == Any


@test flip_left_right(Const(4)) == Identity(4)
@test flip_left_right(Identity("hi")) == Const("hi")
h = Identity(:hellp)
@test flip_left_right(flip_left_right(h)) == h
