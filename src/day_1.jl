include("utils.jl")
input = get_puzzle_input(1)

# Part 1
map(split(input, "\n\n")) do list
	list = split(list, "\n")
	list = filter(i -> length(i) != 0, list)
	reduce(+, parse.(Int, list))
end |> maximum

# Part 2
(map(split(input, "\n\n")) do list
	list = split(list, "\n")
	list = filter(i -> length(i) != 0, list)
	reduce(+, parse.(Int, list))
end |> sort)[end-2:end] |> sum