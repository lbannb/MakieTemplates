# Every text element in a template must render at MakieTemplates.FONTSIZE.
# Run: julia --project=. test/test_fontsize.jl
using MakieTemplates, CairoMakie

MakieTemplates.main_theme!()
F = MakieTemplates.FONTSIZE

fig = MakieTemplates.paper_figure()
ax = Axis(fig[1, 1], title="t", subtitle="s", xlabel="x", ylabel=L"\alpha")
hm = heatmap!(ax, rand(3, 3))
cb = Colorbar(fig[1, 2], hm, label="c")
txt = text!(ax, 1, 1, text=L"\beta")           # heatmap cell label / annotation
lines!(ax, 1:3, 1:3, label="l")
lg = Legend(fig[2, 1], ax, "legend title")
lab = Label(fig[3, 1], "figure label")
ax3 = Axis3(fig[4, 1], title="t3", xlabel="x", ylabel="y", zlabel="z")

checks = [
    ("Axis", ax, [:titlesize, :subtitlesize, :xlabelsize, :ylabelsize,
                  :xticklabelsize, :yticklabelsize]),
    ("Colorbar", cb, [:labelsize, :ticklabelsize]),
    ("Legend", lg, [:labelsize, :titlesize]),
    ("Label", lab, [:fontsize]),
    ("Axis3", ax3, [:titlesize, :xlabelsize, :ylabelsize, :zlabelsize,
                    :xticklabelsize, :yticklabelsize, :zticklabelsize]),
]

for (name, obj, attrs) in checks, a in attrs
    got = to_value(getproperty(obj, a))
    @assert got == F "$name.$a == $got, expected FONTSIZE == $F"
end
@assert to_value(txt.fontsize) == F "text!.fontsize == $(to_value(txt.fontsize)), expected $F"

println("OK: all text elements at FONTSIZE = $F")
