include("utils.jl");
input = get_puzzle_input(6);

function part1(input)
	for i ∈ 1:length(input)-4
		word = input[i:i+3]
		if length(Set([word...])) == 4
			return i + 3
		end
	end
end

function part2(input)
	for i ∈ 1:length(input)-14
		word = input[i:i+13]
		if length(Set([word...])) == 14
			return i + 13
		end
	end
end