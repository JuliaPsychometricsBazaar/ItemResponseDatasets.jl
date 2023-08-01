using ItemResponseDatasets
using Documenter

format = Documenter.HTML(
    prettyurls=get(ENV, "CI", "false") == "true",
    canonical="https://JuliaPsychometricsBazaar.github.io/ItemResponseDatasets.jl",
)

makedocs(;
    modules=[ItemResponseDatasets],
    authors="Frankie Robertson",
    repo="https://github.com/JuliaPsychometricsBazaar/ItemResponseDatasets.jl/blob/{commit}{path}#{line}",
    sitename="ItemResponseDatasets.jl",
    format=format,
    pages=[
        "Getting started" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/JuliaPsychometricsBazaar/ItemResponseDatasets.jl",
    devbranch="main",
)
