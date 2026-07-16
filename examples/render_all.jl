#=
    Renders every template once to examples/output/*.pdf.
    Run with: julia --project=.. render_all.jl (or --project=. from the repo root)
=#
using juliaPlotting, CairoMakie, Random

outdir = joinpath(@__DIR__, "output")
mkpath(outdir)
save_pdf(name, fig) = save(joinpath(outdir, name * ".pdf"), fig)

Random.seed!(1)
x = collect(range(0, 4π, 40))
y = sin.(x)
yerr = 0.1 .+ 0.1 .* rand(length(x))

# --- XY templates ---
fig, _, _ = plot_xy(x, y; xlabel=L"x", ylabel=L"\sin(x)")
save_pdf("scatter", fig)

fig, _, _ = plot_xy(x, y; markers=false, lines=true, xlabel=L"x", ylabel=L"\sin(x)")
save_pdf("lines", fig)

fig, _, _ = plot_xy(x, y; lines=true, xlabel=L"x", ylabel=L"\sin(x)")
save_pdf("scatter_lines", fig)

fig, _, _ = plot_xy(x, y; yerr, markers=false, lines=true, errorstyle=:band,
    xlabel=L"x", ylabel=L"\sin(x)")
save_pdf("lines_band", fig)

fig, _, _ = plot_xy(x, y; yerr, errorstyle=:bars, xlabel=L"x", ylabel=L"\sin(x)")
save_pdf("scatter_errorbars", fig)

fig, _, _ = plot_xy(x, y; yerr, lines=true, errorstyle=:both,
    xlabel=L"x", ylabel=L"\sin(x)")
save_pdf("scatter_lines_band_bars", fig)

# --- \textwidth sizing demo: drop into LaTeX with
#     \includegraphics[width=0.5\textwidth]{scatter_halfwidth.pdf} ---
fig, _, _ = plot_xy(x, y; xlabel=L"x", ylabel=L"\sin(x)",
    figure=(width_fraction=0.5, textwidth_pt=455))
save_pdf("scatter_halfwidth", fig)

# --- field / distribution templates ---
xs = collect(range(-2, 2, 50))
ys = collect(range(-2, 2, 50))
z = [sin(2xi) * cos(2yi) for xi in xs, yi in ys]

fig, _, _ = plot_heatmap(xs, ys, z; xlabel=L"x", ylabel=L"y", colorbarlabel=L"z")
save_pdf("heatmap", fig)

fig, _, _ = plot_contour(xs, ys, z; filled=true, xlabel=L"x", ylabel=L"y",
    colorbarlabel=L"z")
save_pdf("contour_filled", fig)

fig, _, _ = plot_contour(xs, ys, z; labels=true, xlabel=L"x", ylabel=L"y")
save_pdf("contour_lines", fig)

fig, _, _ = plot_histogram(randn(1000); normalization=:pdf,
    xlabel=L"v", ylabel=L"p(v)")
save_pdf("histogram", fig)

xq = collect(range(-2, 2, 15))
yq = collect(range(-2, 2, 15))
u = [-yj for _ in xq, yj in yq]
v = [xi for xi in xq, _ in yq]
fig, _, _ = plot_quiver(xq, yq, u, v; xlabel=L"x", ylabel=L"y",
    colorbarlabel=L"|\vec{u}|")
save_pdf("quiver", fig)

println("Rendered ", length(readdir(outdir)), " PDFs to ", outdir)
