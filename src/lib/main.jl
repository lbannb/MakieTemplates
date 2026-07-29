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
    Different Layouts for plotting
=#

function layout_1_1(;
        theme::Function=main_theme!,
        xlabel::Union{String,LaTeXString}="", 
        ylabel::Union{String,LaTeXString}="", 
        xlims::Union{Tuple{Float64, Float64},Nothing}=nothing,
        ylims::Union{Tuple{Float64, Float64},Nothing}=nothing)

    theme()
    
    fig = Figure()
    ax = Axis(fig[1, 1],
        xlabel = xlabel,
        ylabel = ylabel,
        limits = (xlims,ylims)
    )

    pretty_lims!(ax, xlims, ylims)

    return fig,ax
end

function layout_1_2(;
        theme::Function=main_theme!,
        xlabel::Union{Vector{Union{String,LaTeXString}},Union{String,LaTeXString},Nothing}=nothing, 
        ylabel::Union{Vector{Union{String,LaTeXString}},Union{String,LaTeXString},Nothing}=nothing, 
        xlims::Union{Vector{Union{Tuple{Float64, Float64},Nothing}},Tuple{Float64, Float64},Nothing}=nothing,
        ylims::Union{Vector{Union{Tuple{Float64, Float64},Nothing}},Tuple{Float64, Float64},Nothing}=nothing)

    theme()
    
    fig = Figure(size=(500, 200))
    ax1 = Axis(fig[1, 1],
        xlabel = isa(xlabel, AbstractVector) ? xlabel[1] : xlabel,
        ylabel = isa(ylabel, AbstractVector) ? ylabel[1] : ylabel,
        limits = (isa(xlims, AbstractVector) ? xlims[1] : xlims, isa(ylims, AbstractVector) ? ylims[1] : ylims)
    )
    ax2 = Axis(fig[1, 2],
        xlabel = isa(xlabel, AbstractVector) ? xlabel[2] : xlabel,
        ylabel = isa(ylabel, AbstractVector) ? ylabel[2] : ylabel,
        limits = (isa(xlims, AbstractVector) ? xlims[2] : xlims, isa(ylims, AbstractVector) ? ylims[2] : ylims)
    )


    pretty_lims!(ax1, isa(xlims, AbstractVector) ? xlims[1] : xlims, isa(ylims, AbstractVector) ? ylims[1] : ylims)
    pretty_lims!(ax2, isa(xlims, AbstractVector) ? xlims[2] : xlims, isa(ylims, AbstractVector) ? ylims[2] : ylims)

    return fig,ax1,ax2
end
