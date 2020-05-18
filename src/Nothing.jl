Base.iterate(::Nothing) = nothing
Base.foreach(f, ::Nothing) = nothing
Base.map(f, ::Nothing) = nothing
Iterators.flatten(::Nothing) = nothing


# we need this for safety, if someone overwrites typejoin for Unions with Const
Base.typejoin(::Type{Nothing}, ::Type{Nothing}) = Nothing
