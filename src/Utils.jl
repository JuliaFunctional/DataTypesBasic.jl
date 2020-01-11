module Utils
export Out

Out(f, types...) = Out(f, Tuple{types...})
Out(f, type::Tuple) = Core.Compiler.return_type(f, type)

end
