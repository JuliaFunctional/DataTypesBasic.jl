const Try{T} = Union{Const{<:Exception}, Identity{T}}
Try(t) = Identity(t)
Try(t::Exception) = Const(t)
Try{T}(t::T) where T = Identity(t)
Try{T}(other) where T = Const(other)



"""
Thrown is like Exception, however can also cary stacktraces
"""
struct Thrown{E} <: Exception
  exception::E
  stacktrace::Vector
end

# == controversy https://github.com/JuliaLang/julia/issues/4648
function Base.:(==)(a::Thrown, b::Thrown)
  a.exception == b.exception && a.stack == b.stack
end

function Base.show(io::IO, x::Thrown)
  print(io, "Thrown($(repr(x.exception)))")
end

# Multiline version, following https://docs.julialang.org/en/v1/manual/types/#man-custom-pretty-printing-1
function Base.show(io::IO, ::MIME"text/plain", exc::Thrown{E}) where {E}
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
Combine Multiple Exceptions
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

Base.merge(f1::Thrown, f2::Thrown) = MultipleExceptions((f1, f2))
Base.merge(f::Thrown, e::Exception) = MultipleExceptions((f, e))
Base.merge(e::Exception, f::Thrown) = MultipleExceptions((e, f))
Base.merge(es::MultipleExceptions, e::Exception) = MultipleExceptions(tuple(es.exceptions..., e))
Base.merge(e::Exception, fs::MultipleExceptions) = MultipleExceptions(tuple(e, fs.exceptions...))
Base.merge(es1::MultipleExceptions, es2::MultipleExceptions) = MultipleExceptions(tuple(es1.exceptions..., es2.exceptions...))

# enable Try for conversion
Base.convert(::Type{Try{T}}, x::Identity{S}) where {S, T} = Identity(Base.convert(T, x.value))
promote_rule(::Type{Try{T}}, ::Type{Try{S}}) where {T, S<:T} = Try{T}



# typejoin Thrown & Thrown
# Base.typejoin(::Type{Thrown{E}}, ::Type{Thrown{E}}) where E = Thrown{E}
# Base.typejoin(::Type{<:Thrown}, ::Type{<:Thrown}) = Thrown
# # typejoin Identity & Identity
# Base.typejoin(::Type{Identity{T}}, ::Type{Identity{T}}) where T = Identity{E}
# Base.typejoin(::Type{<:Identity}, ::Type{<:Identity}) = Identity
# # typejoin Thrown & Identity
# Base.typejoin(::Type{Thrown{E}}, ::Type{Identity{T}}) where {T, E} = Try{T, E}
# Base.typejoin(::Type{Identity{T}}, ::Type{Thrown{E}}) where {T, E} = Try{T, E}
# # typejoin Thrown & Try
# Base.typejoin(::Type{Thrown{E}}, ::Type{<:Try{T, E}}) where {T, E} = Try{T, E}
# Base.typejoin(::Type{<:Try{T, E}}, ::Type{Thrown{E}}) where {T, E} = Try{T, E}
# Base.typejoin(::Type{<:Thrown}, ::Type{<:Try{T}}) where T = Try{T}
# Base.typejoin(::Type{<:Try{T}}, ::Type{<:Thrown}) where T = Try{T}
# # typejoin Identity & Try
# Base.typejoin(::Type{Identity{T}}, ::Type{<:Try{T, E}}) where {T, E} = Try{T, E}
# Base.typejoin(::Type{<:Try{T, E}}, ::Type{Identity{T}}) where {T, E} = Try{T, E}
# Base.typejoin(::Type{<:Identity}, ::Type{<:Try{<:Any, E}}) where E = Try{<:Any, E}
# Base.typejoin(::Type{<:Try{<:Any, E}}, ::Type{<:Identity}) where E = Try{<:Any, E}
# # typejoin Try & Try
# Base.typejoin(::Type{<:Try{T, E}}, ::Type{<:Try{T, E}}) where {T, E} = Try{T, E}
# Base.typejoin(::Type{<:Try{T}}, ::Type{<:Try{T}}) where {T} = Try{T}
# Base.typejoin(::Type{<:Try{<:Any, E}}, ::Type{<:Try{<:Any, E}}) where {E} = Try{<:Any, E}
# Base.typejoin(::Type{<:Try}, ::Type{<:Try}) = Try




# we use a macro instead of dispatching on Try(f::Function) as this interferes e.g. with mapn
# (in mapn anonymous functions are passed through, which should not get executed automatically)
macro Try(expr)
  quote
    try
      r = $(esc(expr))
      Identity{typeof(r)}(r)
    catch exc
      Const(Thrown(exc, Base.catch_stack()))
    end
  end
end

# version which supports catching only specific errors
macro TryCatch(exception, expr)
  quote
    try
      r = $(esc(expr))
      Identity{typeof(r)}(r)
    catch exc
      if exc isa $(esc(exception))
        Const(Thrown(exc, Base.catch_stack()))
      else
        rethrow()
      end
    end
  end
end

issuccess(::Identity) = true
issuccess(::Const{<:Exception}) = false

isexception(::Identity) = false
isexception(::Const{<:Exception}) = true

Base.eltype(::Type{<:Try{T}}) where T = T
Base.eltype(::Type{<:Try}) = Any
# somehow the normal Const eltype got broken
Base.eltype(::Type{<:Const{<:Exception}}) = Any
