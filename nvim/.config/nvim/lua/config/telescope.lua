local k = require("util.keymapping")

local M = {}

function M.setup()
	local telescope_ok, telescope = pcall(require, "telescope")
	if not telescope_ok then
		return
	end

	k.map("n", "<leader>bb", "<cmd>Telescope buffers previewer=false<cr>", { desc = "Find" })
	k.map("n", "<leader>fb", "<cmd>Telescope git_branches<cr>", { desc = "Checkout branch" })
	k.map("n", "<leader>fc", "<cmd>Telescope colorscheme<cr>", { desc = "Colorscheme" })
	k.map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
	-- k.map("n", "<leader>fp", "<cmd>lua require('telescope').extensions.projects.projects()<cr>", { desc = "Projects" })
	k.map("n", "<leader>ft", "<cmd>Telescope live_grep<cr>", { desc = "Find Text" })
	k.map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help" })
	k.map("n", "<leader>fl", "<cmd>Telescope resume<cr>", { desc = "Last Search" })
	k.map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent File" })

	local icons = require("config.icons")
	local actions = require("telescope.actions")

	telescope.setup({
		defaults = {
			prompt_prefix = icons.ui.Telescope .. " ",
			selection_caret = icons.ui.Forward .. " ",
			entry_prefix = "   ",
			initial_mode = "insert",
			selection_strategy = "reset",
			path_display = { "smart" },
			color_devicons = true,
			vimgrep_arguments = {
				"rg",
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
				"--smart-case",
				"--hidden",
				"--glob=!.git/",
			},

			mappings = {
				i = {
					["<C-n>"] = actions.cycle_history_next,
					["<C-p>"] = actions.cycle_history_prev,

					["<C-j>"] = actions.move_selection_next,
					["<C-k>"] = actions.move_selection_previous,
				},
				n = {
					["<esc>"] = actions.close,
					["j"] = actions.move_selection_next,
					["k"] = actions.move_selection_previous,
					["q"] = actions.close,
				},
			},
		},
		pickers = {
			live_grep = {
				theme = "dropdown",
			},

			grep_string = {
				theme = "dropdown",
			},

			find_files = {
				theme = "dropdown",
				previewer = false,
			},

			buffers = {
				theme = "dropdown",
				previewer = false,
				initial_mode = "normal",
				mappings = {
					i = {
						["<C-d>"] = actions.delete_buffer,
					},
					n = {
						["dd"] = actions.delete_buffer,
					},
				},
			},

			planets = {
				show_pluto = true,
				show_moon = true,
			},

			colorscheme = {
				enable_preview = true,
			},

			lsp_references = {
				theme = "dropdown",
				initial_mode = "normal",
			},

			lsp_definitions = {
				theme = "dropdown",
				initial_mode = "normal",
			},

			lsp_declarations = {
				theme = "dropdown",
				initial_mode = "normal",
			},

			lsp_implementations = {
				theme = "dropdown",
				initial_mode = "normal",
			},
		},
		extensions = {
			fzf = {
				fuzzy = true, -- false will only do exact matching
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true, -- override the file sorter
				case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			},
			["ui-select"] = {
				winblend = 15,
				layout_config = {
					prompt_position = "top",
					width = 80,
					height = 12,
				},
				border = {},
				previewer = false,
				shorten_path = false,
			},
		},
	})

	telescope.load_extension("ui-select")
end

return M
