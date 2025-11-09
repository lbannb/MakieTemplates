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

markers_labels_hollow = [:circle,
    :utriangle,
    :rect,
    :xcross,
    :diamond,
    :hexagon,
    # :xcross,
    :utriangle,
    :dtriangle,
    :ltriangle,
    :rtriangle,
    :pentagon,
    :star4,
    :star5,
    :star6,
    :star8,
]

markers_labels = [:circle,
    :utriangle,
    :rect,
    :xcross,
    :diamond,
    :hexagon,
    # :xcross,
    :utriangle,
    :dtriangle,
    :ltriangle,
    :rtriangle,
    :pentagon,
    :star4,
    :star5,
    :star6,
    :star8,
]