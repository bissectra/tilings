include("./tilings.jl")

Base.isapprox(a::Vertex, b::Vertex) = abs(b-a) < 1e-6

function dual(tiles::Vector{Tile})
    vertices = Dict{Vertex, Vector{Tuple{Tile, Int}}}()
    for tile in tiles
        for (i, vertex) in enumerate(tile)
            # for each u in vertices, verify that vertex and u are approx the same. If so, put 
            found = false
            for (u, utiles) in vertices
                if isapprox(u, vertex)
                    push!(utiles, (tile, i))
                    found = true
                    break
                end
            end
            if !found
             vertices[vertex] = [(tile, i)]
            end
        end
    end

    dual_tiles = Tile[]
    for (vertex, connected_tiles) in vertices
        # sort connected_tiles by relative angle of next vertex
        function sort_func(x)
            tile, i = x
            angle(tile[i+1] - tile[i])
        end
        connected_tiles = sort(connected_tiles, by = sort_func)
        centroids = [centroid(tile) for (tile, _) in connected_tiles]
        # alpha = sum(angle(tile, i) for (tile, i) in connected_tiles)
        # TODO: make sure the alpha check works for the dual of the dual.
        if length(centroids) >= 3 # && abs(alpha - 2pi) < 1e-6
            push!(dual_tiles, Tile(centroids))
        end
    end

    dual_tiles
end