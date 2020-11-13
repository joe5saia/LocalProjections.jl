push!(LOAD_PATH,"../src/")
using LocalProjections
using Documenter

makedocs(;
    modules=[LocalProjections],
    authors="Joe Saia <joe5saia@gmail.com> and contributors",
    repo="https://github.com/joe5saia/LocalProjections.jl/blob/{commit}{path}#L{line}",
    sitename="LocalProjections.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://joe5saia.github.io/LocalProjections.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/joe5saia/LocalProjections.jl.git",
)
