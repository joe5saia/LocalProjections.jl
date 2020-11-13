

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
function makedepvars(lp::LocalProjection)
    if lp.regstyle == :rates
        FΔ!(lp.df, Symbol(lp.formula.lhs), lp.horizons, getfield(Main, lp.transformfunc), lp.grwthoffset)
        lp.ynames .= [Symbol("FΔ", i, lp.formula.lhs) for i in lp.horizons]
    elseif lp.regstyle == :levels
        F!(lp.df, Symbol(lp.formula.lhs), lp.horizons, getfield(Main, lp.transformfunc))
        lp.ynames .= [Symbol("F", i, lp.formula.lhs) for i in lp.horizons]
    end
end

function runregs(lp::LocalProjection)
    for (index, value) in enumerate(lp.horizons)
        form = Term(lp.ynames[index]) ~ lp.formula.rhs
        lp.models[index] = reg(lp.df, form)
    end
end

function coef(lp::LocalProjection, xname::Symbol)
    idx = findfirst(Symbol.(coefnames(lp.models[1])) .== xname)
    β = [m.coef[idx] for m in lp.models]
    return β
end

function se(lp::LocalProjection, xname::Symbol)
    idx = findfirst(Symbol.(coefnames(lp.models[1])) .== xname)
    se = [sqrt(vcov(m)[idx, idx]) for m in lp.models]
    return se
end

function coef_se(lp::LocalProjection, xname::Symbol)
    return DataFrame(horizons = lp.horizons, β = coef(lp, xname), se = se(lp, xname))
end