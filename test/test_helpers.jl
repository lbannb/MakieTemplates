# The inset, legend and tick helpers build a figure that saves.
# Run: julia --project=. test/test_helpers.jl
using MakieTemplates, CairoMakie, LaTeXStrings

fig = paper_figure()
ax = Axis(fig[1, 1]; xlabel = "x", ylabel = scaled_label(raw"\mathrm{Var}(H)/N^2", power_of_ten(3e-4)))
lines!(ax, 1:10, (1:10) .^ 2; color = :red)
lines!(ax, 1:10, (1:10) .^ 2 .+ 5; color = (:blue, 0.2))
hlines!(ax, 50; color = :black, linestyle = :dash)
Legend(fig[2, 1], [legend_box(:red), legend_line(:black; linestyle = :dash),
                   legend_lines([(:red, 0.4), (:blue, 0.4)])],
       ["box", "dashed", "stacked"]; patchsize = (16, 10))

inset = create_inset(fig, ax; width = 80, height = 50, ticklabelsize = 7, yscale = log10,
                     xticks = ([2, 5, 8], ["a", "b", "c"]))
lines!(inset, 1:10, 10.0 .^ (1:10))
inset.yticks = decade_ticks(10, 1e10)

@assert inset.xticklabelsize[] == 7 && inset.yticklabelsize[] == 7
@assert inset.yscale[] == log10
@assert inset.xticks[] == ([2, 5, 8], ["a", "b", "c"])
@assert length(legend_lines([:red, :blue, :green])) == 3
@assert legend_line(:red).linewidth[] == 3 && legend_line(:red; linestyle = :dash).linewidth[] == 1.5
@assert decade_ticks(1e-6, 2e-2)[1] == 10.0 .^ (-6:-2)
@assert log_ticks(1.2e-3, 3.9e-3)[1] ≈ [2e-3, 3e-3]
@assert log_ticks(2e-4, 3e-3; negative = true)[2][1] == L"-2\cdot 10^{-4}"
@assert power_of_ten(2.9e-4) == -4 && power_of_ten(150) == 2
@assert scaled_label("x", -4) == L"x\ \ [10^{-4}]"

# an inset without the new keywords is the same as before
plain = create_inset(fig, ax)
@assert plain.xticklabelsize[] == ax.xticklabelsize[]

out = joinpath(mktempdir(), "helpers.pdf")
save(out, fig)
@assert filesize(out) > 0
println("OK: helpers")
