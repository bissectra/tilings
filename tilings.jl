const Vertex = Complex{Float64}
struct Tile
	vertices::Vector{Vertex}
	function Tile(vertices::Vector{Vertex})
		length(vertices) ≥ 3 || throw(ArgumentError("Number of vertices must be at least 3"))
		new(vertices)
	end
end

Base.length(tile::Tile) = length(tile.vertices)
Base.getindex(tile::Tile, i::Int) = tile.vertices[mod1(i, length(tile))]
Base.getindex(tile::Tile, v::AbstractVector) = [tile[i] for i in v]
Base.iterate(tile::Tile, i::Int=1) = i > length(tile) ? nothing : (tile[i], i+1)
side(tile::Tile, i::Int) = abs(tile[i+1] - tile[i])
Base.angle(a, b, c) = mod(angle((a - b) / (c - b)), 2π)
Base.angle(tile::Tile, i::Int) = angle(tile[i], tile[i+1], tile[i+2])
Base.:+(tile::Tile, v::Vertex) = Tile(tile.vertices .+ v)
Base.:+(v::Vertex, tile::Tile) = Tile(v .+ tile.vertices)
Base.:*(tile::Tile, v::Vertex) = Tile(tile.vertices .* v)
Base.:*(v::Vertex, tile::Tile) = Tile(v .* tile.vertices)
Base.:-(tile::Tile, v::Vertex) = Tile(tile.vertices .- v)
Base.:/(tile::Tile, v::Vertex) = Tile(tile.vertices ./ v)
Base.conj(tile::Tile) = Tile(conj.(tile.vertices))

function rotate(tile::Tile)::Tile
	a1, a2 = tile[1:2]
	alpha = -pi + angle(tile, 1)
	v = a1 - a2 * cis(alpha)
	f(z) = v + z * cis(alpha)
	vertices = f.(tile.vertices)
	vertices = vcat(vertices[2:end], vertices[1])
	Tile(vertices)
end

function rotate(tile::Tile, n::Int)::Tile
	n = mod1(n, length(tile))
	for _ in 1:n
		tile = rotate(tile)
	end
	tile
end

function Tile(tile::Tile, a1::Vertex, a2::Vertex)::Tile
	tol = 1e-6
	b1, b2 = tile[1:2]
	@assert abs(abs(b2 - b1) - abs(a2 - a1)) < tol "Side lengths do not match"
	theta = angle((b2 - b1) / (a2 - a1))
	v = a1 - b1 * cis(-theta)
	f(z) = v + z * cis(-theta)
	Tile(f.(tile.vertices))
end

function Tile(tile::Tile, a1::Vertex, a2::Vertex, mirrored::Bool)::Tile
	!mirrored && return Tile(tile, a1, a2)
	Tile(conj(tile), a2, a1)
end

function Tile(base::Tuple{Tile, Int}, tile::Tile, mirrored::Bool=false)::Tile
	base, side = base
	return Tile(tile, base[side+1], base[side], mirrored)
end

function Tile(n::Int)::Tile
	vertices = [exp(im * (2π * (i - 0.5) / n)) for i in 0:n-1]
	vertices /= abs(vertices[2] - vertices[1])
	Tile(vertices)
end

centroid(tile::Tile)::Vertex = sum(tile.vertices) / length(tile)

Tile(base::Tuple{Tile, Int}, n::Int)::Tile = Tile(base, Tile(n))

Instruction = Tuple{Int, Int, Int}
function tiling(root::Int, instructions::Vector{Instruction})::Vector{Tile}
	tiles = [Tile(root)]
	for (index, side, n) in instructions
		push!(tiles, Tile((tiles[index], side), n))
	end
	tiles
end

reflection(z, p, q) = p + (q - p) * conj((z - p) / (q - p))

function reflection(tile::Tile, p, q)
    vertices = [reflection(v, p, q) for v in tile.vertices]
    vertices = reverse(vertices)
    vertices = vcat(vertices[end-1:end], vertices[1:end-2])
    Tile(vertices)
end