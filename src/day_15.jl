include("utils.jl");
const input = get_puzzle_input(15);

test_input = """
Sensor at x=2, y=18: closest beacon is at x=-2, y=15
Sensor at x=9, y=16: closest beacon is at x=10, y=16
Sensor at x=13, y=2: closest beacon is at x=15, y=3
Sensor at x=12, y=14: closest beacon is at x=10, y=16
Sensor at x=10, y=20: closest beacon is at x=10, y=16
Sensor at x=14, y=17: closest beacon is at x=10, y=16
Sensor at x=8, y=7: closest beacon is at x=2, y=10
Sensor at x=2, y=0: closest beacon is at x=2, y=10
Sensor at x=0, y=11: closest beacon is at x=2, y=10
Sensor at x=20, y=14: closest beacon is at x=25, y=17
Sensor at x=17, y=20: closest beacon is at x=21, y=22
Sensor at x=16, y=7: closest beacon is at x=15, y=3
Sensor at x=14, y=3: closest beacon is at x=15, y=3
Sensor at x=20, y=1: closest beacon is at x=15, y=3
"""

function Base.parse(input::AbstractString)
	lines = filter(line -> length(line) > 0, split(input, "\n"))
	map(lines) do line
		sensor, beacon = split(line, ": closest beacon is at ")
		map([sensor[11:end], beacon]) do item
			x, y = strip.(split(item, ","))
			parse.(Int, [x[3:end], y[3:end]])
		end
	end
end

manhattan(a, b) = sum(abs.(a .- b))

inrange(position, sensor, radius::Integer) = manhattan(position, sensor) <= radius
inrange(position, sensor, beacon::Vector{<:Integer}) = inrange(position, sensor, manhattan(sensor, beacon))

function part1(input; y=2000000)
	input = parse(input)

	covered::Set{Int} = Set()

	for (sensor, beacon) ∈ input
		radius = manhattan(sensor, beacon)
		range = radius - abs(sensor[2] - y)
		for x ∈ -range:range
			x += sensor[1]
			if [x, y] != beacon
				push!(covered, x)
			end
		end
	end

	length(covered)
end

function distance_to_leave(position, sensors_beacons)
	map(sensors_beacons) do (sensor, beacon)
		radius = manhattan(sensor, beacon)
		distance = manhattan(position, sensor)
		radius - distance
	end |> maximum
end

frequency(pos) = pos[1] * 4_000_000 + pos[2]

function part2(input; range=4_000_000)
	input = parse(input)

	input = map(input) do (sensor, beacon)
		sensor, manhattan(sensor, beacon)
	end

	result = nothing
	visited::Set{Vector{Int}} = Set()

	Threads.@threads for (sensor, radius) ∈ input
		for x ∈ max(0, sensor[1] - radius - 1):min(sensor[1] + radius + 1, range)
			yrange = abs(radius - abs(x - sensor[1]))
			ys = [
				[x, sensor[2] + yrange + 1]
				[x, sensor[2] - yrange - 1]
			]
			
			for y ∈ ys
				if [x, y] ∈ visited
					continue
				end
				
				if (0 <= y <= range) && all(p -> !inrange([x, y], p...), input)
					result = [x, y]
					return frequency([x, y])
				else
					push!(visited, [x, y])
				end
			end
		end
	end

	frequency(result)
end

@time part2(test_input; range=20)
@time part2(input)