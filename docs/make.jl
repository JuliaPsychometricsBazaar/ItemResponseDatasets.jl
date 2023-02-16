using ItemResponseDatasets
using Documenter

format = Documenter.HTML(
    prettyurls=get(ENV, "CI", "false") == "true",
    canonical="https://JuliaPsychometricsBazzar.github.io/ItemResponseDatasets.jl",
)

makedocs(;
    modules=[ItemResponseDatasets],
    authors="Frankie Robertson",
    repo="https://github.com/JuliaPsychometricsBazzar/ItemResponseDatasets.jl/blob/{commit}{path}#{line}",
    sitename="ItemResponseDatasets.jl",
    format=format,
    pages=[
        "Getting started" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/JuliaPsychometricsBazzar/ItemResponseDatasets.jl",
    devbranch="main",
)
