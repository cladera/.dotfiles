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

function M.resolve_mocha_config()
	return vim.fn.findfile(".mocharc.js", ".;")
end

function M.resolve_mocha_root_path()
	-- get the path of the nearest mocha config file
	local mocha_config_path = M.resolve_mocha_config()

	-- if no mocha config file is found, return the current working directory
	if mocha_config_path == "" then
		return vim.fn.getcwd()
	end

	-- otherwise, return the base path of file found relative to the current working directory
	return vim.fn.fnamemodify(mocha_config_path, ":h")
end

function M.resolve_mocha_program()
	-- if mocha directory exists in the root config path
	if vim.fn.isdirectory(M.resolve_mocha_root_path() .. "/node_modules/mocha") == 1 then
		return M.resolve_mocha_root_path() .. "/node_modules/.bin/mocha"
	end

	return vim.fn.getcwd() .. "/node_modules/.bin/mocha"
end

function M.resolve_mocha_args(program, options)
	return function()
		-- if program is a function call it to get the program path
		if type(program) == "function" then
			program = program()
		end

		-- if config is a function call it to get the config path
		local config = options.config
		if type(config) == "function" then
			config = config()
		end

		local args = { program, "--timeout", "99999999" }

		if config ~= nil and config ~= "" then
			table.insert(args, "--config")
			table.insert(args, config)
		end

		if options.require ~= nil then
			local requrie = options.require
			if type(require) == "function" then
				require = requrie()
			end

			table.insert(args, "--require")
			table.insert(args, require)
		end

		if options.recursive == true then
			table.insert(args, "--recursive")
		end

		if options.all == false then
			local test = code.get_test_at_cursor()

			if test ~= nil then
				table.insert(args, "--grep")
				if options.use_quotes then
					table.insert(args, '"' .. test('"'))
				else
					table.insert(args, test)
				end
			end
		else
			table.insert(args, "--grep")
			table.insert(args, ".*")
		end

		if options.extras ~= nil then
			for _, extra in iparis(options.extras) do
				table.insert(args, extra)
			end
		end

		table.insert(args, "${relativeFileDirname}/${fileBasename}")

		return args
	end
end

function M.resolve_jest_args(program, options)
	return function()
		-- if program is a function call it to get the program path
		if type(program) == "function" then
			program = program()
		end

		-- if config is a function call it to get the config path
		local config = options.config
		if type(config) == "function" then
			config = config()
		end

		local args = { program, "--timeout", "99999999" }

		if config ~= nil and config ~= "" then
			table.insert(args, "--config")
			table.insert(args, config)
		end

		if options.all == false then
			local test = code.get_test_at_cursor()

			if test ~= nil then
				table.insert(args, "--testNamePattern")
				table.insert(args, test)
			end
		else
			table.insert(args, "--grep")
			table.insert(args, ".*")
		end

		if options.extras ~= nil then
			for _, extra in iparis(options.extras) do
				table.insert(args, extra)
			end
		end

		table.insert(args, "${relativeFileDirname}/${fileBasename}")

		return args
	end
end

return M
