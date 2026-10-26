#=
    ticks and axis labels with powers of ten
=#

"""
    decade_ticks(lo, hi)

Ticks at the powers of ten 10^k (integer k) within [lo, hi], labelled in LaTeX, for a
log10 axis: `ax.yticks = decade_ticks(lo, hi)`.
"""
function decade_ticks(lo, hi)
    ks = ceil(Int, log10(lo)):floor(Int, log10(hi))
    return (10.0 .^ ks, [latexstring("10^{", k, "}") for k in ks])
end

"""
    log_ticks(lo, hi; negative=false, max_ticks=5)

Ticks m·10^k (m = 1…9, integer k) within [lo, hi] for a log10 axis over a narrow range,
labelled in LaTeX; only m = 1, 2, 5 when there would be more than `max_ticks`.
`negative=true` labels them -m·10^k, for the magnitude of a negative quantity on a
reversed axis.
"""
function log_ticks(lo, hi; negative=false, max_ticks=5)
    ticks = [(m, k) for k in floor(Int, log10(lo)):ceil(Int, log10(hi)) for m in 1:9
             if lo <= m * 10.0^k <= hi]
    length(ticks) > max_ticks && filter!(t -> t[1] in (1, 2, 5), ticks)
    vals = [m * 10.0^k for (m, k) in ticks]
    sign = negative ? "-" : ""
    labels = [m == 1 ? latexstring(sign, "10^{", k, "}") :
                       latexstring(sign, m, raw"\cdot 10^{", k, "}")
              for (m, k) in ticks]
    return vals, labels
end

"""
    power_of_ten(vmax) -> k

The exponent k = ⌊log10 |vmax|⌋, for an axis in units of 10^k: plot the values times
10^-k and label the axis with `scaled_label`, so that the tick labels stay short.
"""
power_of_ten(vmax) = floor(Int, log10(abs(vmax)))

"""
    scaled_label(label, k)

Axis label for values in units of 10^k: `label` (LaTeX math, without \$) followed by
[10^k], e.g. `scaled_label(raw"\\mathrm{Var}(H)/N^2", -4)`.
"""
scaled_label(label, k) = latexstring(label, raw"\ \ [10^{", k, "}]")
