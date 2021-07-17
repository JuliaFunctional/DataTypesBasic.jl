
"""
    Try{T} = Union{Const{<:Exception}, Identity{T}}
    @Try(error("something happend")) isa Const(<:Thrown{ErrorException})
    @Try(:successfull) == Identity(:successfull)

A specific case of [`Either`](@ref), where the Failure is always an Exception.
This can be used as an alternative to using try-catch syntax and allows for very flexible
error handling, as the error is now captured in a proper defined type.
Often it is really handy to treat errors like other values (without the need of extra try-catch syntax which only
applies to exceptions).

We reuse [`Identity`](@ref) for representing the single-element-container and `Const(<:Exception)` as the Exception
thrown.
"""
const Try{T} = Union{Const{<:Exception}, Identity{T}}
Try(t) = Identity(t)
Try(t::Exception) = Const(t)


"""
    Thrown(exception, stacktrace)

Thrown is like Exception, however can also cary stacktraces
"""
struct Thrown{E, S} <: Exception
  exception::E
  stacktrace::S
end

# == controversy https://github.com/JuliaLang/julia/issues/4648
function Base.:(==)(a::Thrown, b::Thrown)
  a.exception == b.exception && a.stacktrace == b.stacktrace
end

function Base.show(io::IO, x::Thrown)
  print(io, "Thrown($(repr(x.exception)))")
end

# Multiline version, following https://docs.julialang.org/en/v1/manual/types/#man-custom-pretty-printing-1
function Base.show(io::IO, ::MIME"text/plain", exc::Thrown)
  println(io, "Thrown($(repr(exc.exception)))")
  for (exc′, bt′) in exc.stacktrace
    showerror(io, exc′, bt′)
    println(io)
  end
end
function Base.showerror(io::IO, ::MIME"text/plain", exc::Thrown)
  Base.show(io, MIME"text/plain"(), exc)
end

"""
    MultipleExceptions(exception1, exception2, ...)
    MultipleExceptions(tuple_or_vector_of_exceptions)

Little helper type which combines several Exceptions into one new Exception.

In the several arguments version, and only there, if an MultipleExceptions is given, it will be flattened directly for convenience.
"""
struct MultipleExceptions{Es<:Tuple} <: Exception
  exceptions::Es
  function MultipleExceptions(exceptions::Tuple)
    @assert(isempty(exceptions) || eltype(exceptions) <: Exception,
      "expecting tuple of exception types, however got `eltype(exceptions) = $(eltype(exceptions))`")
    new{typeof(exceptions)}(exceptions)
  end
end
MultipleExceptions(exceptions::Vector) = MultipleExceptions(tuple(exceptions...))
function MultipleExceptions(args...)
  exceptions = ()
  for a in args
    exceptions = a isa MultipleExceptions ? tuple(exceptions..., a.exceptions...) : tuple(exceptions..., a)
  end
  MultipleExceptions(exceptions)
end

# == controversy https://github.com/JuliaLang/julia/issues/4648
Base.:(==)(a::MultipleExceptions, b::MultipleExceptions) = a.exceptions == b.exceptions

# Multiline version, following https://docs.julialang.org/en/v1/manual/types/#man-custom-pretty-printing-1
function Base.show(io::IO, ::MIME"text/plain", exc::MultipleExceptions)
  println(io, "MultipleExceptions:")
  for exception in exc.exceptions
    println(repr(exception))
  end
end
function Base.showerror(io::IO, ::MIME"text/plain", exc::MultipleExceptions)
  Base.show(io, MIME"text/plain"(), exc)
end

Base.merge(e1::Exception, e2::Exception) = MultipleExceptions((e1, e2))
Base.merge(es::MultipleExceptions, e::Exception) = MultipleExceptions(tuple(es.exceptions..., e))
Base.merge(e::Exception, es::MultipleExceptions) = MultipleExceptions(tuple(e, es.exceptions...))
Base.merge(es1::MultipleExceptions, es2::MultipleExceptions) = MultipleExceptions(tuple(es1.exceptions..., es2.exceptions...))


# we use a macro instead of dispatching on Try(f::Function) as this interferes e.g. with mapn
# (in mapn anonymous functions are passed through, which should not get executed automatically)
"""
    @Try begin
      your_code
    end

Macro which directly captures an Excpetion into a proper `Try`representation.

It translates to
```julia
try
  r = your_code
  Identity(r)
catch exc
  Const(Thrown(exc, Base.catch_backtrace()))
end
```
"""
macro Try(expr)
  quote
    try
      r = $(esc(expr))
      Identity(r)
    catch exc
      Const(Thrown(exc, Base.catch_backtrace()))
    end
  end
end

"""
    @TryCatch YourException begin
      your_code
    end

A version of [`@Try`](@ref) which catches only specific errors.
Every other orrer will be `rethrown`.

It translates to
```julia
try
  r = your_code
  Identity(r)
catch exc
  if exc isa YourException
    Const(Thrown(exc, Base.catch_backtrace()))
  else
    rethrow()
  end
end
```
"""
macro TryCatch(exception, expr)
  quote
    try
      r = $(esc(expr))
      Identity(r)
    catch exc
      if exc isa $(esc(exception))
        Const(Thrown(exc, Base.catch_backtrace()))
      else
        rethrow()
      end
    end
  end
end


"""
    isoption(::Const{Nothing}) = true
    isoption(::Identity) = true
    isoption(other) = false

check whether something is a [`Try`](@ref)
"""
istry(::Identity) = true
istry(::Const{<:Exception}) = true
istry(other) = false

"""
    issuccess(::Identity) = true
    issuccess(::Const{<:Exception}) = false

Similar to [`isright`](@ref), but only defined for `Const{<:Exception}`. Will
throw MethodError when applied on other `Const`.
"""
issuccess(::Identity) = true
issuccess(::Const{<:Exception}) = false

"""
    isfailure(::Identity) = false
    isfailure(::Const{<:Exception}) = true

Similar to [`isleft`](@ref), but only defined for `Const{<:Exception}`. Will
throw MethodError when applied on other `Const`.
"""
isfailure(::Identity) = false
isfailure(::Const{<:Exception}) = true

Base.eltype(::Type{Try{T}}) where T = T
Base.eltype(::Type{Try}) = Any
