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
        ylims::Tuple{Float64, Float64}=(minimum(vcat(y...))-0.05*maximum(vcat(y...)),maximum(vcat(y...))+0.05*maximum(vcat(y...))),
        colors::ColorScheme=ColorSchemes.Blues_5)
    use_scatter_gradient_theme!()

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
    
    return fig
end