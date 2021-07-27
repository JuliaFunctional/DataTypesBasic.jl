using DataTypesBasic
using Documenter

makedocs(;
    modules=[DataTypesBasic],
    authors="Stephan Sahm <stephan.sahm@gmx.de> and contributors",
    repo="https://github.com/JuliaFunctional/DataTypesBasic.jl/blob/{commit}{path}#L{line}",
    sitename="DataTypesBasic.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://JuliaFunctional.github.io/DataTypesBasic.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "Manual" => "manual.md",
        "Library" => "library.md",
    ],
)

deploydocs(;
    repo="github.com/JuliaFunctional/DataTypesBasic.jl",
    devbranch="main",
)
