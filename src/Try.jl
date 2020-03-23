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
Failure{T}(failure::Failure) where T = Failure{T}(failure.exception, failure.stack)


function Base.show(io::IO, exc::Failure{T, E}) where {T, E}
  println(io, "Failure{$T, $E}")
  println(io, exc.exception)
  for (exc′, bt′) in exc.stack
    showerror(io, exc′, bt′)
    println(io)
  end
end

# == controversy https://github.com/JuliaLang/julia/issues/4648
Base.:(==)(a::Try, b::Try) = try_compare(a, b)
try_compare(a::Success, b::Success) = a.value == b.value
try_compare(a::Failure, b::Success) = false
try_compare(a::Success, b::Failure) = false
function try_compare(a::Failure{T}, b::Failure{T}) where T
  a.exception == b.exception && a.stack == b.stack
end
try_compare(a::Failure, b::Failure) = false

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

issuccess(t::Try) = try_issuccess(t)
try_issuccess(::Success) = true
try_issuccess(::Failure) = false

isfailure(t::Try) = try_isfailure(t)
try_isfailure(::Success) = false
try_isfailure(::Failure) = true

Base.get(t::Try) = try_get(t)
try_get(t::Success) = t.value
try_get(::Failure) = nothing

getOption(t::Try) = try_getOption(t)
try_getOption(t::Success) = Some(t.value)
try_getOption(::Failure{T}) where T = None{T}()

Base.convert(::Type{<:Option}, t::Try) = getOption(t)

Base.eltype(::Type{<:Try{T}}) where T = T
Base.eltype(::Type{<:Try}) = Any


Base.iterate(t::Try, state...) = try_iterate(t, state...)
try_iterate(t::Success) = t.value, nothing
try_iterate(t::Success, state) = state
try_iterate(t::Failure) = nothing

Base.foreach(t::Try) = try_foreach(t)
try_foreach(f, t::Success) = f(t.value); nothing
try_foreach(f, t::Failure) = nothing

Base.map(t::Try) = try_map(t)
try_map(func, t::Success) = Success(func(t.value))
try_map(f, t::Failure{T}) where T = Failure{Out(f, T)}(t.exception, t.stack)

Iterators.flatten(t::Try) = try_flatten(t)
try_flatten(x::Failure) = x
try_flatten(x::Success{<:Try}) = x.value
try_flatten(x::Success{Any}) = Iterators.flatten(Success(x.value))


# support for combining exceptions

struct MultipleExceptions <: Exception
  exceptions::Vector{Exception}
end
MultipleExceptions(e::Exception) = MultipleExceptions([e])
function MultipleExceptions(exceptions::Vararg{Exception})
  MultipleExceptions(vcat((e isa MultipleExceptions ? e.exceptions : [e] for e ∈ exceptions)...))
end

Base.:(==)(a::MultipleExceptions, b::MultipleExceptions) = a.exceptions == b.exceptions
