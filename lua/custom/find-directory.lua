local function is_directory(path)
	local stat = vim.loop.fs_stat(path)
	return stat and stat.type == "directory"
end

local function find_tests_directory(filename)
	local current_directory = vim.fn.fnamemodify(filename, ":p:h") -- Get the directory of the given filename

	while current_directory ~= vim.loop.cwd() do             -- Stop when reaching the root directory
		local tests_directory = current_directory .. '/custom'
		if is_directory(tests_directory) then
			return tests_directory
		end

		-- Move up one directory
		current_directory = vim.fn.fnamemodify(current_directory, ':h')
	end

	return vim.loop.cwd() -- No "tests" directory found
end


print(find_tests_directory(vim.fn.expand('%')))
