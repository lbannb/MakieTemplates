#=
    Publication figure sizing (paper_figure) and plot templates.
    All templates share the themes from themes.jl and return (fig, ax, plot).
=#

const TEXPT_TO_BP = 72 / 72.27 # LaTeX pt (1/72.27 in) -> PDF big pt (1/72 in)

const SEQUENTIAL_CMAP = :viridis
const DIVERGING_CMAP = ColorSchemes.vik

"""
    paper_figure(; width_fraction=1.0, textwidth_pt=455.0, height_ratio=0.62,
                 theme=main_theme!)

Figure sized so that `\\includegraphics[width=<width_fraction>\\textwidth]{fig.pdf}`
renders all text at exactly the theme's pt sizes — no LaTeX rescaling.

`textwidth_pt` is your document's `\\the\\textwidth` (in LaTeX pt). Activates PDF
output with `pt_per_unit=1`, so 1 figure unit == 1 pt and the theme fontsizes
are literal point sizes on paper.
"""
function paper_figure(; width_fraction::Real=1.0, textwidth_pt::Real=455.0,
        height_ratio::Real=0.62, theme::Function=main_theme!)
    theme()
    # themes activate svg with pt_per_unit=1.75; exact paper sizing needs 1 unit == 1 pt
    CairoMakie.activate!(type="pdf", pt_per_unit=1)
    w = width_fraction * textwidth_pt * TEXPT_TO_BP
    return Figure(size=(w, height_ratio * w))
end

function _template_axis(; xlabel="", ylabel="", theme::Function=main_theme!, figure=(;))
    fig = paper_figure(; theme, figure...)
    ax = Axis(fig[1, 1]; xlabel, ylabel)
    return fig, ax
end

"""
    plot_xy(x, y; yerr=nothing, markers=true, lines=false, errorstyle=:none,
            xlabel="", ylabel="", figure=(;), kwargs...)

XY template. `errorstyle` is `:none`, `:bars`, `:band` or `:both` (needs `yerr`).
`figure` forwards to [`paper_figure`](@ref), e.g. `figure=(width_fraction=0.5,)`.
Remaining `kwargs` go to the scatter/lines calls. Returns `(fig, ax, plot)`.
"""
function plot_xy(x, y; yerr=nothing, markers::Bool=true, lines::Bool=false,
        errorstyle::Symbol=:none, xlabel="", ylabel="", figure=(;),
        theme::Function=markers ? use_scatter_theme! : main_theme!, kwargs...)

    errorstyle in (:none, :bars, :band, :both) ||
        throw(ArgumentError("errorstyle must be :none, :bars, :band or :both"))
    errorstyle == :none || !isnothing(yerr) ||
        throw(ArgumentError("errorstyle=:$errorstyle requires yerr"))
    markers || lines ||
        throw(ArgumentError("set markers=true and/or lines=true"))

    fig, ax = _template_axis(; xlabel, ylabel, theme, figure)

    # band matches the series color (first palette color unless overridden)
    if errorstyle in (:band, :both)
        bandcolor = get(kwargs, :color, ColorSchemes.tol_bright[1])
        band!(ax, x, y .- yerr, y .+ yerr, color=(bandcolor, 0.25))
    end

    plt = nothing
    if lines
        plt = lines!(ax, x, y; kwargs...)
    end
    if errorstyle in (:bars, :both)
        errorbars!(ax, x, y, yerr)
    end
    if markers
        plt = scatter!(ax, x, y; kwargs...)
    end

    return fig, ax, plt
end

"""
    plot_heatmap(x, y, z; xlabel="", ylabel="", colorbarlabel="",
                 colormap=SEQUENTIAL_CMAP, figure=(;), kwargs...)

Heatmap with an attached Colorbar. Returns `(fig, ax, plot)`.
"""
function plot_heatmap(x, y, z; xlabel="", ylabel="", colorbarlabel="",
        colormap=SEQUENTIAL_CMAP, figure=(;), theme::Function=main_theme!, kwargs...)
    fig, ax = _template_axis(; xlabel, ylabel, theme, figure)
    hm = heatmap!(ax, x, y, z; colormap, kwargs...)
    Colorbar(fig[1, 2], hm, label=colorbarlabel)
    colgap!(fig.layout, 5.0)
    return fig, ax, hm
