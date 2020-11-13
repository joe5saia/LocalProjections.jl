using LocalProjections
using Test

@testset "LocalProjections.jl" begin
    try
        include("level_test.jl")
    catch e
        showerror(stdout, e, backtrace())
        rethrow(e)
    end
end
