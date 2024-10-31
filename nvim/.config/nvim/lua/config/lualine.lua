local M = {}
local icons = require("config.icons")

local components = {
	mode = {
		function()
			return " " .. icons.ui.Code .. " "
		end,
		padding = { left = 0, right = 0 },
		separator = { left = "◖" },
		color = {},
		cond = nil,
	},
	progress = {
		"progress",
		fmt = function()
			return "%P/%L"
		end,
		color = {},
		separator = { right = "" },
		padding = { left = 1 },
	},
	lsp = {
		function()
			local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
			if #buf_clients == 0 then
				return "LSP Inactive"
			end

			local buf_client_names = {}
			local copilot_active = false

			-- add client
			for _, client in pairs(buf_clients) do
				if client.name ~= "null-ls" and client.name ~= "copilot" then
					table.insert(buf_client_names, client.name)
				end

				if client.name == "copilot" then
					copilot_active = true
				end
			end

			local unique_client_names = table.concat(buf_client_names, ", ")
			local language_servers = string.format("[%s]", unique_client_names)

			if copilot_active then
				language_servers = language_servers .. "%#SLCopilot#" .. " " .. icons.git.Octoface .. "%*"
			end

			return language_servers
		end,
		color = { gui = "bold" },
	},
}

function M.setup()
	local lualine_ok, lualine = pcall(require, "lualine")
	if not lualine_ok then
		return
	end

	lualine.setup({
		options = {
			component_separators = "|",
			section_separators = { right = "◖", left = "" },
			ignore_focus = { "NvimTree" },
		},
		sections = {
			lualine_a = {
				components.mode,
			},
			lualine_b = { "branch" },
			lualine_c = { "filename" },
			lualine_x = {
				"diagnostis",
				components.lsp,
				"filetype",
			},
			lualine_y = {
				"location",
			},
			lualine_z = {
				components.progress,
			},
		},
		extensions = { "quickfix", "man", "fugitive" },
	})
end

return M
