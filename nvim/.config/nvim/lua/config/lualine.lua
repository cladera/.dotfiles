local M = {}
local icons = require("config.icons")

local components = {
	mode = {
		function()
			return " " .. icons.ui.Code .. " "
		end,
		padding = { left = 0, right = 0 },
		separator = { left = "" },
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
				return icons.kind.File
			end

			local buf_client_names = {}
      local seen = {}
			local copilot_active = false

			-- add client
			for _, client in pairs(buf_clients) do
        local name_to_add = nil

				if icons.lsp[client.name] then
          name_to_add = icons.lsp[client.name]
				elseif client.name ~= "null-ls" and client.name ~= "copilot" then
          name_to_add = client.name
				end

        -- Only add if not seen before
        if name_to_add and not seen[name_to_add] then
          table.insert(buf_client_names, name_to_add)
          seen[name_to_add] = true
        end

				if client.name == "copilot" then
					copilot_active = true
				end
			end

			local unique_client_names = table.concat(buf_client_names, " ")
			local language_servers = string.format("%%#SLLanguageServer# %s %%*", unique_client_names)

			if copilot_active then
				language_servers = language_servers .. "%#SLCopilot#" .. " " .. icons.misc.Copilot .. "%*"
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
			section_separators = { right = "", left = "" },
			ignore_focus = { "NvimTree" },
		},
		sections = {
			lualine_a = {
				components.mode,
			},
			lualine_b = { "branch" },
			lualine_c = { 
        { "filename", path = 1, icon = icons.kind.Folder },
        {
          function()
            if vim.bo.modified then
              return icons.ui.CircleSmall
            end
            return ""
          end,
          color = {fg = "#ff6b6b"}
        }
      },
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
