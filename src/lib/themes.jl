function main_theme!()
    theme = Theme(
        figure_padding=5,
        size=(250, 200),
        fontsize=FONTSIZE,
        Errorbars=(
            linewidth=0.35,
            whiskerwidth=2.0,
            color=:black,
        ),
        Axis=(
            titlefont=:regular,
            titlesize=10,
            xlabelsize=10,
            ylabelsize=10,
            xgridvisible=false,
            ygridvisible=false,
            xticksize=2.5,
            yticksize=2.5,
            xminorticksize=1.5,
            xminortickwidth = 0.6,
            yminorticksize=1.5,
            yminortickwidth = 0.6,
            # leaves 5% spacing between first tick and origin and last tick and end of box
            xautolimitmargin=(0.05,0.05),
            yautolimitmargin=(0.05,0.05),
            spinewidth=0.75,
            xtickwidth=0.75,
            ytickwidth=0.75,
        ),
        Legend=(
            labelfont=:regular,
            padding=(2, 2, 2, 2), # The additional space between the legend content and the border.
            patchlabelgap=3, # The gap between the patch and the label of each legend entry.
            patchsize=(4, 4), # The size of the rectangles containing the legend markers.
            rowgap=0, # The gap between the entry rows.
            colgap=0, # The gap between the entry columns.
            titlefont=:regular,
            titlegap=1,
            margin=(2, 2, 2, 2),
            framevisible=false,
        ),
        Lines=(
            linewidth = 1,
        ),
        HLines=(
            linewidth = 1,
        ),
        VLines=(
            linewidth = 1,
        ),
    )

    # use CairoMakie as backend
    CairoMakie.activate!(type="svg", pt_per_unit=1.75)

    theme = merge(theme, theme_latexfonts())
    update_theme!(theme)
end

function use_scatter_theme!()
    main_theme!()

    theme = Theme(
        palette = (color = ColorSchemes.tol_bright, marker = markers_labels),
        Scatter=(
            markersize=5.0,
            strokewidth=0.35,
            strokecolor=(:black, 0.5),
            cycle = Cycle([:color, :marker], covary = true),
        ),
    )

    theme = merge(theme, Makie.current_default_theme())
    update_theme!(theme)
end

function use_scatter_hollow_theme!()
    main_theme!()

    theme = Theme(
        palette = (strokecolor = ColorSchemes.tol_bright, marker = markers_labels_hollow),
        Scatter=(
            markersize=6.0,
            strokewidth=0.65,
            color=:transparent,
            cycle = Cycle([:strokecolor, :marker], covary = true),
        ),
    )

    theme = merge(theme, Makie.current_default_theme())
    update_theme!(theme)
end