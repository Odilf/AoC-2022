include("utils.jl");
const input = get_puzzle_input(10);

function develop_values(input)
	x = 1
	values::Vector{Int} = Vector()
	for line ∈ filter(line -> line != "", split(input, "\n"))
		push!(values, x)
		
		instructions = split(line, " ")
		if instructions[1] == "addx"
			push!(values, x)
			x += parse(Int, instructions[2])
		end

	end

	values
end

function part1(input)
	values = develop_values(input)
	sum([values[i] * i for i ∈ 20:40:length(values)])
end


function part2(input)
	values = develop_values(input)

	values = reshape(values, (40, 6)) |> transpose

	chars = map(1:6) do i
		map(1:40) do j
			if abs(values[i, j] - j + 1) <= 1
				"█"
			else
				" "
			end
		end
	end

	"\n" * join(join.(chars), "\n")
end

print_solution(part1, part2, input)