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
    normgrad = (grad .- minimum(grad)) ./ (maximum(grad) - minimum(grad))
    colors = [get(colormap, g) for g in normgrad]

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
        markers::Union{Array{Symbol},Nothing} = markers_labels,
        linewidth::Float64=1.0,
        hollow::Bool=false)

    if hollow
        use_scatter_hollow_theme!()
    else
        use_scatter_theme!()
    end

    for i in eachindex(x)
        if !isnothing(linestyle)
            lines!(ax, x[i], y[i], color = colors[i], linestyle=linestyle, linewidth=linewidth)
        end

        if isnothing(markers)
            scatter!(ax, x[i], y[i], color = colors[i], label = "$(labels[i])")
        else
            if length(markers) == length(x)
                scatter!(ax, x[i], y[i], color = colors[i], marker = markers[i], label = "$(labels[i])")
            else
                scatter!(ax, x[i], y[i], color = colors[i], label = "$(labels[i])")

                @warn "The number of markers does not match the number of different scatter sets. \n The default marker is now applied to all scatter points."
            end
        end
    end

    if labels != fill("", length(x))
        axislegend(ax, legendlabel, position=legendpos)
    end
end