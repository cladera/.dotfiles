local M = {}

function M.parse_file(path)
	--Read the file contents into a string
	local read_file_ok, file_lines = pcall(vim.fn.readfile, path)
	if not read_file_ok then
		return nil
	end

	local file_content = table.concat(file_lines, "\n")

	local success, parsed_json = pcall(vim.fn.json_decode, file_content)
	if not success then
		return nil
	end
	return parsed_json
end

return M
