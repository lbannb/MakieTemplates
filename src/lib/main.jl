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

function scatter_gradient(ax::Axis, 
        x::Union{Vector{Vector{Float64}},Vector{Vector{Int}}},
        y::Vector{Vector{Float64}},
        grad::Vector{Float64};
        labels = fill("", length(x)),
        legendlabel::Union{String,LaTeXString}="",
        xlims::Union{Tuple{Float64, Float64},Nothing}=nothing,
        ylims::Union{Tuple{Float64, Float64},Nothing}=nothing,
        colors::Union{ColorScheme,String}=ColorSchemes.tol_bright)
    use_scatter_theme!()

    if typeof(colors)==String
        colors = colorschemes[findcolorscheme(colors)[1]]
    end
    
    # this scales the size of the rendered figure in the notebook by 1.75
    CairoMakie.activate!(type="svg", pt_per_unit=1.75)

    for i in eachindex(x)
        scatter!(ax, x[i], y[i], color = colors[i], label = "$(labels[i])")
    end

    axislegend(ax, legendlabel)
    
    #= add 5% spacing to the x/y ticks of the start and end of xlims/ylims =#
    if !isnothing(ylims)
        yrange = ylims[2] - ylims[1]
        Makie.ylims!(ax, ylims[1] - 0.05*yrange, ylims[2] + 0.05*yrange)
    end
    if !isnothing(xlims)
        yrange = xlims[2] - xlims[1]
        Makie.ylims!(ax, xlims[1] - 0.05*yrange, xlims[2] + 0.05*yrange)
    end

    return fig
end

function scatter_many!(ax::Axis, 
        x::Union{Vector{Vector{Float64}},Vector{Vector{Int}}},
        y::Vector{Vector{Float64}};
        labels = fill("", length(x)),
        legendlabel::Union{String,LaTeXString}="",
        legendpos::Symbol=:lt,
        colors::Union{ColorScheme,String}=ColorSchemes.tol_bright,
        linestyle::Union{Symbol,Nothing}=nothing,
        linewidth::Float64=1.0)

    if typeof(colors)==String
        colors = colorschemes[findcolorscheme(colors)[1]]
    end
    
    # this scales the size of the rendered figure in the notebook by 1.75
    CairoMakie.activate!(type="svg", pt_per_unit=1.75)

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