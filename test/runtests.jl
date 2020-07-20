using Test
using DataTypesBasic

@test isempty(detect_ambiguities(DataTypesBasic))

@testset "Identity" begin
  include("Identity.jl")
end
@testset "Const" begin
  include("Const.jl")
end
@testset "Option" begin
  include("Option.jl")
end
@testset "Either" begin
  include("Either.jl")
end
@testset "Try" begin
  include("Try.jl")
end
@testset "ContextManager" begin
  include("ContextManager.jl")
end


@testset "convert" begin
  include("convert.jl")
end
@testset "promote_type" begin
  include("promote_type.jl")
end
