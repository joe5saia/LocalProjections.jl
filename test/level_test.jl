using DataFrames
using Random
using LinearAlgebra
using FixedEffectModels

Random.seed!(123)
N = 2
T = 100_000
x = randn(T,N)
β = [1 0; -1 2; 0.5 0.6 ; 0.3 0; 0.2 1]
y = zeros(Float64, T)
for t in 1:T,l in 0:min(4,t-1)
    y[t] += dot(β[l+1, :], x[t-l, :]) + 0.01*randn()
end

# Make the dataframe
df = DataFrame(y=y)
df[!, :x1] = x[:, 1]
df[!, :x2] = x[:, 2]

# Make Lags
L!(df, :x1, 1:5)
L!(df, :x2, 1:5)

Term.(vcat([:x1, :x2], [Symbol("L",i,"x1") for i in 1:5], [Symbol("L",i,"x2") for i in 1:5]))
f = Term(:y) ~ foldl(+, Term.(vcat([:x1, :x2], [Symbol("L",i,"x1") for i in 1:5], [Symbol("L",i,"x2") for i in 1:5])))

lp = LocalProjection(;df=df, horizons=1:10, formula = f, regstyle=:levels)

makedepvars(lp)
runregs(lp)

@test all(round.(LocalProjections.coef(lp, :x1); digits=1)[1:4] .== β[2:end,1])
@test all(round.(LocalProjections.coef(lp, :x2); digits=1)[1:4] .== β[2:end,2])