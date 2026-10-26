#=
    legend entries that read better at legend size than the thin lines of a plot
    (use them with a patchsize like (16, 10): the theme's (4, 4) is too small for lines)
=#

"""
    legend_box(color)

Filled box as a legend entry: tells colours apart better than a thin line, e.g. for a
band or for series of similar colours.
"""
legend_box(color) = PolyElement(color = color, strokewidth = 0)

"""
    legend_line(color; linestyle=:solid, linewidth=nothing)

Thick line as a legend entry (linewidth 3). A dashed or dotted line is drawn thinner
(1.5), so that its pattern still shows in the short patch.
"""
function legend_line(color; linestyle=:solid, linewidth=nothing)
    lw = isnothing(linewidth) ? (linestyle == :solid ? 3 : 1.5) : linewidth
    return LineElement(color = color, linewidth = lw, linestyle = linestyle)
end

"""
    legend_lines(colors; linestyle=:solid, linewidth=nothing)

Several lines stacked in one legend entry, one per colour: e.g. one entry for the single
runs of several series, each drawn in its (translucent) colour. Returns a vector of
`LineElement`s, which `Legend` takes as one entry.
"""
function legend_lines(colors; linestyle=:solid, linewidth=nothing)
    lw = isnothing(linewidth) ? (linestyle == :solid ? 2.5 : 1.5) : linewidth
    ys = length(colors) == 1 ? [0.5] : range(0.85, 0.15, length = length(colors))
    return [LineElement(color = c, linewidth = lw, linestyle = linestyle,
                        points = Point2f[(0, y), (1, y)])
            for (c, y) in zip(colors, ys)]
end
