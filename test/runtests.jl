using Test


@testset "aqua" begin
    include("./aqua.jl")
end

@testset "smoke" begin
    include("./smoke.jl")
end
