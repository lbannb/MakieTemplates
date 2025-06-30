#= 
    main plotting functions
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

    # #= add 5% spacing to the x/y ticks of the start and end of xlims/ylims =#
    # if !isnothing(ylims)
    #     yrange = ylims[2] - ylims[1]
    #     Makie.ylims!(ax, ylims[1] - 0.05*yrange, ylims[2] + 0.05*yrange)
    # end
    # if !isnothing(xlims)
    #     xrange = xlims[2] - xlims[1]
    #     Makie.xlims!(ax, xlims[1] - 0.05*xrange, xlims[2] + 0.05*xrange)
    # end

    return fig,ax
end

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
see https://juliagraphics.github.io/ColorSchemes.jl/stable/goodpractice/ for good ColorSchemes
=#
function scatter_gradient!(fig::Figure,
        ax::Axis, 
        x::Union{Vector{Vector{Float64}},Vector{Vector{Int}}},
        y::Vector{Vector{Float64}},
        grad::Vector{Float64};

        colormap::ColorScheme=ColorSchemes.linear_tritanopic_krjcw_5_95_c24_n256,
        linestyle::Union{Symbol,Nothing}=nothing,
        linewidth::Float64=1.0,
        colorbarlabel::Union{String,LaTeXString}="")

    # Get color values from colormap
    colors = [get(colormap, g) for g in normalize(grad)]

    for i in eachindex(x)
        if !isnothing(linestyle)
            lines!(ax, x[i], y[i], color = colors[i], linestyle=linestyle, linewidth=linewidth)
        end

        scatter!(ax, x[i], y[i], color = colors[i])
    end

    # Add colorbar
    Colorbar(fig[1,2], colormap=colormap, colorrange=(minimum(grad),maximum(grad)),
        label=colorbarlabel)

    colgap!(fig.layout, 5.0) # remove spacing between colorbar and plot
end

function scatter_many!(ax::Axis, 
        x::Union{Vector{Vector{Float64}},Vector{Vector{Int}}},
        y::Vector{Vector{Float64}};
        labels = fill("", length(x)),
        legendlabel::Union{String,LaTeXString}="",
        legendpos::Symbol=:lt,
        colors::ColorScheme=ColorSchemes.tol_bright,
        linestyle::Union{Symbol,Nothing}=nothing,
        linewidth::Float64=1.0)

    for i in eachindex(x)
        if !isnothing(linestyle)
            lines!(ax, x[i], y[i], color = colors[i], linestyle=linestyle, linewidth=linewidth)
        end

        scatter!(ax, x[i], y[i], color = colors[i], label = "$(labels[i])")
    end

    if labels != fill("", length(x))
        axislegend(ax, legendlabel, position=legendpos)
    end
end