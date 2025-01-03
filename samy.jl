include("./tilings.jl")
include("./dual.jl")

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

a = tiles[1][7]
b = tiles[1][8]
d = tiles[2][3]
e = reflection(d, a, b)

left_tiles = tiles[setdiff(1:length(tiles), [7, 14, 63, 64, 67, 68, 69, 70, 99, 102, 103])]
tiles = append!(left_tiles, reflection.(tiles, a, b))

up_tiles = tiles[setdiff(1:length(tiles), [224, 223, 222, 144, 143, 142, 116, 115, 1, 2, 26, 27, 28, 97, 98, 99])]
tiles = append!(up_tiles, reflection.(tiles, d, e))

using Makie, CairoMakie

Makie.poly!(vertices::Vector{Vertex}; kwargs...) = poly!(reim.(vertices); kwargs...)
Makie.text!(v::Vertex, text::String; kwargs...) = text!(reim(v), text = text; kwargs...)
fig = Figure(size = (800, 800))
ax = Axis(fig[1, 1], aspect = DataAspect())
hidedecorations!(ax)
hidespines!(ax)

xmax = maximum(maximum.(real.(tiles)))
xmin = minimum(minimum.(real.(tiles)))
ymax = maximum(maximum.(imag.(tiles)))
ymin = minimum(minimum.(imag.(tiles)))

xlims!(xmin, xmax)
ylims!(ymin, ymax)

i = 0
while !isempty(tiles)
	global tiles, i
	empty!(ax)
	plot_tiling(tiles)
	save("./output/samy/$(string(i)).svg", fig)
	tiles = dual(tiles)
	i += 1
end