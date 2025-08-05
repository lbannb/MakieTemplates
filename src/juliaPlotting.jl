module juliaPlotting

#= load external modules =#
using CairoMakie, ColorSchemes, JLD2, Measurements, LaTeXStrings, LinearAlgebra

#= set global constants =#
global FONTSIZE = 8 # paper font size

#= load local files =#
include("lib/helper.jl")
include("lib/main.jl")
include("lib/themes.jl")

#= export all functions =#
export main_theme!, use_scatter_theme!
export layout_1_1, layout_1_2
export create_inset, scatter_gradient!, scatter_many!

end
