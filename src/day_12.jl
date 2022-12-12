include("utils.jl");
const input = get_puzzle_input(12);

function to_matrix(input::AbstractString)
	lines = split(input, "\n")
	lines = filter(x -> length(x) > 0, lines)
	chars = vcat(split.(lines, "")...)
	chars = [c[1] for c ∈ chars]
	reshape(chars, (:, length(lines))) |> permutedims
end

function Base.findfirst(char::Char, input::AbstractString)
	matrix = to_matrix(input)
	for i ∈ CartesianIndices(size(matrix))
		if matrix[i] == char
			return i
		end
	end

	return nothing
end

value(coord, m) = Int(m[coord] == 'S' ? 'a' : m[coord] == 'E' ? 'z' : m[coord])

function can_move(from, to, m)
	value(to, m) <= value(from, m) + 1
end

function get_neighbours(coords, m)
	neighbours = []
	if coords.I[1] > 1
		neighbour = CartesianIndex(coords.I[1] - 1, coords.I[2])
		if can_move(coords, neighbour, m)
			push!(neighbours, neighbour)
		end
	end

	if coords.I[1] < size(m, 1)
		neighbour = CartesianIndex(coords.I[1] + 1, coords.I[2])
		if can_move(coords, neighbour, m)
			push!(neighbours, neighbour)
		end
	end

	if coords.I[2] > 1
		neighbour = CartesianIndex(coords.I[1], coords.I[2] - 1)
		if can_move(coords, neighbour, m)
			push!(neighbours, neighbour)
		end
	end

	if coords.I[2] < size(m, 2)
		neighbour = CartesianIndex(coords.I[1], coords.I[2] + 1)
		if can_move(coords, neighbour, m)
			push!(neighbours, neighbour)
		end
	end

	return neighbours
end

function dijkstra(starts, finish, neighbours)
	visited = Set{CartesianIndex}()
	distances = Dict{CartesianIndex, Int}()

	for start ∈ starts
		distances[start] = 0
	end

	while length(visited) < length(distances)
		# Find the node with the smallest distance
		min_node = nothing
		min_distance = typemax(Int)
		for node ∈ keys(distances)
			if node ∉ visited && distances[node] < min_distance
				min_node = node
				min_distance = distances[node]
			end
		end

		# Mark the node as visited
		push!(visited, min_node)

		# Update the distances of the neighbours
		for neighbour ∈ neighbours(min_node)
			if neighbour ∉ visited
				new_distance = distances[min_node] + 1
				if neighbour ∉ keys(distances) || new_distance < distances[neighbour]
					distances[neighbour] = new_distance
				end
			end
		end
	end

	return distances[finish]
end

function part1(input)
	m = to_matrix(input)
	start = findfirst('S', input)
	finish = findfirst('E', input)

	dijkstra([start], finish, x -> get_neighbours(x, m))
end

function part2(input)
	m = to_matrix(input)
	start = findfirst('S', input)
	finish = findfirst('E', input)

	starts = [start, findall(x -> x == 'a', m)...]
	dijkstra(starts, finish, x -> get_neighbours(x, m))
	
end

print_solution(part1, part2, input)