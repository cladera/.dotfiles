local icons = require("config.icons")
local k = require("util.keymapping")
local repo = require("util.repo")
local code = require("util.code")

local function setup_ui()
	local dapui_ok, dapui = pcall(require, "dapui")
	if not dapui_ok then
		return
	end

	dapui.setup({
		icons = {
			expanded = "",
			collapsed = "",
			circular = "",
			current_frame = "",
		},
		mappings = {
			-- Use a table to apply multiple mappings
			expand = { "<CR>", "<2-LeftMouse>" },
			open = "o",
			remove = "d",
			edit = "e",
			repl = "r",
			toggle = "t",
		},
		-- Use this to override mappings for specific elements
		element_mappings = {},
		expand_lines = true,
		layouts = {
			{
				elements = {
					{ id = "scopes", size = 0.33 },
					{ id = "breakpoints", size = 0.17 },
					{ id = "stacks", size = 0.25 },
					{ id = "watches", size = 0.25 },
				},
				size = 0.33,
				position = "right",
			},
			{
				elements = {
					{ id = "console", size = 0.55 },
					{ id = "repl", size = 0.45 },
				},
				size = 0.27,
				position = "bottom",
			},
		},
		controls = {
			enabled = true,
			-- Display controls in this element
			element = "repl",
			icons = {
				pause = icons.debug.Pause,
				play = icons.debug.Play,
				step_into = icons.debug.StepInto,
				step_over = icons.debug.StepOver,
				step_out = icons.debug.StepOut,
				step_back = icons.debug.StepBack,
				run_last = icons.debug.RunLast,
				terminate = icons.debug.Terminate,
			},
		},
		floating = {
			max_height = 0.9,
			max_width = 0.5, -- Floats will be treated as percentage of your screen.
			border = "rounded",
			mappings = {
				close = { "q", "<Esc>" },
			},
		},
		force_buffers = true,
		windows = { indent = 1 },
		render = {
			indent = 1,
			max_type_length = nil, -- Can be integer or nil.
			max_value_lines = 100, -- Can be integer or nil.
		},
	})

	-- Open UI when starting a session
	require("dap").listeners.after.event_initialized["dapui_config"] = function()
		dapui.open()
	end
end

local function load_adapters(adapters)
  local mason_path = vim.fn.stdpath("data") .. "/mason/"

  -- js-debug-adapter
  local js_debugger_path = mason_path .. "packages/js-debug-adapter/"
  adapters["pwa-node"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
      command = "node",
      args = { js_debugger_path .. "js-debug/src/dapDebugServer.js", "${port}" },
    },
  }
  adapters["node"] = adapters["pwa-node"]

  -- Chrome
  local chrome_executable_path = mason_path .. "packages/chrome-debug-adapter/out/src/chromeDebug.js"
  adapters["pwa-chrome"] = {
    type = "executable",
    command = "node",
    args = {
      chrome_executable_path
    }
  }
  adapters["chrome"] = adapters["pwa-chrome"]
end

local function load_configurations(configurations)
  local config_paths = {
    vim.fn.expand("~/.local/nvim/dap.lua"), -- Load workstation config first
    vim.fn.getcwd() .. "/.nvim/dap.lua" -- Then project config 
  }
  local utils = {
    repo,
    code
  }

  for _, config_path in ipairs(config_paths) do
    if vim.fn.filereadable(config_path) == 1 then
      local ok, config = pcall(dofile, config_path)
      if ok and type(config) == "table" and type(config.setup) == "function" then
        local success, err = pcall(config.setup, configurations, utils)
        if not success then
          vim.notify("Error loading DAP config from " .. config_path .. ": " .. tostring(err), vim.log.levels.ERROR)
        end
      end
    end
  end
end

local M = {}

function M.setup()
	local dap_ok, dap = pcall(require, "dap")
	if not dap_ok then
		print("Failed to load dap")
		return
	end

	local signs = {
		breakpoint = {
			text = icons.ui.Bug,
			texthl = "DiagnosticSignError",
			linehl = "",
			numhl = "",
		},
		breakpoint_rejected = {
			text = icons.ui.Bug,
			texthl = "DiagnosticSignError",
			linehl = "",
			numhl = "",
		},
		stopped = {
			text = icons.ui.BoldArrowRight,
			texthl = "DiagnosticSignWarn",
			linehl = "Visual",
			numhl = "DiagnosticSignWarn",
		},
	}

	vim.fn.sign_define("DapBreakpoint", signs.breakpoint)
	vim.fn.sign_define("DapBreakpointRejected", signs.breakpoint_rejected)
	vim.fn.sign_define("DapStopped", signs.stopped)

	dap.set_log_level("info")

	k.map("n", "<leader>dt", k.cmd("lua require'dap'.toggle_breakpoint()"), { desc = "Toggle Breakpoint" })
	k.map(
		"n",
		"<leader>dB",
		k.cmd("lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))"),
		{ desc = "Set breakpoint condition" }
	)
	k.map(
		"n",
		"<leader>dL",
		k.cmd("lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))"),
		{ desc = "Set breakpoint log point" }
	)
	k.map("n", "<leader>dg", k.cmd("lua require'dap'.session()"), { desc = "Get Session" })
	k.map("n", "<leader>dl", k.cmd("lua require'dap'.run_last()"), { desc = "Run Last" })
	k.map("n", "<leader>db", k.cmd("lua require'dap'.step_back()"), { desc = "Step Back" })
	k.map("n", "<leader>dc", k.cmd("lua require'dap'.continue()"), { desc = "Continue" })
	k.map("n", "<leader>dC", k.cmd("lua require'dap'.run_to_cursor()"), { desc = "Run To Cursor" })
	k.map("n", "<leader>dd", k.cmd("lua require'dap'.disconnect()"), { desc = "Disconnect" })
	k.map("n", "<leader>di", k.cmd("lua require'dap'.step_into()"), { desc = "Step Into" })
	k.map("n", "<leader>do", k.cmd("lua require'dap'.step_over()"), { desc = "Step Over" })
	k.map("n", "<leader>du", k.cmd("lua require'dap'.step_out()"), { desc = "Step Out" })
	k.map("n", "<leader>dp", k.cmd("lua require'dap'.pause()"), { desc = "Pause" })
	k.map("n", "<leader>dr", k.cmd("lua require'dap'.repl.toggle()"), { desc = "Toggle Repl" })
	k.map("n", "<leader>ds", k.cmd("lua require'dap'.continue()"), { desc = "Start/Continue" })
	k.map("n", "<leader>dq", k.cmd("lua require'dap'.close()"), { desc = "Quit" })
	k.map("n", "<leader>dU", k.cmd("lua require'dapui'.toggle({reset = true})"), { desc = "Toggle UI" })

	setup_ui()

  load_adapters(dap.adapters)

  load_configurations(dap.configurations)
end

return M
