local json = require("util.json")
local code = require("util.code")

local M = {}

function M.is_npm_repo()
	return vim.fn.findfile("package.json", ".;"):len() > 0
end

function M.is_nx_repo()
	return vim.fn.findfile("nx.json", ".;"):len() > 0
end

function M.is_repo(name)
	if not M.is_npm_repo() then
		return false
	end

	local pckg = json.parse_file(vim.fn.getcwd() .. "/package.json")

	return pckg ~= nil and pckg.name == name
end

function M.is_dependency_installed(dependency)
	if not M.is_npm_repo() then
		return false
	end
	local pckg = json.parse_file(vim.fn.getcwd() .. "/package.json")
	return pckg ~= nil and pckg.devDependencies ~= nil and pckg.devDependencies[dependency] ~= nil
end

function M.is_mocha_installed()
	return M.is_dependency_installed("mocha")
end

function M.is_jest_installed()
	return M.is_dependency_installed("jest")
end

function M.resolve_nx_test_runner()
	if vim.fn.findfile("vite.config.ts", ".;"):len() > 0 then
		return "vite"
	end
	if vim.fn.findfile("jest.config.ts", ".;"):len() > 0 then
		return "jest"
	end
	return nil
end

function M.resolve_nx_test_program()
	local runner = M.resolve_nx_test_runner()

	if runner == "vite" then
		return vim.fn.getcwd() .. "/node_modules/.bin/vitest"
	end

	if runner == "jest" then
		return vim.fn.getcwd() .. "/node_modules/.bin/jest"
	end
end

function M.resolve_nx_test_config(runner)
	return vim.fn.findfile(runner .. ".config.ts", ".;")
end

function M.resolve_jest_config(ext)
	ext = ext or "js"
	return function()
		return vim.fn.findfile("jest.config." .. ext, ".;")
	end
end

function M.resolve_nx_test_args(all)
	return function()
		local runner = M.resolve_nx_test_runner()
		local config = M.resolve_nx_test_config(runner)
		local args = { "${fileBasenameNoExtension}", "--config", config }

		if runner == "jest" then
			table.insert(args, "--runInBand")
		end

		if runner == "vite" then
			table.insert(args, "--run")
		end

		if all == false then
			local test = code.get_test_at_cursor()

			if test ~= nil then
				table.insert(args, "-t")
				table.insert(args, test)
			end
		end
    return args
	end
end

return M
