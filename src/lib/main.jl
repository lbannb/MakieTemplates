#= 
    main plotting functions
=#

function scatter_gradient(x::Union{Vector{Vector{Float64}},Vector{Vector{Int}}},
        y::Vector{Vector{Float64}},
        grad::Union{Vector{Float64},Vector{Int}}; 
        xlabel::Union{String,LaTeXString}="", 
        ylabel::Union{String,LaTeXString}="", 
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

    fig = Figure()
    ax1 = Axis(fig[1, 1],
        xlabel = xlabel,
        ylabel = ylabel,
        limits = (xlims,ylims)
    )

    for (i, d) in enumerate(grad)
        scatter!(ax1, x[i], y[i], color = colors[i], label = "$d")
    end

    axislegend(ax1, legendlabel)
    
    #= add 5% spacing to the x/y ticks of the start and end of xlims/ylims =#
    if !isnothing(ylims)
        yrange = ylims[2] - ylims[1]
        Makie.ylims!(ax1, ylims[1] - 0.05*yrange, ylims[2] + 0.05*yrange)
    end
    if !isnothing(xlims)
        yrange = xlims[2] - xlims[1]
        Makie.ylims!(ax1, xlims[1] - 0.05*yrange, xlims[2] + 0.05*yrange)
    end

    return fig
end

function scatter_line(x::Union{Vector{Float64},Vector{Int}},
        y::Vector{Float64};
        xlabel::Union{String,LaTeXString}="", 
        ylabel::Union{String,LaTeXString}="", 
        xlims::Union{Tuple{Float64, Float64},Nothing}=nothing,
        ylims::Union{Tuple{Float64, Float64},Nothing}=nothing,
        color::Union{Symbol,Nothing}=nothing)
    use_scatter_theme!()

    # this scales the size of the rendered figure in the notebook by 1.75
    CairoMakie.activate!(type="svg", pt_per_unit=1.75)

    fig = Figure()
    ax1 = Axis(fig[1, 1],
        xlabel = xlabel,
        ylabel = ylabel,
        limits = (xlims,ylims)
    )

    lines!(ax1, x, y, color=color)
    scatter!(ax1, x, y, color=color)

    #= add 5% spacing to the x/y ticks of the start and end of xlims/ylims =#
    if !isnothing(xlims)
        xrange = xlims[2] - xlims[1]
        Makie.xlims!(ax1, xlims[1] - 0.05*xrange, xlims[2] + 0.05*xrange)
    end
    if !isnothing(ylims)
        yrange = ylims[2] - ylims[1]
        Makie.ylims!(ax1, ylims[1] - 0.05*yrange, ylims[2] + 0.05*yrange)
    end

    return fig
end