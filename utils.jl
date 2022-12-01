using HTTP

const session_cookie = "53616c7465645f5fc14484efb11094ab73ec11289ab7e007de3898cf2b0bbc5adcd60ea1a47da97b4a1bb14f76296bebb0e427c1609827c45fee271bbf187219"

function get_puzzle_input(day::Integer)
	response = HTTP.get(
		"https://adventofcode.com/2022/day/$day/input"; 
		headers=["Cookie" => "session=$session_cookie"]
	)

	return response.body |> String
end