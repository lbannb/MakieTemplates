module juliaPlotting

#= load external modules =#
using CairoMakie, ColorSchemes, JLD2, Measurements, LaTeXStrings

#= set global constants =#
global FONTSIZE = 8 # paper font size

#= load local files =#
include("lib/main.jl")
include("lib/themes.jl")

#= export all functions =#
export main_theme!, use_scatter_gradient_theme!
export scatter_gradient

end
