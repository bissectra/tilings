include("./tilings.jl")
include("./dual.jl")

using Random
Random.seed!(0)

a = Tile([
	0.0 + 0.0im,
	1.0 + 0.0im,
	1.0 + 1.0im,
])

b = Tile((a, 0), rotate(a, - 1))
c = Tile((a, 2), rotate(a, 0)) - 1
d = Tile((c, 0), rotate(c, -1))

n = 15
r = rand(Bool, n, n)
tiles = Tile[]
for i in 0:n-1, j in 0:n-1
	if r[i+1, j+1]
		push!(tiles, a + i + j * im)
		push!(tiles, b + i + j * im)
	else
		push!(tiles, c + i + j * im)
		push!(tiles, d + i + j * im)
	end
end

using Makie, CairoMakie

Makie.poly!(vertices::Vector{Vertex}; kwargs...) = poly!(reim.(vertices); kwargs...)
Makie.text!(v::Vertex, text::String; kwargs...) = text!(reim(v), text = text; kwargs...)
fig = Figure(size = (800, 800))
ax = Axis(fig[1, 1], aspect = DataAspect())
# hidedecorations!(ax)
# hidespines!(ax)

i = 0
while !isempty(tiles)
	global tiles, i
	empty!(ax)
	plot_tiling(tiles)
	save("./output/xiaowei_$(string(i)).svg", fig)
	tiles = dual(tiles)
	i += 1
end
