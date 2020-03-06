@test isright(either("hi", true, 3))
@test isright(Either{String}(3))
@test !isleft(Either{String}(3))
@test getright(Either{String}(3)) == 3
@test getleft(Either{String}(3)) == nothing
@test getrightOption(Either{String}(3)) == Option(3)
@test getleftOption(Either{String}(3)) == Option{String}(nothing)
