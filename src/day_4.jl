include("utils.jl");
const input = get_puzzle_input(4);

Base.in(a::AbstractRange, b::AbstractRange) = first(a) >= first(b) && last(a) <= last(b)

part1(input) = map(filter(x -> x != "", split(input, "\n"))) do line
	ns = split.(split(line, ","), "-")
	ns = map.(n -> parse(Int, n), ns)
	
	a = ns[1][1]:ns[1][2]
	b = ns[2][1]:ns[2][2]

	a ∈ b || b ∈ a
end |> sum

function Base.intersect(a::UnitRange, b::UnitRange)
	if first(a) > first(b)
		intersect(b, a)
	else
		first(b):last(a)
	end
end

part2(input) = map(filter(x -> x != "", split(input, "\n"))) do line
	ns = split.(split(line, ","), "-")
	ns = map.(n -> parse(Int, n), ns)

	a = ns[1][1]:ns[1][2]
	b = ns[2][1]:ns[2][2]
	
	length(intersect(a, b)) > 0
end |> sum

print_solution(part1, part2, input)