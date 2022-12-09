include("utils.jl");
const input = get_puzzle_input(3);

priority(char::Char) = Int(char) - (islowercase(char) ? 96 : 38)

part1(input) = map(filter(line -> line != "", split(input, "\n"))) do line
	s1 = line[1:end ÷ 2]
	s2 = line[end ÷ 2 + 1:end]

	char = intersect(Set(s1), Set(s2)) |> first
	priority(char)
end |> sum


part2(input) = map(reshape(filter(line -> line != "", split(input, "\n")), (3, :)) |> eachcol) do rucksacks
	intersect(Set.(rucksacks)...) |> first |> priority
end |> sum

print_solution(part1, part2, input)