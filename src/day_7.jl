include("utils.jl");
input = get_puzzle_input(7);

struct File
	size::Unsigned
end

struct Directory
	files::Dict{String, Union{File, Directory}}
	parent::Union{Directory, Nothing}
end

Directory(parent) = Directory(Dict{String, Union{File, Directory}}(), parent)
Directory() = Directory(Dict{String, Union{File, Directory}}(), nothing)

function Base.show(io::IO, ::MIME"text/plain", file::File, nest_level = 0)
	print(io, "(file, $(Int(file.size)))")
end

function Base.show(io::IO, m::MIME"text/plain", dir::Directory, nest_level = 0)
	if length(dir.files) == 0
		println(io, "Empty directory")
		return
	end

	for file ∈ dir.files
		name = file.first
		file = file.second

		print(io, "\n")
		print(io, ("    "^nest_level) * "- $name: ")
		Base.show(io, m, file, nest_level + 1)
	end
end

function build_filesystem(input::AbstractString)
	filesystem = Directory()
	current_directory = filesystem

	map(filter(line -> line != "", split(input, "\$"))[2:end]) do block
		command = split(split(block, "\n")[1], " ")[2:end]
		results = split(block, "\n")[2:end]
		
		if command[1] == "cd"
			location = command[2]
			if location == ".."
				current_directory = current_directory.parent
			else
				current_directory = current_directory.files[location]
			end
		elseif command[1] == "ls"
			for result ∈ filter(r -> r != "", results)
				if startswith(result, "dir")
					current_directory.files[split(result, " ")[2]] = Directory(current_directory)
				else
					
					current_directory.files[split(result, " ")[2]] = File(parse(UInt, split(result, " ")[1]))
				end
			end
		end
	end

	filesystem
end

function size(dir::Directory, callback::Any = _ -> nothing)
	result = reduce(+, size.(values(dir.files), callback); init=0)
	callback(result)
	return result
end

size(file::File, ::Any) = file.size

function part1(input)
	filesystem = build_filesystem(input)
	sum = 0
	size(filesystem, result -> if result <= 100_000
		println(result)
		sum += result 
	end)
	sum |> Int
end

function part2(input)
	filesystem = build_filesystem(input)
	free_space = 70_000_000 - size(filesystem) |> Int
	needed_space = 30_000_000 - free_space

	directories::Vector{Directory} = Vector()
	function addDirectories(directory::Directory)
		for dir ∈ values(directory.files)
			if typeof(dir) == Directory
				push!(directories, dir)
				addDirectories(dir)
			end
		end
	end

	addDirectories(filesystem)
	
	sort!(directories, lt=(a, b) -> size(a) < size(b))

	index = findfirst(dir -> size(dir) >= needed_space, directories)
	return directories[index] |> size |> Int
end