end

"""
    plot_contour(x, y, z; filled=false, labels=false, levels=10, xlabel="",
                 ylabel="", colorbarlabel="", colormap=SEQUENTIAL_CMAP,
                 figure=(;), kwargs...)

Contour template. `filled=true` uses `contourf!` and adds a Colorbar;
otherwise line contours (`labels=true` for labeled levels). Returns `(fig, ax, plot)`.
"""
function plot_contour(x, y, z; filled::Bool=false, labels::Bool=false, levels=10,
        xlabel="", ylabel="", colorbarlabel="", colormap=SEQUENTIAL_CMAP,
        figure=(;), theme::Function=main_theme!, kwargs...)
    fig, ax = _template_axis(; xlabel, ylabel, theme, figure)
    if filled
        c = contourf!(ax, x, y, z; levels, colormap, kwargs...)
        Colorbar(fig[1, 2], c, label=colorbarlabel)
        colgap!(fig.layout, 5.0)
    else
        c = contour!(ax, x, y, z; levels, colormap, labels, kwargs...)
    end
    return fig, ax, c
end

"""
    plot_histogram(data; bins=<Sturges>, normalization=:none, xlabel="",
                   ylabel="", figure=(;), kwargs...)

Histogram template. `normalization` as in `hist!` (`:none`, `:pdf`, `:density`,
`:probability`). Returns `(fig, ax, plot)`.
"""
function plot_histogram(data; bins=ceil(Int, log2(length(data))) + 1, # ponytail: Sturges' rule, swap for FD if it misbins
        normalization::Symbol=:none, xlabel="", ylabel="",
        color=(ColorSchemes.tol_bright[1], 0.8), figure=(;),
        theme::Function=main_theme!, kwargs...)
    fig, ax = _template_axis(; xlabel, ylabel, theme, figure)
    h = hist!(ax, data; bins, normalization, color,
        strokewidth=0.5, strokecolor=:black, kwargs...)
    return fig, ax, h
end

"""
    plot_quiver(x, y, u, v; color_by_magnitude=true, lengthscale=:auto,
                xlabel="", ylabel="", colorbarlabel="",
                colormap=SEQUENTIAL_CMAP, figure=(;), kwargs...)

Vector field on the grid `x` × `y` with components `u`, `v` (matrices).
`lengthscale=:auto` scales the longest arrow to ~90% of the smallest grid
spacing. `color_by_magnitude=true` colors arrows by |(u,v)| and adds a
Colorbar. Returns `(fig, ax, plot)`.
"""
function plot_quiver(x, y, u, v; color_by_magnitude::Bool=true, lengthscale=:auto,
        xlabel="", ylabel="", colorbarlabel="", colormap=SEQUENTIAL_CMAP,
        figure=(;), theme::Function=main_theme!, kwargs...)
    fig, ax = _template_axis(; xlabel, ylabel, theme, figure)

    mag = vec(sqrt.(u .^ 2 .+ v .^ 2))
    if lengthscale === :auto
        dx = length(x) > 1 ? minimum(diff(collect(x))) : 1.0
        dy = length(y) > 1 ? minimum(diff(collect(y))) : 1.0
        lengthscale = maximum(mag) > 0 ? 0.9 * min(dx, dy) / maximum(mag) : 1.0
    end

    if color_by_magnitude
        ar = arrows2d!(ax, x, y, u, v; lengthscale, color=mag, colormap, kwargs...)
        Colorbar(fig[1, 2], limits=extrema(mag), colormap=colormap, label=colorbarlabel)
        colgap!(fig.layout, 5.0)
    else
        ar = arrows2d!(ax, x, y, u, v; lengthscale, kwargs...)
    end
    return fig, ax, ar
end
