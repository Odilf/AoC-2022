include("utils.jl");
const input = get_puzzle_input(1);

part1(input) = map(split(input, "\n\n")) do list
	list = split(list, "\n")
	list = filter(i -> length(i) != 0, list)
	reduce(+, parse.(Int, list))
end |> maximum

function part2(input)
	sums = map(split(input, "\n\n")) do list
		list = split(list, "\n")
		list = filter(i -> length(i) != 0, list)
		reduce(+, parse.(Int, list))
	end

	sort(sums)[end-2:end] |> sum
end

print_solution(part1, part2, input)