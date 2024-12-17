include("./tilings.jl")

tiles = tiling(
	12,
	[
		(1, 1, 3),
		(1, 0, 4),
		(1, -1, 6),
		(1, -2, 4),
		(1, -3, 3),
		(1, -4, 3),
		(4, 3, 4),
		(8, 4, 4),
		(9, 3, 4),
		(9, 4, 3),
		(5, 3, 3),
		(6, 3, 3),
		(7, 3, 4),
		(3, 4, 3),
		(4, -1, 3),
		(16, 2, 3),
		(17, 2, 3),
		(18, 0, 3),
		(3, 3, 4),
		(20, 3, 3),
		(21, 3, 3),
		(22, 2, 3),
		(23, 3, 3),
		(24, 2, 3),
		(20, 0, 3),
		(26, 0, 3),
		(27, 2, 3),
		(28, 2, 4),
		(29, 3, 4),
		(29, 2, 4),
		(30, 2, 4),
		(17, 0, 4),
		(33, 3, 4),
		(34, 3, 4),
		(19, 0, 4),
		(36, 3, 4),
		(37, 3, 4),
		(36, 2, 6),
		(39, 0, 3),
		(39, -1, 3),
		(40, 2, 6),
		(42, 3, 6),
		(42, 4, 6),
		(41, 2, 3),
		(39, 4, 3),
		(46, 0, 3),
		(47, 2, 3),
		(48, 0, 3),
		(49, 2, 3),
		(39, 3, 4),
		(51, 4, 4),
		(52, 3, 4),
		(53, 3, 4),
		(10, 2, 3),
		(55, 2, 3),
		(56, 2, 3),
		(57, 0, 3),
		(58, 2, 3),
		(59, 0, 3),
		(12, 2, 4),
		(13, 2, 3),
		(14, 3, 4),
		(63, 3, 3),
		(64, 0, 3),
		(65, 2, 3),
		(66, 2, 3),
		(67, 0, 4),
		(68, 3, 4),
		(69, 3, 4),
		(66, 0, 4),
		(71, 3, 4),
		(72, 3, 4),
		(73, 3, 3),
		(74, 2, 3),
		(75, 0, 3),
		(76, 2, 3),
		(77, 0, 3),
		(78, 2, 3),
		(79, 0, 3),
		(71, 2, 3),
		(72, 2, 3),
		(73, 2, 3),
		(81, 0, 3),
		(82, 0, 3),
		(84, 2, 3),
		(85, 2, 3),
		(86, 0, 3),
		(88, 2, 3),
		(75, 2, 4),
		(90, 3, 4),
		(91, 3, 4),
		(90, 4, 4),
		(93, 2, 4),
		(94, 3, 4),
		(93, 3, 4),
		(96, 2, 4),
		(97, 3, 4),
		(70, 3, 3),
		(99, 0, 3),
		(100, 2, 3),
		(101, 2, 3),
		(102, 0, 3),
		(103, 0, 3),
		(104, 0, 3),
		(105, 0, 3),
		(105, 2, 3),
		(30, 3, 4),
		(108, 3, 4),
		(109, 3, 4),
		(32, 0, 4),
		(111, 3, 4),
		(112, 3, 4),
		(25, 0, 3),
		(114, 2, 3),
		(115, 0, 3),
		(116, 2, 3),
		(117, 0, 3),
		(35, 3, 4),
		(119, 3, 4),
		(38, 3, 4),
		(121, 3, 4),
		(121, 2, 3),
		(123, 0, 3),
		(124, 0, 3),
	],
)

reflection(z, p, q) = p + (q - p) * conj((z - p) / (q - p))
a = tiles[1][7]
b = tiles[1][8]
d = tiles[2][3]
e = reflection(d, a, b)

append!(tiles, reflection.(tiles, a, b))
append!(tiles, reflection.(tiles, d, e))

using Makie, CairoMakie, Colors

colors = Dict(
	3 => RGB(218 / 255, 191 / 255, 255 / 255),
	4 => RGB(144 / 255, 122 / 255, 214 / 255),
	6 => RGB(79 / 255, 81 / 255, 140 / 255),
	12 => RGB(44 / 255, 42 / 255, 74 / 255),
)

Makie.poly!(vertices::Vector{Vertex}; kwargs...) = poly!(reim.(vertices); kwargs...)
Makie.text!(v::Vertex, text::String; kwargs...) = text!(reim(v), text = text; kwargs...)
line!(a::Vertex, b::Vertex; kwargs...) = lines!([reim(a), reim(b)]; kwargs...)
fig = Figure(size = (800, 800))
ax = Axis(fig[1, 1], aspect = DataAspect())
hidedecorations!(ax)
hidespines!(ax)
for (i, tile) in enumerate(tiles)
	poly!(tile.vertices, color = colors[length(tile)])
	for i in 1:length(tile)
		line!(tile[i], tile[i+1], color = :white, linewidth = 0.5)
	end
	# c = centroid(tile)
	# line!(c, (tile[1] + tile[2]) / 2, color = :white, linewidth = 0.5)
	# text!(c, string(i), align = (:center, :center), color = :white)
end
save("output.svg", fig)
fig