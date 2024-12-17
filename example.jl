include("./tilings.jl")

tile = Tile([
	0.0 + 0.0im,
	1.0 + 0.0im,
	1.0 + 2.0im,
	0.0 + 1.0im,
])

tiles = [tile, Tile((tile, 2), rotate(tile), true)]

using Makie, CairoMakie, Colors

Makie.poly!(vertices::Vector{Vertex}; kwargs...) = poly!(reim.(vertices); kwargs...)
Makie.text!(v::Vertex, text::String; kwargs...) = text!(reim(v), text = text; kwargs...)
line!(a::Vertex, b::Vertex; kwargs...) = lines!([reim(a), reim(b)]; kwargs...)
fig = Figure(size = (800, 800))
ax = Axis(fig[1, 1], aspect = DataAspect())
hidedecorations!(ax)
hidespines!(ax)
for (i, tile) in enumerate(tiles)
	poly!(tile.vertices)
	for i in 1:length(tile)
		line!(tile[i], tile[i+1], color = :white, linewidth = 0.5)
	end
	# c = centroid(tile)
	# line!(c, (tile[1] + tile[2]) / 2, color = :white, linewidth = 0.5)
	# text!(c, string(i), align = (:center, :center), color = :white)
end
save("output.svg", fig)
fig
