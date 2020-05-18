@test isright(either("hi", true, 3))
@test isright(Either{String}(3))
@test !isleft(Either{String}(3))
@test getright(Either{String}(3)) == 3
@test_throws MethodError getleft(Either{String}(3))
@test getrightOption(Either{String}(3)) == Option(3)
@test getleftOption(Either{String}(3)) == Option{String}(nothing)

@test eltype(Either{Int, String}) == String
@test eltype(Either{<:Any, String}) == String
