# LocalProjections

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://joe5saia.github.io/LocalProjections.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://joe5saia.github.io/LocalProjections.jl/dev)
[![Build Status](https://travis-ci.com/joe5saia/LocalProjections.jl.svg?branch=main)](https://travis-ci.com/joe5saia/LocalProjections.jl)
[![Coverage](https://codecov.io/gh/joe5saia/LocalProjections.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/joe5saia/LocalProjections.jl)

# Installation 
This package is not yet registered in the General repository. For now install with 
`pkg> add https://github.com/joe5saia/LocalProjections.jl`. 

# Description
This package simplifies estimating Local Projection forecasts, aka Jorda Local Projections or
IRF Local Projections. This package defines the `LocalProjection` object which summarizes the 
local projection model. The regression model is:
<a href="https://www.codecogs.com/eqnedit.php?latex=\Delta_h&space;y_t&space;=&space;\alpha_h&space;&plus;&space;\beta_h&space;x_t&space;&plus;&space;\Gamma'_h&space;z_t&space;&plus;&space;e_{th}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\Delta_h&space;y_t&space;=&space;\alpha_h&space;&plus;&space;\beta_h&space;x_t&space;&plus;&space;\Gamma'_h&space;z_t&space;&plus;&space;e_{th}" title="\Delta_h y_t = \alpha_h + \beta_h x_t + \Gamma'_h z_t + e_{th}" /></a>

The series of coefficients on the x variable is the object of interest.
This package estimates an individual regression model for each horizon to estimate these coefficients and saves
these results. 

