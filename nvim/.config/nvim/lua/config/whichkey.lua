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
		{ "<leader>a", group = "Tab" },
		{ "<leader>an", "<cmd>$tabnew<cr>", desc = "New Empty Tab" },
		{ "<leader>aN", "<cmd>tabnew %<cr>", desc = "New Tab" },
		{ "<leader>ao", "<cmd>tabonly<cr>", desc = "Only" },
		{ "<leader>ah", "<cmd>-tabmove<cr>", desc = "Move Left" },
		{ "<leader>al", "<cmd>+tabmove<cr>", desc = "Move Right" },
		{ "<leader>T", group = "Treesitter" },
	}

	which_key.setup({
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
		window = {
			border = "rounded",
			position = "bottom",
			padding = { 2, 2, 2, 2 },
		},
		ignore_missing = true,
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
	which_key.add(mappings, opts)
end

return M
