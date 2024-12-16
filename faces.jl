const Vertex = Complex{Float64}

Base.angle(a, b, c) = mod(angle((a - b) / (c - b)), 2π)
Base.isapprox(a::Vertex, b::Vertex) = isapprox(a, b, atol = 1e-6)
Base.isapprox(a::Real, b::Real) = isapprox(a, b, atol = 1e-6)

function rotate(v::AbstractVector, n::Int)
	n = mod1(n, length(v))
	return vcat(v[n+1:end], v[1:n])
end

struct Tile
	vertices::Vector{Vertex}
	function Tile(vertices::Vector{Vertex})
		new(vertices)
	end
end

function Tile(n::Int, side::Real = 1)
	vertices = [exp(im * (2π * i / n)) for i in 0:n-1]
	s = abs(vertices[2] - vertices[1])
	vertices = vertices / s * side
	Tile(vertices)
end


Base.length(tile::Tile) = length(tile.vertices)
Base.getindex(tile::Tile, i::Int) = tile.vertices[mod1(i, length(tile))]


function side(tile::Tile, i::Int)
	abs(tile[i+1] - tile[i])
end

function Base.angle(tile::Tile, i::Int, after::Bool = true)
	l = length(tile)
	if after
		i = mod1(i + 1, l)
	end
	n = mod1(i + 1, l)
	p = mod1(i - 1, l)
	angle(tile[p], tile[i], tile[n])
end

struct Face
	tile::Tile
	vertices::Vector{Vertex}
	mirrored::Bool
	function Face(tile::Tile, origin::Vertex = Vertex(0, 0), alpha::Real = 0, start::Int = 1, mirrored::Bool = false)
		# compute vertices using the sides and angles of the tile
		vertices = [origin]
		range = rotate(1:length(tile), start - 1)
		range = mirrored ? reverse(range) : range
		for i in range
			s, a = side(tile, i), angle(tile, i, !mirrored)
			push!(vertices, vertices[end] + s * exp(im * (alpha)))
			alpha += pi - a
		end
		@assert vertices[1] ≈ vertices[end] "Face is not closed $(vertices[1]) ≠ $(vertices[end])"
		vertices = vertices[1:end-1]
		vertices = rotate(vertices, 1 - start)
		new(tile, vertices, mirrored)
	end
end

function Face(n::Int)
	Face(Tile(n))
end

Base.length(face::Face) = length(face.vertices)

function vertex(face::Face, i::Int)
	if face.mirrored
		return face.vertices[mod1(-i, length(face))]
	end

	return face.vertices[mod1(i, length(face))]
end

function Base.getindex(face::Face, i::Int)
	vertex(face, i)
end

function side(face::Face, i::Int)
	side(face.tile, i)
end

function Face(from::Tuple{Face, Int}, to::Tuple{Tile, Int}, mirrored::Bool = false)::Face
	@assert side(from...) ≈ side(to...) "Sides do not match"
	origin = vertex(from[1], from[2])
	after = vertex(from[1], from[2] + 1)
	if from[1].mirrored
		alpha = mirrored ? angle(origin - after) - angle(to..., false) : angle(after - origin)
		new_origin = mirrored ? after : origin
		return Face(to[1], new_origin, alpha, to[2], mirrored)
	else
		alpha = mirrored ? -angle(to..., false) + angle(after - origin) : angle(origin - after)
		new_origin = mirrored ? origin : after
		return Face(to[1], new_origin, alpha, to[2], mirrored)
	end
end

Base.show(io::IO, face::Face) = print(io, "Face($(length(face)), $(objectid(face)))")
