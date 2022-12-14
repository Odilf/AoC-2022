include("utils.jl");
const input = get_puzzle_input(14);

using Memoize

struct Point
	x::Integer
	y::Integer
end

Point(input::AbstractString) = Point(parse.(Int, split(input, ","))...)

function parse_input(input)
	lines = filter(x -> length(x) > 0, split(input, "\n"))
	lines = map(line -> split(line, " -> ") .|> Point, lines)
end

function Base.in(p::Point, s::Point, e::Point)
	p == s || p == e || (
		(s.x <= p.x) == (p.x <= e.x) && 
		(s.y <= p.y) == (p.y <= e.y)
	)
end

function inpath(point::Point, path::Vector{Point})
	any(((i, p),) -> in(point, p, path[i + 1]), enumerate(path[1:end-1]))
end

@memoize function Base.in(point::Point, rocks::Vector{Vector{Point}})
	any(path -> inpath(point, path), rocks)
end

move(point::Point; x::Integer=0, y::Integer=0) = Point(point.x + x, point.y + y)

function dropsand(rocks, sands, point = Point(500, 0); min=typemax(Int), floor=typemax(Int))
	if point.y + 1 == floor
		return point
	end

	if point.y > min
		return nothing
	end	

	candidates = [
		move(point; 	  y=1), 
		move(point; x=-1, y=1), 
		move(point; x=1,  y=1),
	]

	for candidate ∈ candidates
		if candidate ∉ rocks && candidate ∉ sands
			return dropsand(rocks, sands, candidate; min, floor)
		end
	end

	return point
end

function maxheight(rocks) 
	ymax = typemin(Int)
	for path ∈ rocks
		for point ∈ path
			ymax = max(ymax, point.y)
		end
	end
	ymax
end

function part1(input)
	rocks = parse_input(input)
	ymax = maxheight(rocks)
	
	sands::Vector{Point} = []
	while (drop_location = dropsand(rocks, sands; min=ymax)) !== nothing
		sands = [sands..., drop_location]
	end

	length(sands)
end

function part2(input)
	rocks = parse_input(input)
	ymax = maxheight(rocks)
	
	sands::Set{Point} = Set()
	while (drop_location = dropsand(rocks, sands; floor=ymax+2)) != Point(500, 0)
		sands = push!(sands, drop_location)
	end

	length(sands) + 1
end

print_solution(part1, part2, input)