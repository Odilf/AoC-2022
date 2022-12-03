include("utils.jl")
input = get_puzzle_input(3)

priority(char::Char) = Int(char) - (islowercase(char) ? 96 : 38)

map(filter(line -> line != "", split(input, "\n"))) do line
	s1 = line[1:end ÷ 2]
	s2 = line[end ÷ 2 + 1:end]

	char = intersect(Set(s1), Set(s2)) |> first
	priority(char)
end |> sum


map(reshape(filter(line -> line != "", split(input, "\n")), (3, :)) |> eachcol) do rucksacks
	intersect(Set.(rucksacks)...) |> first |> priority
end |> sum