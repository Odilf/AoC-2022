include("utils.jl");
const input = get_puzzle_input(11);

struct Monkey
	items::Vector{<:Integer}
	operation
	test::Integer
	pass::Integer
	fail::Integer
end

function Monkey(input::AbstractString)
	lines = split(input, "\n")
	items = parse.(BigInt, split(lines[2][19:end], ", "))

	operation = old -> begin
		value = split(lines[3], " ")[end]
		if value == "old"
			return old * old
		end
		n = parse(Int, value)
		op = split(lines[3], " ")[end-1] == "*" ? (*) : (+)
		return op(old, n)
	end

	test = parse(Int, split(lines[4], " ")[end])

	pass = parse(Int, split(lines[5], " ")[end]) + 1
	fail = parse(Int, split(lines[6], " ")[end]) + 1

	Monkey(items, operation, test, pass, fail)
end

function advance_round!(monkeys::Vector{Monkey}, callback = identity; divide::Bool, lcm=lcm([m.test for m ∈ monkeys]))
	for monkey ∈ monkeys
		while length(monkey.items) > 0
			worry_level = popfirst!(monkey.items)
			new_worry_level = monkey.operation(worry_level)
			if divide
				new_worry_level = new_worry_level ÷ 3
			end
			callback(monkey)

			new_worry_level = new_worry_level % lcm

			if new_worry_level % monkey.test == 0
				push!(monkeys[monkey.pass].items, new_worry_level)
			else
				push!(monkeys[monkey.fail].items, new_worry_level)
			end
		end
	end
end

function part1(input)
	monkeys = Monkey.(split(input, "\n\n"))
	inspections = Dict()
	for monkey ∈ monkeys
		inspections[monkey] = 0
	end

	for _ ∈ 1:20
		advance_round!(monkeys, monkey -> inspections[monkey] += 1; divide=true)
	end

	sort(values(inspections) |> collect)[end-1:end] |> prod
end

function part2(input)
	monkeys = Monkey.(split(input, "\n\n"))
	inspections = Dict()
	for monkey ∈ monkeys
		inspections[monkey] = BigInt(0)
	end

	lcm_cached = lcm([m.test for m ∈ monkeys])
	for _ ∈ 1:10000
		advance_round!(monkeys, monkey -> inspections[monkey] += 1; divide=false, lcm=lcm_cached)
	end

	sort(values(inspections) |> collect)[end-1:end] |> prod
end

print_solution(part1, part2, input)