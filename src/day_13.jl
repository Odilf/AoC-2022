include("utils.jl");
const input = get_puzzle_input(13);

Base.Vector(input::AbstractString) = eval(Meta.parse(input))

isrightorder(left::Integer, right::Integer) = left == right ? missing : left < right
isrightorder(left::Vector{T}, right::Integer) where T = isrightorder(left, [right])
isrightorder(left::Integer, right::Vector{T}) where T = isrightorder([left], right)

function isrightorder(left::Vector{T}, right::Vector{S}) where { T, S }
	for (l, r) ∈ zip(left, right)
		order = isrightorder(l, r)
		if order !== missing
			return order
		end
	end
	
	isrightorder(length(left), length(right))
end

function part1(input)
	pairs = split(input, "\n\n")
	pairs = filter.(x -> x != "", split.(pairs, "\n"))
	pairs = [Vector.(pair) for pair ∈ pairs]

	[isrightorder(l, r) ? i : 0 for (i, (l, r)) ∈ enumerate(pairs)] |> sum
end

function part2(input)
	entries = filter(line -> length(line) > 0, split(input, "\n"))
	markers = [Vector("[[6]]"), Vector("[[2]]")]
	entries = [Vector.(entries)..., markers...]

	result = sort(entries; lt=isrightorder)
	prod(map(marker -> findfirst(x -> x == marker, result), markers))
end

print_solution(part1, part2, input)