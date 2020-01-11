# tag
abstract type Try{T} end
struct Success{T} <: Try{T}
  value::T
end

struct Failure{T, E} <: Try{T}
  exception::E
  stack::Vector
end
Failure{T}(exception::E, stack::Vector) where {T, E} = Failure{T, E}(exception, stack)
Failure(exception::E, stack::Vector) where {E} = Failure{Any, E}(exception, stack)

function Base.show(io::IO, exc::Failure)
  print(io, exc.exception)
  for (exc′, bt′) in exc.stack
    showerror(io, exc′, bt′)
    println(io)
  end
end

# == controversy https://github.com/JuliaLang/julia/issues/4648
Base.:(==)(a::Success, b::Success) = a.value == b.value
Base.:(==)(a::Failure, b::Success) = false
Base.:(==)(a::Success, b::Failure) = false
function Base.:(==)(a::Failure{T}, b::Failure{T}) where T
  a.exception == b.exception && a.stack == b.stack
end
Base.:(==)(a::Failure, b::Failure) = false

# TypeClasses.unionall_implementationdetails(::Type{<:Try{T}}) where T = Try{T}
# Traits.leaftypes(::Type{Try}) = [Try{newtype(), Success}, Try{newtype(), Exception}]


Try{T}(t::T) where T = Success{T}(t)
Try{T}(t::Exception) where T = Failure{T}(t, [])
Try{T}(t::Success{T}) where T = t
Try{T}(t::Failure{T}) where T = t

Try(t::T) where T = Success{T}(t)
Try(t::Exception) = Failure{Any}(t, [])
Try(t::Success) = t
Try(t::Failure) = t


# we cannot use Try(f::Function) as this interferes e.g. with mapn (in mapn anonymous functions are passed through, which should not get executed automatically)
macro Try(expr)
  quote
    try
      r = $(esc(expr))
      Success{typeof(r)}(r)
    catch exc
      Failure(exc, Base.catch_stack())
    end
  end
end

macro Try(T, expr)
  quote
    r = try
      $(esc(expr))
    catch exc
      Failure{$T}(exc, Base.catch_stack())
    end
    Try{$T}(r)
  end
end


# version which supports catching only specific errors
macro TryCatch(exception, expr)
  quote
    try
      r = $(esc(expr))
      Success{typeof(r)}(r)
    catch exc
      if exc isa $(esc(exception))
        Failure{Any}(exc, Base.catch_stack())
      else
        rethrow()
      end
    end
  end
end

macro TryCatch(T, exception, expr)
  quote
    r = try
      $(esc(expr))
    catch exc
      if exc isa $(esc(exception))
        Failure{$T}(exc, Base.catch_stack())
      else
        rethrow()
      end
    end
    Try{$T}(r)
  end
end

issuccess(::Success) = true
issuccess(::Failure) = false
isfailure(::Success) = false
isfailure(::Failure) = true
isexception(::Success) = false
isexception(::Failure) = true

Base.get(t::Success) = t.value
Base.get(::Failure) = nothing
getOption(t::Success) = Some(t.value)
getOption(::Failure{T}) where T = None{T}()
Base.convert(::Type{<:Option}, t::Try) = getOption(t)

Base.eltype(::Type{<:Try{T}}) where T = T
Base.eltype(::Type{<:Try}) = Any

Base.iterate(t::Success) = t.value, nothing
Base.iterate(t::Success, state) = state
Base.iterate(t::Failure) = nothing

Base.foreach(f, t::Success) = f(t.value); nothing
Base.foreach(f, t::Failure) = nothing

Base.map(func, t::Success) = Success(func(t.value))
Base.map(f, t::Failure{T}) where T = Failure{Out(f, T)}(t.exception, t.stack)



# support for combining exceptions

struct MultipleExceptions <: Exception
  exceptions::Vector{Exception}
end
MultipleExceptions(e::Exception) = MultipleExceptions([e])
function MultipleExceptions(exceptions::Vararg{Exception})
  MultipleExceptions(vcat((e isa MultipleExceptions ? e.exceptions : [e] for e ∈ exceptions)...))
end

Base.:(==)(a::MultipleExceptions, b::MultipleExceptions) = a.exceptions == b.exceptions
