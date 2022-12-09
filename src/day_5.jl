include("utils.jl");
const input = get_puzzle_input(5);

function create_stacks(stack_structure::AbstractString)
	lines = split(stack_structure, "\n")[1:end-1]
	stacks::Vector{Vector{Char}} = map(_ -> Vector(), 1:((length(lines[1]) + 1) / 4))

	map(lines) do line
		for (i, char) ∈ enumerate(line[2:4:end])
			if char != ' '
				pushfirst!(stacks[i], char)
			end
		end
	end

	stacks
end

struct Move
	amount::Integer
	origin::Integer
	destination::Integer
end

function Move(input::AbstractString)
	data = split(input, " ")
	Move(parse(Int, data[2]), parse(Int, data[4]), parse(Int, data[6]))
end

function move!(stacks::Vector{Vector{Char}}, moves::AbstractString)
	moves = map(move_input -> Move(move_input), split(moves, "\n"))

	for move ∈ moves
		for _ ∈ 1:move.amount
			push!(stacks[move.destination], pop!(stacks[move.origin]))
		end
	end

	stacks
end

function move_preserve!(stacks::Vector{Vector{Char}}, moves::AbstractString)
	moves = map(move_input -> Move(move_input), split(moves, "\n"))

	for move ∈ moves
		buffer::Vector{Char} = Vector()
		for _ ∈ 1:move.amount
			push!(buffer, pop!(stacks[move.origin]))
		end

		while !isempty(buffer)
			push!(stacks[move.destination], pop!(buffer))
		end
	end

	stacks
end

function get_top(stacks::Vector{Vector{Char}})
	map(stacks) do stack
		isempty(stack) ? ' ' : pop!(stack)
	end |> join
end

function part1(input::String)
	stack_structure = split(input, "\n\n")[1]
	moves = split(input, "\n\n")[2][1:end-1]

	stacks = create_stacks(stack_structure)
	move!(stacks, moves)

	get_top(stacks)
end

function part2(input::String)
	stack_structure = split(input, "\n\n")[1]
	moves = split(input, "\n\n")[2][1:end-1]

	stacks = create_stacks(stack_structure)
	for move ∈ split(moves, "\n")
		move_preserve!(stacks, move)
	end

	get_top(stacks)
end

print_solution(part1, part2, input)