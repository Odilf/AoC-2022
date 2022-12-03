using HTTP

include("private.jl")

filename(day::Integer) = "inputs/day$day"

function update_puzzle_input(day::Integer)
	@info "Fetching input for day $day"
	response = HTTP.get(
		"https://adventofcode.com/2022/day/$day/input"; 
		headers=["Cookie" => "session=$session_cookie"]
	)

	mkpath(dirname(filename(day)))
	write(filename(day), response.body |> String)
end

function get_puzzle_input(day::Integer)
	if !isfile(filename(day))
		update_puzzle_input(day)
	end

	return read(filename(day))
end