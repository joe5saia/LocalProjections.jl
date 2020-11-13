#######################################################################
# functions to makle lags and leads
#######################################################################
function F!(df, v, horizons=1, fun=identity)
    # Forward operator
    newvars = Symbol[]
    for i in horizons
        Fiv = Symbol("F$(i)$(v)")
        df[:, Fiv] = lead( map(fun, df[!, v]), i)
        push!(newvars, Fiv)
    end
    return newvars
end

function L!(df, v, horizons=1)
    # Lag operator
    newvars = Symbol[]
    for i in horizons
        Fiv = Symbol("L$(i)$(v)")
        df[:, Fiv] = lag(df[!, v], i)
        push!(newvars, Fiv)
    end
    return newvars
end

function FΔ!(df, v, horizons=1, fun=identity, baseperiod=0)
    # Forward difference operator
    newvars = Symbol[]
    for i in horizons
        Fiv = Symbol("FΔ$(i)$(v)")
        df[:, Fiv] = lead( map(fun, df[!, v]), i) .- lag(map(fun, df[!, v]), baseperiod)
        push!(newvars, Fiv)
    end
    return newvars
end

function LΔ!(df, v, horizons=1, fun=identity)
    # Lag difference operator
    newvars = Symbol[]
    for i in horizons
        Fiv = Symbol("LΔ$(i)$(v)")
        df[:, Fiv] = map(fun, df[!, v]) .-  lag( map(fun, df[!, v]), i)
        push!(newvars, Fiv)
    end
    return newvars
end

function Δ(x, horizons=1, fun=identity)
    return map(fun, x) .-  lag(map(fun, x), horizons)
end
