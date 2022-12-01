using HTTP

include("private.jl")

function get_puzzle_input(day::Integer)
	response = HTTP.get(
		"https://adventofcode.com/2022/day/$day/input"; 
		headers=["Cookie" => "session=$session_cookie"]
	)

	return response.body |> String
end