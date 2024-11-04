local M = {}

function M.setup()
	local which_key_ok, which_key = pcall(require, "which-key")
	if not which_key_ok then
		return
	end

	local mappings = {
		{ "<leader>q", "<cmd>confirm q<CR>", desc = "Quit" },
		{ "<leader>h", "<cmd>nohlsearch<CR>", desc = "NOHL" },
		{ "<leader>;", "<cmd>tabnew | terminal<CR>", desc = "Term" },
		{ "<leader>v", "<cmd>vsplit<CR>", desc = "Split" },
		-- b = { name = "Buffers" },
		{ "<leader>d", group = "Debug" },
		{ "<leader>f", group = "Find" },
		{ "<leader>g", group = "Git" },
		{ "<leader>l", group = "LSP" },
		{ "<leader>p", group = "Plugins" },
		-- {"<leader>t", group = "Test" },
		{"<leader>d", group = "Debug" },
		{ "<leader>t", group = "Tab" },
		{ "<leader>tn", "<cmd>$tabnew<cr>", desc = "New Empty Tab" },
		{ "<leader>tN", "<cmd>tabnew %<cr>", desc = "New Tab" },
		{ "<leader>to", "<cmd>tabonly<cr>", desc = "Close Other Tabs" },
		{ "<leader>th", "<cmd>-tabmove<cr>", desc = "Move Left" },
		{ "<leader>tl", "<cmd>+tabmove<cr>", desc = "Move Right" },
	}

	which_key.setup({
		notify = false,
		spec = mappings,
		plugins = {
			marks = true,
			registers = true,
			spelling = {
				enabled = true,
				suggestions = 20,
			},
			presets = {
				operators = false,
				motions = false,
				text_objects = false,
				windows = false,
				nav = false,
				z = false,
				g = false,
			},
		},
		win = {
			border = "rounded",
			padding = { 2, 2, 2, 2 },
			title = true,
		},
		show_help = false,
		show_keys = false,
		disable = {
			buftypes = {},
			filetypes = { "TelescopePrompt" },
		},
	})

	local opts = {
		mode = "n",
		prefix = "<leader>",
	}
end

return M
