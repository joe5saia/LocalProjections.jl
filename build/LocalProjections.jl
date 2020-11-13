module LocalProjections

using DataFrames
using FixedEffectModels
using Random
using ShiftedArrays
using Parameters: @with_kw 


include("LocalProjection.jl")
include("time_constructors.jl")

export LocalProjection, makedepvars, runregs, coef, se, coef_se
export  F!, L!, FΔ!, LΔ!, Δ

end
