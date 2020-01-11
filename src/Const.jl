struct Const{E, T}
  value::T
end
Const(value) = Const{Any}(value)

# == controversy https://github.com/JuliaLang/julia/issues/4648
Base.:(==)(a::Const, b::Const) = a.value == b.value

# const just does nothing, i.e. leaves everything constant
Base.foreach(f, c::Const) = nothing
function Base.map(f, c::Const{E}) where E
  E2 = Core.Compiler.return_type(f, Tuple{E})
  Const{E2}(c.value)
end

Base.eltype(::Type{<:Const{E}}) where E = E
Base.eltype(::Type{<:Const}) = Any
