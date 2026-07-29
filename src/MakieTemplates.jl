module MakieTemplates

#= load external modules =#
using CairoMakie, ColorSchemes, JLD2, Measurements, LaTeXStrings, LinearAlgebra

#= set global constants =#
global FONTSIZE = 8 # paper font size

const markers_labels_hollow = [:circle,
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

const markers_labels = [:circle,
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
include("lib/themes.jl")
include("lib/templates.jl")
include("exports.jl")