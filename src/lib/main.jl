#= 
    main plotting functions
=#

function create_inset(fig::Figure, ax::Axis; 
    xlabel::Union{String,LaTeXString}="",
    ylabel::Union{String,LaTeXString}="",
    xlims::Union{Tuple{Float64, Float64},Nothing}=nothing,
    ylims::Union{Tuple{Float64, Float64},Nothing}=nothing,
    width::Int=50, 
    height::Int=50, 
    position::Symbol=:rt, 
    margin=(5,5,5,5))

	inset = get_BBox(
		ax,
		width = width,
		height = height,
		position = position,
		margin = margin,
	)

    ax_inset = Axis(fig;
		bbox = inset,
        xlabel=xlabel,
        ylabel=ylabel,
        limits = (xlims,ylims)
	)

    pretty_lims!(ax_inset, xlims, ylims)

    # Translate the inset axis forward in the z-direction
    translate!(ax_inset.blockscene, 0, 0, 100)

    return ax_inset
end

#= 
 Taken from Malte Pütz (https://github.com/maltepuetz)
=#
function get_BBox(axis; width = 50, height = 50, position = :rt, margin = (3, 3, 3, 3))
	# Get the axis position
	ax_pos = axis.layoutobservables.computedbbox[]

	# Calculate the position based on the specified corner
	if position == :rt  # right top
		x = ax_pos.origin[1] + ax_pos.widths[1] - width - margin[2]
		y = ax_pos.origin[2] + ax_pos.widths[2] - height - margin[1]
	elseif position == :lt  # left top
		x = ax_pos.origin[1] + margin[4]
		y = ax_pos.origin[2] + ax_pos.widths[2] - height - margin[1]
	elseif position == :rb  # right bottom
		x = ax_pos.origin[1] + ax_pos.widths[1] - width - margin[2]
		y = ax_pos.origin[2] + margin[3]
	elseif position == :lb  # left bottom
		x = ax_pos.origin[1] + margin[4]
		y = ax_pos.origin[2] + margin[3]
	elseif position == :cb  # center bottom
        x = ax_pos.origin[1] + (ax_pos.widths[1] - width) / 2 + margin[2]
        y = ax_pos.origin[2] + margin[3]
    elseif position == :ct  # center top
        x = ax_pos.origin[1] + (ax_pos.widths[1] - width) / 2 + margin[2]
        y = ax_pos.origin[2] + ax_pos.widths[2] - height - margin[1]
    end

	return BBox(x, x + width, y, y + height)
end

function pretty_lims!(ax, xlims, ylims)
    #= add 5% spacing to the x/y ticks of the start and end of xlims/ylims =#
    if !isnothing(xlims)
        xrange = xlims[2] - xlims[1]
        Makie.xlims!(ax, xlims[1] - 0.05*xrange, xlims[2] + 0.05*xrange)
    end
    if !isnothing(ylims)
        yrange = ylims[2] - ylims[1]
        Makie.ylims!(ax, ylims[1] - 0.05*yrange, ylims[2] + 0.05*yrange)
    end
end

#=
    Publication figure sizing (paper_figure) and plot templates.
    All templates share the themes from themes.jl and return (fig, ax, plot).
=#

"""
    paper_figure(; width_fraction=1.0, textwidth_pt=455.0, height_ratio=0.62,
                 theme=main_theme!)

Figure sized so that `\\includegraphics[width=<width_fraction>\\textwidth]{fig.pdf}`
renders all text at exactly the theme's pt sizes — no LaTeX rescaling.

- `textwidth_pt` is your document's `\\the\\textwidth` (in LaTeX pt). Activates PDF
output with `pt_per_unit=1`, so 1 figure unit == 1 pt and the theme fontsizes
are literal point sizes on paper.
- `height_ratio` is the figure height / width ratio.
- `theme` is a function that sets the theme from `themes.jl` (default: `main_theme!`).
"""
function paper_figure(; width_fraction::Real=1.0, textwidth_pt::Real=455.0,
        height_ratio::Real=0.62, theme::Function=main_theme!)
    theme()
    w = width_fraction * textwidth_pt * TEXPT_TO_BP # convert to PDF big pt (1/72 in) for CairoMakie
    return Figure(size=(w, height_ratio * w)) # return a Figure with the correct size in pt units
end

function _template_axis(; ax_layout=[1,1], xlabel="", ylabel="", theme::Function=main_theme!, figure=(;))
    fig = paper_figure(; theme, figure...)
    ax = Axis(fig[ax_layout[1], ax_layout[2]]; xlabel, ylabel)
    return fig, ax
end