include("./tilings.jl")
include("./dual.jl")

l = Tile([
    0.0 + 0.0im,
    1.0 + 0.0im,
    2.0 + 0.0im,
    2.0 + 1.0im,
    1.0 + 1.0im,
    1.0 + 2.0im,
    0.0 + 2.0im,
    0.0 + 1.0im
])
j = Tile((l , 3), flip(rotate(l, 2)))
j -= j[2]
k = Tile((l, -2), rotate(l, 2))
k -= k[1]

tiles = Tile[]

for i = 0:7
    push!(tiles, l + (1 + im) * i)
end

for i = 0:3
    push!(tiles, j + 2 + (2 + 2im) * i)
    push!(tiles, k + 2im + (2 + 2im) * i)
end

h = rotate(tiles[1], 5)

push!(tiles, Tile((tiles[10], 6), l))
push!(tiles, Tile((tiles[17], 4), k))
push!(tiles, Tile((tiles[17], 6), k))
push!(tiles, Tile((tiles[12], 5), h))
push!(tiles, Tile((tiles[9], 4), rotate(l, -1)))
push!(tiles, Tile((tiles[21], 5), rotate(l, -2)))
push!(tiles, Tile((tiles[21], 4), rotate(l, -3)))
push!(tiles, Tile((tiles[13], 2), rotate(l, 1)))

tiles = tiles[setdiff(1:length(tiles), [8, 15, 16])]


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
	save("./output/lshape/$(string(i)).svg", fig)
	tiles = dual(tiles)
	i += 1
end