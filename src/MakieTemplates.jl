module MakieTemplates

#= load external modules =#
using CairoMakie, ColorSchemes, JLD2, Measurements, LaTeXStrings, LinearAlgebra

#= set global constants =#
global FONTSIZE = 18 # paper font size

const TEXPT_TO_BP = 72 / 72.27 # LaTeX pt (1/72.27 in) -> PDF big pt (1/72 in)

# Color schemes
const SEQUENTIAL_CMAP = :viridis
const DIVERGING_CMAP = ColorSchemes.vik

const markers_labels_hollow = [
    :circle,
    :utriangle,
    :rect,
    :xcross,
    :diamond,
    :hexagon,
    # :xcross,
    :utriangle,
    :dtriangle,
    :ltriangle,
    :rtriangle,
    :pentagon,
    :star4,
    :star5,
    :star6,
    :star8,
]

const markers_labels = [
    :circle,
    :utriangle,
    :rect,
    :xcross,
    :diamond,
    :hexagon,
    # :xcross,
    :utriangle,
    :dtriangle,
    :ltriangle,
    :rtriangle,
    :pentagon,
    :star4,
    :star5,
    :star6,
    :star8,
]

#= load local files =#
include("lib/main.jl")
include("lib/legend.jl")
include("lib/ticks.jl")
include("lib/themes.jl")
include("lib/templates.jl")
include("exports.jl")

end