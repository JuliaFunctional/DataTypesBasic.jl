using Test
using DataTypesBasic
using TypeClasses
using Traits

@traitsof_init(TypeClasses.traitsof)
TypeClasses.@traitsof_linkall

@testset "Const" begin
  include("DataTypes/Const.jl")
end
@testset "Identity" begin
  include("DataTypes/Identity.jl")
end
@testset "Either" begin
  include("DataTypes/Either.jl")
end
@testset "Maybe" begin
  include("DataTypes/Maybe.jl")
end
@testset "Try" begin
  include("DataTypes/Try.jl")
end
@testset "ContextManager" begin
  include("DataTypes/ContextManager.jl")
end

@testset "FFlatten" begin
  include("FFlatten.jl")
end
@testset "Sequence" begin
  include("Sequence.jl")
end
