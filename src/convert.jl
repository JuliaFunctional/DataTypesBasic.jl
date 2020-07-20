# conversions among concrete types
# ================================

# Vector
# ------

Base.convert(::Type{<:Vector}, x::Identity) = [x.value]
Base.convert(::Type{<:Vector}, x::Nothing) = []
Base.convert(::Type{<:Vector}, x::Const) = []
# ContextManager is executed if someone asks for a Vector from ContextManager
Base.convert(::Type{<:Vector}, x::ContextManager) = [x(identity)]

# Const
# -----

function Base.convert(::Type{Const}, x::Vector)
  @assert !isempty(x) "can only convert empty Vector to Nothing, got $(x)"
  Const([])
end

# Identity
# --------

# Const are just passed through when asked to convert to identity
# this is intended special behaviour in order for Identity + Const to work together as Option/Either
Base.convert(::Type{Identity}, x::Const) = x
# ContextManager is executed
Base.convert(::Type{<:Identity}, x::ContextManager) = Identity(run(x))


# ContextManager
# --------------

Base.convert(::Type{<:ContextManager}, x::Identity) = @ContextManager cont -> cont(x.value)

# Note that we do not support convert from Const to ContextManager.
# ContextManager is similar to Identity a Container which always contains a single element,
# however, unlike Identity, we cannot simply pass-through Const and preserve the empty container by this trick.
# To map over ContextManager, you NEED to create a new ContextManager, if you don't want to run the contextmanager
# immediately. Hence, also flatmap needs to create another ContextManager, i.e. single element container.

# Vector is neither supported, as it rather corresponds to Continuable which can have several calls to `cont`
# while ContextManager should only have one call to `cont`.


# conversions among Union Types
# =============================

# Option
# ------

# we need to overwrite convert, because in the case that no conversion is possible, we currently get the super uninformative error
# ERROR: could not compute non-nothing type
# Stacktrace:
#  [1] nonnothingtype_checked(::Type) at ./some.jl:29
#  [2] convert(::Type{Union{Nothing, Some{T}} where T}, ::Int64) at ./some.jl:34
#  [3] top-level scope at none:0
# importantly, we should only add clauses for Type{Option} and not Type{<:Option} to not interfere with existing code
Base.convert(::Type{Option}, x::Option) = x

Base.convert(::Type{Option{T}}, x::Identity) where T = Identity(Base.convert(T, x))
Base.convert(::Type{Option{T}}, x::Identity{T}) where T = x  # nothing to convert
Base.convert(::Type{Option{T}}, x::Const{Nothing}) where T = x  # nothing to convert
Base.convert(::Type{Option}, x::Const{Nothing}) = x  # nothing to convert
Base.convert(::Type{Option}, x::Identity) = x  # nothing to convert


# Either
# ------

Base.convert(::Type{Either{L, R}}, x::Identity) where {L, R} = Identity(Base.convert(R, x.value))
Base.convert(::Type{Either{L, R}}, x::Identity{R}) where {L, R} = x  # nothing to convert
Base.convert(::Type{Either{L, R}}, x::Const) where {L, R} = Const(Base.convert(L, x.value))
Base.convert(::Type{Either{L, R}}, x::Const{L}) where {L, R} = x  # nothing to convert

Base.convert(::Type{Either{<:Any, R}}, x::Identity) where {R} = Identity(Base.convert(R, x.value))
Base.convert(::Type{Either{<:Any, R}}, x::Identity{R}) where {R} = x  # nothing to convert
Base.convert(::Type{Either{L, <:Any}}, x::Const) where {L} = Const(Base.convert(L, x.value))
Base.convert(::Type{Either{L, <:Any}}, x::Const{L}) where {L} = x  # nothing to convert
