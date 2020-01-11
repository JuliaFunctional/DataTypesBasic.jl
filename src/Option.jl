abstract type Option{T} end
struct None{T} <: Option{T} end
struct Some{T} <: Option{T}
  value::T
end

Option{T}(a::Nothing) where T = None{T}()
Option{T}(a::T) where T = Some{T}(a)
Option(a::Nothing) = None{Any}()
Option(a::T) where T = Some{T}(a)
Option{T}() where T = None{T}()
Option() = None{Any}()

# == controversy https://github.com/JuliaLang/julia/issues/4648
Base.:(==)(a::Some, b::Some) = a.value == b.value
Base.:(==)(a::None, b::Some) = false
Base.:(==)(a::Some, b::None) = false
Base.:(==)(a::None{T}, b::None{T}) where T = true
Base.:(==)(a::None, b::None) = false
# TypeClasses.unionall_implementationdetails(::Type{<:Option{T}}) where T = Option{T}
# Traits.leaftypes(::Type{Option}) = [Option{newtype(), Some}, Option{newtype(), None}]

function iftrue(func::Function, b::Bool)
  b ? Some(func()) : None{Out(func)}()
end
function iftrue(b::Bool, t::T) where T
  b ? Some{T}(t) : None{T}()
end
function iffalse(func::Function, b::Bool)
  !b ? Some(func()) : None{Out(func)}()
end
function iffalse(b::Bool, t::T) where T
  !b ? Some{T}(t) : None{T}()
end

Base.isnothing(m::None) = true
Base.isnothing(m::Some) = false
issomething(m::None) = false
issomething(m::Some) = true

Base.get(m::Some) = m.value
Base.get(m::None) = nothing

Base.eltype(::Type{<:Option{T}}) where T = T
Base.eltype(::Type{<:Option}) = Any

Base.iterate(o::Some) = o.value, nothing
Base.iterate(o::Some, state) = state
Base.iterate(o::None) = nothing

Base.foreach(f, o::Some) = f(o.value); nothing
Base.foreach(f, o::None) = nothing

Base.map(f, o::None{T}) where T = None{Out(f, T)}()
Base.map(f, o::Some) = Some(f(o.value))
