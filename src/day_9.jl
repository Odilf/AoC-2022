include("utils.jl");
input = get_puzzle_input(9);

using Match

struct Move
	direction::Vector{<:Integer}
	amount::Integer
end

function Move(input::AbstractString)
	direction, amount = split(input, " ")

	direction =	
		  direction == "R" ? [0, 1] 
		: direction == "L" ? [0, -1]
		: direction == "U" ? [1, 0]
		: direction == "D" ? [-1, 0]
		: error("Invalid direction: $direction")

	return Move(direction, parse(Int, amount))
end

function part1(input)
	moves = Move.(filter(line -> line != "", split(input, "\n")))
	head_position = tail_position = [1, 1]
	visited = Set()

	for move ∈ moves
		for _ ∈ 1:move.amount
			head_position += move.direction
			Δ = (head_position .- tail_position)
			if sum(Δ.^2) >= 2^2
				tail_position += sign.(Δ)
			end
			push!(visited, tail_position)
		end
	end

	length(visited)
end

function ascii(visited)
	min_x = minimum(x -> x[1], visited)
	max_x = maximum(x -> x[1], visited)
	min_y = minimum(x -> x[2], visited)
	max_y = maximum(x -> x[2], visited)

	board = map(max_x:-1:min_x) do i
		map(min_y:max_y) do j
			if [i, j] ∈ visited
				"#"
			else
				"."
			end
		end
	end

	join(join.(board), "\n")
end

function part2(input)
	moves = Move.(filter(line -> line != "", split(input, "\n")))
	positions = map(_ -> [1, 1], 1:10)
	visited = Set()

	for move ∈ moves
		for _ ∈ 1:move.amount
			# Move the head
			positions[1] += move.direction

			# Move the body
			for i ∈ 2:10
				Δ = positions[i - 1] .- positions[i]
				if sum(Δ.^2) >= 2^2
					positions[i] += sign.(Δ)
				end
			end

			push!(visited, positions[10])
		end
	end

	length(visited)
end