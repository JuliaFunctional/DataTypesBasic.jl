using Test
using DataTypesBasic

@testset "Const" begin
  include("Const.jl")
end
@testset "Identity" begin
  include("Identity.jl")
end
@testset "Either" begin
  include("Either.jl")
end
@testset "Option" begin
  include("Option.jl")
end
@testset "Try" begin
  include("Try.jl")
end
@testset "ContextManager" begin
  include("ContextManager.jl")
end

# TODO test typejoin rules
