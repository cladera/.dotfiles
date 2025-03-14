local json = require("../../util/json")

local M = {}

local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/")

local function is_nx_repo()
	return vim.fn.findfile("nx.json", ".;"):len() > 0
end

local function is_repo(repo)
	local pckg = json.parse_file(vim.fn.getcwd() .. "/package.json")

	return pckg ~= nil and pckg.name == repo
end

local function get_test_at_cursor()
	local grep = nil
	local node = vim.treesitter.get_node()
	local maxAppends = 4

	while node do
		if node:type() == "call_expression" then
			local fn = vim.treesitter.get_node_text(node:child(0), 0)
			if fn == "it" or fn == "describe" then
				local arguments = node:child(1)
				local spec = vim.treesitter.get_node_text(arguments:child(1):child(1), 0)
				if grep == nil then
					grep = spec
				else
					grep = spec .. " " .. grep
				end
				maxAppends = maxAppends - 1
				if maxAppends == 0 then
					break
				end
			end
		end
		node = node:parent()
	end
	if grep == nil then
		return ""
	end

	return string.gsub(grep, "([()$])", "\\%1")
end

local function resolve_nx_test_runner()
	if vim.fn.findfile("vite.config.ts", ".;"):len() > 0 then
		return "vite"
	end

	if vim.fn.findfile("jest.config.ts", ".;"):len() > 0 then
		return "jest"
	end

	return nil
end

local function resolve_nx_test_program()
	return function()
		local runner = resolve_nx_test_runner()

		if runner == "vite" then
			return vim.fn.getcwd() .. "/node_modules/.bin/vitest"
		end

		if runner == "jest" then
			return vim.fn.getcwd() .. "/node_modules/.bin/jest"
		end
	end
end

local function resolve_nx_test_config(runner)
	return vim.fn.findfile(runner .. ".config.ts", ".;")
end

local function resolve_nx_test_args(all)
	return function()
		local runner = resolve_nx_test_runner()
		local config = resolve_nx_test_config(runner)
		local args = { "${fileBasenameNoExtension}", "--config", config }

		if runner == "jest" then
			table.insert(args, "--runInBand")
		end

		if runner == "vite" then
			table.insert(args, "--run")
		end

		if all == false then
			local test = get_test_at_cursor()

			if test ~= nil then
				table.insert(args, "-t")
				table.insert(args, test)
			end
		end
		return args
	end
end

local function ask_port()
	return vim.fn.input("Port: ")
end

function M.setup()
	local dap_ok, dap = pcall(require, "dap")
	if not dap_ok then
		return
	end

	local debugger_path = mason_path .. "packages/js-debug-adapter/"
	dap.adapters["pwa-node"] = {
		type = "server",
		host = "localhost",
		port = "${port}",
		executable = {
			command = "node",
			args = { debugger_path .. "js-debug/src/dapDebugServer.js", "${port}" },
		},
	}

	for _, language in ipairs({ "typescript", "javascript", "typescriptreact" }) do
		local configs = {}

		if is_nx_repo() then
			table.insert(configs, {
				type = "pwa-node",
				request = "launch",
				name = "NX: test",
				runtimeExecutable = resolve_nx_test_program(),
				runtimeArgs = resolve_nx_test_args(false),
				rootPath = "${workspaceFolder}",
				cwd = "${workspaceFolder}",
				console = "integratedTerminal",
				internalConsoleOptions = "neverOpen",
			})

			table.insert(configs, {
				type = "pwa-node",
				request = "launch",
				name = "NX: test all",
				runtimeExecutable = resolve_nx_test_program(),
				runtimeArgs = resolve_nx_test_args(true),
				rootPath = "${workspaceFolder}",
				cwd = "${workspaceFolder}",
				console = "integratedTerminal",
				internalConsoleOptions = "neverOpen",
			})

			table.insert(configs, {
				type = "pwa-node",
				request = "attach",
				name = "Node.js Attach (9229)",
				autoAttachChildProcesses = true,
				port = 9229,
				cwd = "${workspaceFolder}",
			})
		end

		require("dap").configurations[language] = {
			{
				type = "pwa-node",
				request = "attach",
				name = "Node.js Attach",
				autoAttachChildProcesses = true,
				port = ask_port,
				cwd = "${workspaceFolder}",
			},
		}
	end
end

return M
