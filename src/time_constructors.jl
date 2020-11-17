#######################################################################
# functions to makle lags and leads
#######################################################################

"""
    F!(df, v, horizons=1, fun=identity)

    Forward operator.
Applies function `fun` to the column `v` of `df` and then makes the 
leads specified by horizons and adds them to `df` as the column `F$(i)$(v)`.
Modifies `df`. 
Return the list of new columns created. 
"""
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

"""
    L!(df, v, horizons=1, fun=identity)

    Lag operator.
Applies function `fun` to the column `v` of `df` and then makes the 
laggs specified by horizons and adds them to `df` as the column `L$(i)$(v)`.
Modifies `df`. 
Return the list of new columns created. 
"""
function L!(df, v, horizons=1, fun=identity)
    # Lag operator
    newvars = Symbol[]
    for i in horizons
        Fiv = Symbol("L$(i)$(v)")
        df[:, Fiv] = lag(map(fun, df[!, v]), i)
        push!(newvars, Fiv)
    end
    return newvars
end

"""
    F!(df, v, horizons=1, fun=identity, baseperiod=0, relativebase=false)

    Cunlative forward difference operator
Applies function `fun` to the column `v` of `df` and then calculates 
    the growth of this column, saving the results to a new columns in
    `df` as the column `FΔ$(i)$(v)`.
    If `x = map(fun, df[!, v])`, `df.FΔ$(i)$(v) = lead(x, horizons) - lead(x, baseperiod)`
    or `x = map(fun, df[!, v])`, `df.FΔ$(i)$(v) = lead(x, horizons) - lead(x, horizon + baseperiod)`
    if relativebase == true
    Modifies `df`. 
    Return the list of new columns created. 
"""
function FΔ!(df, v, horizons=1, fun=identity, baseperiod=0, relativebase=false)
    # Forward difference operator
    newvars = Symbol[]
    for i in horizons
        Fiv = Symbol("FΔ$(i)$(v)")
        if relativebase
            df[:, Fiv] = lead( map(fun, df[!, v]), i) .- lead(map(fun, df[!, v]), i+baseperiod)
        else
            df[:, Fiv] = lead( map(fun, df[!, v]), i) .- lead(map(fun, df[!, v]), baseperiod)
        end
        push!(newvars, Fiv)
    end
    return newvars
end

"""
LΔ!(df, v, horizons=1, fun=identity, baseperiod=0, relativebase=false)
    Cumlative lag difference operator

    Applies function `fun` to the column `v` of `df` and then calculates 
        the lagged growth of this column, saving the results to a new columns in
        `df` as the column `LΔ$(i)$(v)`.
        If `x = map(fun, df[!, v])`, `df.FΔ$(i)$(v) = lag(x, baseperiod) - lag(x, horizons)`
        or `x = map(fun, df[!, v])`, `df.FΔ$(i)$(v) = lag(x, i+baseperiod) - lag(x, horizons)`
        if relativebase == true
        Modifies `df`. 
        Return the list of new columns created. 
"""
function LΔ!(df, v, horizons=1, fun=identity, baseperiod=0, relativebase=false)
    # Lag difference operator
    newvars = Symbol[]
    for i in horizons
        Fiv = Symbol("LΔ$(i)$(v)")
        if relativebase
            df[:, Fiv] = lag(map(fun, df[!, v]), i+baseperiod) .-  lag( map(fun, df[!, v]), i)
        else
            df[:, Fiv] = lag(map(fun, df[!, v]), i+baseperiod) .-  lag( map(fun, df[!, v]), i)
        end
        push!(newvars, Fiv)
    end
    return newvars
end

"""
    Δ(x, horizons=1, fun=identity)

Single period growth function
    `map(fun, x) .-  lag(map(fun, x), horizons)`
"""
function Δ(x, horizons=1, fun=identity)
    return map(fun, x) .-  lag(map(fun, x), horizons)
end

