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
  @assert isempty(x) "can only convert empty Vector to Nothing, got $(x)"
  Const(nothing)  # == Option()
end

# Identity
# --------

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


# Option, Either, Try
# -------------------

Base.convert(::Type{Either{L, R}}, x::Identity) where {L, R} = Identity(Base.convert(R, x.value))
Base.convert(::Type{Either{L, R}}, x::Identity{R}) where {L, R} = x  # nothing to convert
Base.convert(::Type{Either{L, R}}, x::Const) where {L, R} = Const(Base.convert(L, x.value))
Base.convert(::Type{Either{L, R}}, x::Const{L}) where {L, R} = x  # nothing to convert

Base.convert(::Type{Either{<:Any, R}}, x::Identity) where {R} = Identity(Base.convert(R, x.value))
Base.convert(::Type{Either{<:Any, R}}, x::Identity{R}) where {R} = x  # nothing to convert
Base.convert(::Type{Either{L, <:Any}}, x::Const) where {L} = Const(Base.convert(L, x.value))
Base.convert(::Type{Either{L, <:Any}}, x::Const{L}) where {L} = x  # nothing to convert
