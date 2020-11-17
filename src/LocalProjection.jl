
"""
Struct with the following fields
- df             
- horizons       
- models         
- transformfunc  
- grwthoffset    
- formula        
- regstyle       
- ynames         
"""
@with_kw struct LocalProjection
    df                  ::DataFrame
    horizons            ::Array{Int,1} = [1]
    models              ::Array{FixedEffectModel,1} = Array{FixedEffectModel,1}(undef, length(collect(horizons)))
    transformfunc       ::Symbol = :identity
    grwthoffset         ::Int = 0
    formula             ::FormulaTerm
    regstyle            ::Symbol = :rates
    ynames              ::Array{Symbol,1} = Array{Symbol,1}(undef, length(collect(horizons)))
end



#######################################################################
# LocalProjection functions
#######################################################################
"""
    makedepvars(lp::LocalProjection)
Takes the lhs variable from `lp.formula` and makes the cumlative growth  variables 
for each horizon specified by `horizons` for the y-variable. This updates the 
dataframe stored in `lp`. Also updates the `ynames` array with the name of the 
created variables
"""
function makedepvars(lp::LocalProjection)
    if lp.regstyle == :rates
        FΔ!(lp.df, Symbol(lp.formula.lhs), lp.horizons, getfield(Main, lp.transformfunc), lp.grwthoffset)
        lp.ynames .= [Symbol("FΔ", i, lp.formula.lhs) for i in lp.horizons]
    elseif lp.regstyle == :levels
        F!(lp.df, Symbol(lp.formula.lhs), lp.horizons, getfield(Main, lp.transformfunc))
        lp.ynames .= [Symbol("F", i, lp.formula.lhs) for i in lp.horizons]
    end
end

"""
    runregs(lp::LocalProjection)
Estimates the regression for each horizon using `FixedEffectModels.reg(lp.df, Term(lp.ynames[index]) ~ lp.formula.rhs)`
and store the estimated models in `lp.models`. The estimations are done lazely, i.e. each regression starts 
from scratch without saving intermediate computations common across each regression
"""
function runregs(lp::LocalProjection)
    for (index, value) in enumerate(lp.horizons)
        form = Term(lp.ynames[index]) ~ lp.formula.rhs
        lp.models[index] = reg(lp.df, form)
    end
end

"""
    coef(lp::LocalProjection, xname::Symbol)
Returns a vector of coefficients for the variable `xname` for each regression. `coef(lp, xname)[i] ` 
corresponds to the coefficient for the horizon `lp.horizons[i]`.
"""
function coef(lp::LocalProjection, xname::Symbol)
    idx = findfirst(Symbol.(coefnames(lp.models[1])) .== xname)
    β = [m.coef[idx] for m in lp.models]
    return β
end

"""
    se(lp::LocalProjection, xname::Symbol)
Returns a vector of standard errors for each coefficient for the variable `xname` for each regression. 
`se(lp, xname)[i] ` corresponds to the se for the horizon `lp.horizons[i]`.
"""
function se(lp::LocalProjection, xname::Symbol)
    idx = findfirst(Symbol.(coefnames(lp.models[1])) .== xname)
    se = [sqrt(vcov(m)[idx, idx]) for m in lp.models]
    return se
end

"""
    coef_se(lp::LocalProjection, xname::Symbol)
Returns a dataframe with the columns `[horizons, β, se]` aligning the 
estimated coefficient, standard error and horizon that these correspond to. 
Constructed from
`DataFrame(horizons = lp.horizons, β = coef(lp, xname), se = se(lp, xname))`
"""
function coef_se(lp::LocalProjection, xname::Symbol)
    return DataFrame(horizons = lp.horizons, β = coef(lp, xname), se = se(lp, xname))
end