include("./tilings.jl")
include("./dual.jl")

tile1 = Tile([
	0.0 + 0.0im,
	1.0 + 0.0im,
	1.0 + 2.0im,
	0.0 + 1.0im,
])

tile2 = Tile((tile1, 2), flip(rotate(tile1)))
tile3 = Tile((tile2, 0), flip(rotate(tile2, -1)))
tile4 = Tile((tile3, 0), flip(rotate(tile3, -1)))
tile5 = Tile((tile4, 0), flip(rotate(tile4, -1)))
tile6 = Tile((tile5, 0), flip(rotate(tile5, -1)))
tile7 = Tile((tile6, 0), flip(rotate(tile6, -1)))
tile8 = Tile((tile7, 0), flip(rotate(tile7, -1)))

tile9 = Tile((tile3, 3), flip(rotate(tile3, 2)))
tile10 = Tile((tile9, 0), flip(rotate(tile9, -1)))
tile11 = Tile((tile10, 2), flip(rotate(tile10, 1)))
tile12 = Tile((tile11, 2), flip(rotate(tile11, 1)))
tile13 = Tile((tile12, 2), flip(rotate(tile12, 1)))
tile14 = Tile((tile13, 2), flip(rotate(tile13, 1)))
tile15 = Tile((tile14, 2), flip(rotate(tile14, 1)))
tile16 = Tile((tile15, 2), flip(rotate(tile15, 1)))

tile17 = Tile((tile16, 0), flip(rotate(tile16, -1)))
tile18 = Tile((tile17, 0), flip(rotate(tile17, -1)))
tile19 = Tile((tile18, 2), flip(rotate(tile18, 1)))
tile20 = Tile((tile19, 2), flip(rotate(tile19, 1)))
tile21 = Tile((tile20, 2), flip(rotate(tile20, 1)))
tile22 = Tile((tile21, 2), flip(rotate(tile21, 1)))
tile23 = Tile((tile22, 2), flip(rotate(tile22, 1)))
tile24 = Tile((tile23, 2), flip(rotate(tile23, 1)))

tile25 = Tile((tile24, 0), flip(rotate(tile24, -1)))
tile26 = Tile((tile25, 0), flip(rotate(tile25, -1)))
tile27 = Tile((tile26, 2), flip(rotate(tile26, 1)))
tile28 = Tile((tile27, 2), flip(rotate(tile27, 1)))
tile29 = Tile((tile28, 2), flip(rotate(tile28, 1)))
tile30 = Tile((tile29, 2), flip(rotate(tile29, 1)))
tile31 = Tile((tile30, 2), flip(rotate(tile30, 1)))
tile32 = Tile((tile31, 2), flip(rotate(tile31, 1)))

squ1 = Tile((tile2, 3), Tile(4))
squ2 = Tile((squ1, 3), Tile(4))
squ3 = Tile((squ2, 2), Tile(4))
squ4 = Tile((squ3, 2), Tile(4))

tiles = [tile1, tile2, tile3, tile4, tile5, tile6, tile7, tile8, tile9, tile10, tile11, tile12, tile13, tile14, tile15, tile16, tile17, tile18,  tile19, tile20, tile21, tile22, tile23, tile24, tile25, tile26, tile27, tile28, tile29, tile30, tile31, tile32, squ1, squ2, squ3, squ4
]

using Makie, CairoMakie

Makie.poly!(vertices::Vector{Vertex}; kwargs...) = poly!(reim.(vertices); kwargs...)
Makie.text!(v::Vertex, text::String; kwargs...) = text!(reim(v), text = text; kwargs...)
fig = Figure(size = (800, 800))
ax = Axis(fig[1, 1], aspect = DataAspect())
hidedecorations!(ax)
hidespines!(ax)

i = 0
while !isempty(tiles)
	global tiles, i
	empty!(ax)
	plot_tiling(tiles)
	save("./output/example/$(string(i)).svg", fig)
	tiles = dual(tiles)
	i += 1
end
