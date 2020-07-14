using DataTypesBasic
using Documenter

makedocs(;
    modules=[DataTypesBasic],
    authors="Stephan Sahm <stephan.sahm@gmx.de> and contributors",
    repo="https://github.com/schlichtanders/DataTypesBasic.jl/blob/{commit}{path}#L{line}",
    sitename="DataTypesBasic.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://schlichtanders.github.io/DataTypesBasic.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/schlichtanders/DataTypesBasic.jl",
)
