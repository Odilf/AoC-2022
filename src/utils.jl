using HTTP

include("private.jl")

filename(day::Integer) = "$(@__DIR__)/../inputs/day$day"

filename(3)

function update_puzzle_input(day::Integer)
	@info "Fetching input for day $day"
	response = HTTP.get(
		"https://adventofcode.com/2022/day/$day/input"; 
		headers=["Cookie" => "session=$session_cookie"]
	)

	mkpath(dirname(filename(day)))
	write(filename(day), response.body |> String)
end

function get_puzzle_input(day::Integer, force_update=false)
	if !isfile(filename(day)) || force_update
		update_puzzle_input(day)
	end

	return read(filename(day)) |> String
end	

function print_solution(part1, part2, input::String)
	sol1 = nothing
	sol2 = nothing
	try
		sol1 = part1(input)
	catch
		@warn "Solution 1 doesn't work"
	end

	try
		sol2 = part2(input)
	catch
		@warn "Solution 2 doesn't work"
	end

	@info """
	The solutions are:
		- Part 1: $sol1
		- Part 2: $sol2
	"""
end