include("utils.jl");
const input = get_puzzle_input(8);

inbounds(arr::Vector{Vector{Int64}}, coords) = 
	coords[1] <= length(arr) && coords[1] > 0 &&
	coords[2] <= length(arr[1]) && coords[2] > 0 

function isvisible(i::Integer, j::Integer, lines::Vector{<:Vector{<:Integer}})
	directions = [[1, 0], [0, 1], [-1, 0], [0, -1]]

	any(directions) do dir
		pos = [i, j] + dir
		while inbounds(lines, pos)
			if lines[pos[1]][pos[2]] >= lines[i][j]
				return false
			end
			pos += dir
		end

		return true
	end
end

function part1(input)
	lines = split(input, "\n")
	lines = filter(line -> line != "", lines)
	lines = map(line -> [parse(Int, char) for char ∈ line], lines)

	result = map(enumerate(lines)) do (i, line)
		map(enumerate(line)) do (j, num)
			isvisible(i, j, lines)
		end
	end |> sum |> sum 
end


function scenicscore(i::Integer, j::Integer, lines::Vector{<:Vector{<:Integer}})
	directions = [[1, 0], [0, 1], [-1, 0], [0, -1]]

	map(directions) do dir
		d = 0
		pos = [i, j] + dir * d
		while inbounds(lines, pos + dir)
			d += 1
			pos += dir
			if lines[pos[1]][pos[2]] >= lines[i][j]
				break
			end
		end
		d
	end |> prod
end

function part2(input)
	lines = split(input, "\n")
	lines = filter(line -> line != "", lines)
	lines = map(line -> [parse(Int, char) for char ∈ line], lines)

	result = map(enumerate(lines)) do (i, line)
		map(enumerate(line)) do (j, num)
			scenicscore(i, j, lines)
		end
	end

	maximum(maximum.(result))
end

print_solution(part1, part2, input)