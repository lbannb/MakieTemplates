#= import packages =#
using JLD2, ColorSchemes, Revise, LaTeXStrings
using Measurements: value, uncertainty

#= import own package =#
# as we run this script via encap on different machines, get to project root with this
function getPathToProjectRoot(rootName::String)
    path = @__DIR__
    while true
        if basename(path) == rootName
            return path
        end
        parent = dirname(path)
        if parent == path 
            return nothing
        end
        path = parent
    end
end

using Pkg
Pkg.activate(getPathToProjectRoot("juliaPlotting")) 
using juliaPlotting

#= 
    Load data
=#
# TODO: rename xs1 -> x_vals
#               ys1msm -> y_measurements
#               ys1 -> yvals
#               ys2err -> yerrs

file = jldopen(joinpath(getPathToProjectRoot("juliaPlotting"),"test\\data\\plotdata.jld2"), "r")
ds1 = file["ds1"]
xs1 = file["xs1"]
ys1msm = file["ys1"]

ys1 = [
    value.(ys1msm[i]) for i in eachindex(ys1msm)
]
ys1err = [
    uncertainty.(ys1msm[i]) for i in eachindex(ys1msm)
]

xs2 = file["xs2"]
ys2msm = file["ys2"]
ys2 = [
    value.(ys2msm[i]) for i in eachindex(ys2msm)
]
ys2err = [
    uncertainty.(ys2msm[i]) for i in eachindex(ys2msm)
]
ds2 = file["ds2"]
close(file)

scatter_gradient(xs1,ys1,ds1; 
    xlabel=L"\text{measurement strength } \gamma",
    ylabel=L"I_c",
    legendlabel=L"d")