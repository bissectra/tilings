include("./tilings.jl")
include("./dual.jl")

tiles = tiling(
	4,
    Instruction[
        (1, 1, 8),
        (1, 2, 8),
        (1, 3, 8),
        (1, 4, 8),
        (2, 3, 4),
        (3, 3, 4),
        (4, 3, 4),
        (5, 3, 4),
        (6, 3, 8),
        (7, 3, 8),
        (8, 3, 8),
        (9, 3, 8),
        (6, 4, 8),
        (7, 4, 8),
        (8, 4, 8),
        (9, 4, 8),
        (2, 5, 4),
        (3, 5, 4),
        (4, 5, 4),
        (5, 5, 4),
        (18, 3, 8),
        (19, 3, 8),
        (20, 3, 8),
        (21, 3, 8)
    ]
)

using Makie, CairoMakie

Makie.poly!(vertices::Vector{Vertex}; kwargs...) = poly!(reim.(vertices); kwargs...)
Makie.text!(v::Vertex, text::String; kwargs...) = text!(reim(v), text = text; kwargs...)
fig = Figure(size = (800, 800))
ax = Axis(fig[1, 1], aspect = DataAspect())
hidedecorations!(ax)
hidespines!(ax)

xlims!(-10, 10)
ylims!(-10, 10)

i = 0
while !isempty(tiles)
	global tiles, i
	empty!(ax)
	plot_tiling(tiles)
	save("./output/4-8-8/$(string(i)).svg", fig)
	tiles = dual(tiles)
	i += 1
end