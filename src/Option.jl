

abstract type Option{T} end

struct None{T} <: Option{T} end

struct Some{T} <: Option{T}
  value::T
end
Some(value::T) where T = Some{T}(value)

Option{T}(a::Nothing) where T = None{T}()
Option{T}(a::T) where T = Some{T}(a)
Option(a::Nothing) = None{Any}()
Option(a::T) where T = Some{T}(a)
Option{T}() where T = None{T}()
Option() = None{Any}()

# == controversy https://github.com/JuliaLang/julia/issues/4648
Base.:(==)(a::Option, b::Option) = option_compare(a, b)
option_compare(a::Some, b::Some) = a.value == b.value
option_compare(a::None, b::Some) = false
option_compare(a::Some, b::None) = false
option_compare(a::None{T}, b::None{T}) where T = true
option_compare(a::None, b::None) = false
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

Base.isnothing(m::Option) = option_isnothing(m)
option_isnothing(m::None) = true
option_isnothing(m::Some) = false

issomething(m::Option) = option_issomething(m)
option_issomething(m::None) = false
option_issomething(m::Some) = true

Base.get(m::Option) = option_get(m)
option_get(m::Some) = m.value
option_get(m::None) = nothing

Base.eltype(::Type{<:Option{T}}) where T = T
Base.eltype(::Type{<:Option}) = Any

Base.iterate(o::Option, state...) = option_iterate(o, state...)
option_iterate(o::Some) = o.value, nothing
option_iterate(o::Some, state) = state
option_iterate(o::None) = nothing

Base.foreach(f, o::Option) = option_foreach(f, o)
option_foreach(f, o::Some) = f(o.value); nothing
option_foreach(f, o::None) = nothing

Base.map(f, o::Option) = option_map(f, o)
option_map(f, o::Some{T}) where T = Some(f(o.value))
function option_map(f, ::None{T}) where T
  _T2 = Out(f, T)
  T2 = _T2 === NotApplicable ? Any : _T2
  None{T2}()
end

Iterators.flatten(x::Option) = option_flatten(x)
option_flatten(x::None) = x
option_flatten(x::Some{<:Option}) = x.value
option_flatten(x::Some{Any}) = Iterators.flatten(Some{typeof(x.value)}(x.value))  # this fixes the type-information which will never return Any

# getOption tries to transform into Option
getOption(v::Option) = v
