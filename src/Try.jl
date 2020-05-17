struct Success{T}
  value::T
end
# the parameter is not used at all, only for making Failure a subtype of Try{T} for arbitrary T
struct Failure{E}
  exception::E
  stack::Vector
end
Failure(exception) = Failure(exception, [])

const Try{T, E} = Union{Failure{E}, Success{T}}
Try(t::T) where T = Success{T}(t)
Try(t::Exception) = Failure(t, [])
Try{T}(t::T) where T = Success{T}(t)
Try{T}(other) where T = Failure(other, [])

# typejoin Failure & Failure
Base.typejoin(::Type{Failure{E}}, ::Type{Failure{E}}) where E = Failure{E}
Base.typejoin(::Type{<:Failure}, ::Type{<:Failure}) = Failure
# typejoin Success & Success
Base.typejoin(::Type{Success{T}}, ::Type{Success{T}}) where T = Success{E}
Base.typejoin(::Type{<:Success}, ::Type{<:Success}) = Success
# typejoin Failure & Success
Base.typejoin(::Type{Failure{E}}, ::Type{Success{T}}) where {T, E} = Try{T, E}
Base.typejoin(::Type{Success{T}}, ::Type{Failure{E}}) where {T, E} = Try{T, E}
# typejoin Failure & Try
Base.typejoin(::Type{Failure{E}}, ::Type{<:Try{T, E}}) where {T, E} = Try{T, E}
Base.typejoin(::Type{<:Try{T, E}}, ::Type{Failure{E}}) where {T, E} = Try{T, E}
Base.typejoin(::Type{<:Failure}, ::Type{<:Try{T}}) where T = Try{T}
Base.typejoin(::Type{<:Try{T}}, ::Type{<:Failure}) where T = Try{T}
# typejoin Success & Try
Base.typejoin(::Type{Success{T}}, ::Type{<:Try{T, E}}) where {T, E} = Try{T, E}
Base.typejoin(::Type{<:Try{T, E}}, ::Type{Success{T}}) where {T, E} = Try{T, E}
Base.typejoin(::Type{<:Success}, ::Type{<:Try{<:Any, E}}) where E = Try{<:Any, E}
Base.typejoin(::Type{<:Try{<:Any, E}}, ::Type{<:Success}) where E = Try{<:Any, E}
# typejoin Try & Try
Base.typejoin(::Type{<:Try{T, E}}, ::Type{<:Try{T, E}}) where {T, E} = Try{T, E}
Base.typejoin(::Type{<:Try{T}}, ::Type{<:Try{T}}) where {T} = Try{T}
Base.typejoin(::Type{<:Try{<:Any, E}}, ::Type{<:Try{<:Any, E}}) where {E} = Try{<:Any, E}
Base.typejoin(::Type{<:Try}, ::Type{<:Try}) = Try

# Try/Success are covariate
Base.convert(::Type{Success{T}}, x::Success{S}) where {S, T} = Success(Base.convert(T, x.value))
Base.convert(::Type{Try{T}}, x::Success{S}) where {S, T} = Success(Base.convert(T, x.value))
promote_rule(::Type{Success{T}}, ::Type{Success{S}}) where {T, S<:T} = Success{T}
promote_rule(::Type{Try{T}}, ::Type{Try{S}}) where {T, S<:T} = Try{T}


# Multiline version, following https://docs.julialang.org/en/v1/manual/types/#man-custom-pretty-printing-1
function Base.show(io::IO, ::MIME"text/plain", exc::Failure{E}) where {E}
  println(io, "Failure{$E}($(repr(exc.exception)))")
  for (exc′, bt′) in exc.stack
    showerror(io, exc′, bt′)
    println(io)
  end
end

# == controversy https://github.com/JuliaLang/julia/issues/4648
Base.:(==)(a::Success, b::Success) = a.value == b.value
Base.:(==)(a::Failure, b::Success) = false
Base.:(==)(a::Success, b::Failure) = false
function Base.:(==)(a::Failure, b::Failure)
  a.exception == b.exception && a.stack == b.stack
end


# we use a macro instead of dispatching on Try(f::Function) as this interferes e.g. with mapn
# (in mapn anonymous functions are passed through, which should not get executed automatically)
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

# version which supports catching only specific errors
macro TryCatch(exception, expr)
  quote
    try
      r = $(esc(expr))
      Success{typeof(r)}(r)
    catch exc
      if exc isa $(esc(exception))
        Failure(exc, Base.catch_stack())
      else
        rethrow()
      end
    end
  end
end

issuccess(::Success) = true
issuccess(::Failure) = false

isfailure(::Success) = false
isfailure(::Failure) = true

Base.get(t::Success) = t.value
Base.get(::Failure) = nothing

getOption(t::Success) = Some(t.value)
getOption(::Failure) = none

Base.eltype(::Type{<:Try{T}}) where T = T
Base.eltype(::Type{<:Success{T}}) where T = T
Base.eltype(::Type{<:Failure}) = Any
Base.eltype(::Type{<:Try}) = Any

Base.iterate(t::Success) = t.value, nothing
Base.iterate(t::Success, state) = state
Base.iterate(t::Failure) = nothing

Base.foreach(f, t::Success) = f(t.value); nothing
Base.foreach(f, t::Failure) = nothing

Base.map(f, t::Success) = @Try f(t.value)
Base.map(f, t::Failure) = t

Iterators.flatten(x::Failure) = x
Iterators.flatten(x::Success) = convert(Try, x.value)



# support for combining exceptions

struct MultipleExceptions <: Exception
  exceptions::Vector{Exception}
end
MultipleExceptions(e::Exception) = MultipleExceptions([e])
function MultipleExceptions(exceptions::Vararg{Exception})
  MultipleExceptions(vcat((e isa MultipleExceptions ? e.exceptions : [e] for e ∈ exceptions)...))
end

Base.:(==)(a::MultipleExceptions, b::MultipleExceptions) = a.exceptions == b.exceptions
