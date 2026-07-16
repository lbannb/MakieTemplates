# MakieTemplates

This is my personal package for Makie.jl templates and themes.

## `\textwidth` sizing workflow

`paper_figure` (used by every template via the `figure` keyword) sizes figures in
actual points with `pt_per_unit = 1`, so text renders at exactly the theme's pt
sizes in the paper — no LaTeX rescaling, at any fraction of `\textwidth`.

1. Get your document's text width once: put `\the\textwidth` in the document and
   read the value (e.g. `455.24411pt`).
2. Create the figure at the fraction you will use:

   ```julia
   fig, ax, plt = plot_xy(x, y; figure=(width_fraction=0.5, textwidth_pt=455))
   save("fig.pdf", fig)
   ```

3. Include it at exactly that fraction — **never** with a different width:

   ```latex
   \includegraphics[width=0.5\textwidth]{fig.pdf}
   ```

The global `FONTSIZE` (8 pt) and the theme's label sizes (10 pt) are then literal
point sizes on paper. The LaTeX-pt vs. PDF-pt difference (72.27 vs 72 per inch)
is handled internally.

## Templates

All return `(fig, ax, plot)`; see `examples/templates.ipynb` for a gallery and
`examples/render_all.jl` to render every template to PDF.

- `plot_xy(x, y; yerr, markers, lines, errorstyle=:none|:bars|:band|:both)` —
  covers scatter, lines, scatter+lines, and every error-display combination
- `plot_heatmap(x, y, z)` — with Colorbar
- `plot_contour(x, y, z; filled, labels)`
- `plot_histogram(data; bins, normalization)`
- `plot_quiver(x, y, u, v; color_by_magnitude, lengthscale=:auto)`

Colors: `tol_bright` (colorblind-safe categorical), `SEQUENTIAL_CMAP` (viridis),
`DIVERGING_CMAP` (vik).

## List of useful links for plotting:
- Color Schemes: https://cran.r-project.org/web/packages/khroma/vignettes/tol.html
