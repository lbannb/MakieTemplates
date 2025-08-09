module juliaPlotting

#= load external modules =#
using CairoMakie, ColorSchemes, JLD2, Measurements, LaTeXStrings, LinearAlgebra

#= set global constants =#
global FONTSIZE = 8 # paper font size

#= load local files =#
include("lib/helper.jl")
include("lib/main.jl")
include("lib/themes.jl")
include("exports.jl")

end
