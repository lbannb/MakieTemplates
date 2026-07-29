"""
    plot_xy(x, y; yerr=nothing, markers=true, lines=false, errorstyle=:none,
            xlabel="", ylabel="", figure=(;), theme::Function=markers ? use_scatter_theme! : main_theme!, kwargs...)

Basic X, Y plot.

# Keyword arguments
- `yerr`: optional error values for Y. If provided, `errorstyle` must be set
- `markers`: whether to show markers (default: true) -> if `markers=false`, only lines are shown
- `lines`: whether to show lines (default: false) -> if `lines=false`, only markers are shown
- `errorstyle`: how to show errors, one of `:none`, `:bars`, `:band` or `:both`
- `xlabel`, `ylabel`: axis labels
- `figure`: keyword arguments for [`paper_figure`](@ref)
- `kwargs`: remaining keyword arguments are forwarded to the scatter/lines calls

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

function plot_xy!(ax, x, y; yerr=nothing, markers::Bool=true, lines::Bool=false,
        errorstyle::Symbol=:none, kwargs...)

    errorstyle in (:none, :bars, :band, :both) ||
        throw(ArgumentError("errorstyle must be :none, :bars, :band or :both"))
    errorstyle == :none || !isnothing(yerr) ||
        throw(ArgumentError("errorstyle=:$errorstyle requires yerr"))
    markers || lines ||
        throw(ArgumentError("set markers=true and/or lines=true"))

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
end

"""
    plot_heatmap(x, y, z; xlabel="", ylabel="", colorbarlabel="",
                 colormap=SEQUENTIAL_CMAP, figure=(;), theme::Function=main_theme!, kwargs...)

Basic 2D heatmap plot.

# Keyword arguments
- `x` and `y`: 1D arrays of x and y coordinates
- `z`: 2D array of values to plot
- `xlabel`, `ylabel`: axis labels
- `colorbarlabel`: label for the colorbar
- `colormap`: colormap to use (default: `SEQUENTIAL_CMAP`)
- `figure`: keyword arguments for [`paper_figure`](@ref)
- `kwargs`: remaining keyword arguments are forwarded to the heatmap call

"""
function plot_heatmap(x, y, z; xlabel="", ylabel="", colorbarlabel="",
        colormap=SEQUENTIAL_CMAP, figure=(;), theme::Function=main_theme!, kwargs...)

    fig, ax = _template_axis(; xlabel, ylabel, theme, figure)
    hm = heatmap!(ax, x, y, z; colormap, kwargs...)
    Colorbar(fig[1, 2], hm, label=colorbarlabel)
    colgap!(fig.layout, 5.0)
    return fig, ax, hm
end

function plot_heatmap!(ax, x, y, z; colorbarlabel="", colormap=SEQUENTIAL_CMAP, kwargs...)
    hm = heatmap!(ax, x, y, z; colormap, kwargs...)
    Colorbar(ax.figure[1, 2], hm, label=colorbarlabel)
    colgap!(ax.figure.layout, 5.0)
    return ax.figure, ax, hm
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

function scatter_hollow!(ax::Axis, x, y; kwargs...)
    scatter!(ax, x, y, color = :transparent; kwargs...)
end