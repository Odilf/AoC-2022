include("utils.jl");
const input = get_puzzle_input(2);

@enum Object Rock Paper Scissors

objects_dict = Dict(
	"A" => Rock,
	"X" => Rock,
	"B" => Paper,
	"Y" => Paper,
	"C" => Scissors,
	"Z" => Scissors,
)

part1(input) = map(split(input, "\n")[1:end-1]) do round
	objects = split(round, " ")

	player = objects_dict[objects[2]]	
	opponent = objects_dict[objects[1]]

	Int(player) + 3 * result(player, opponent) + 1
end |> sum

function result(player::Object, opponent::Object)
	mod(Int(player) - Int(opponent) + 1, 3)
end

part2(input) = map(split(input, "\n")[1:end-1]) do round
	objects = split(round, " ")

	opponent = objects_dict[objects[1]]
	result = Int(objects_dict[objects[2]])

	player = mod(Int(opponent) + result - 1, 3) |> Object

	Int(player) + 1 + 3 * result
end |> sum

print_solution(part1, part2, input)