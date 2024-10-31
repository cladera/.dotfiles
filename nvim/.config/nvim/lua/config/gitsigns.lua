local M = {}
local k = require("util.keymapping")

M.setup = function()
	local gitsings_ok, gitsigns = pcall(require, "gitsigns")
	if not gitsings_ok then
		return
	end

	local icons = require("config.icons")

	k.map(
		"n",
		"<leader>gj",
		k.cmd("lua require 'gitsigns'.next_hunk({navigation_message = false})"),
		{ desc = "Next Hunk" }
	)
	k.map(
		"n",
		"<leader>gk",
		k.cmd("lua require 'gitsigns'.prev_hunk({navigation_message = false})"),
		{ desc = "Prev Hunk" }
	)
	k.map("n", "<leader>gp", k.cmd("lua require 'gitsigns'.preview_hunk()"), { desc = "Preview Hunk" })
	k.map("n", "<leader>gr", k.cmd("lua require 'gitsigns'.reset_hunk()"), { desc = "Reset Hunk" })
	k.map("n", "<leader>gl", k.cmd("lua require 'gitsigns'.blame_line()"), { desc = "Blame" })
	k.map("n", "<leader>gR", k.cmd("lua require 'gitsigns'.reset_buffer()"), { desc = "Reset Buffer" })
	k.map("n", "<leader>gs", k.cmd("lua require 'gitsigns'.stage_hunk()"), { desc = "Stage Hunk" })
	k.map("n", "<leader>gu", k.cmd("lua require 'gitsigns'.undo_stage_hunk()"), { desc = "Undo Stage Hunk" })
	k.map("n", "<leader>gd", k.cmd("Gitsigns diffthis HEAD"), { desc = "Git Diff" })

	gitsigns.setup({
		signs = {
			add = {
				text = icons.ui.BoldLineMiddle,
			},
			change = {
				text = icons.ui.BoldLineDashedMiddle,
			},
			delete = {
				text = icons.ui.TriangleShortArrowRight,
			},
			topdelete = {
				text = icons.ui.TriangleShortArrowRight,
			},
			changedelete = {
				text = icons.ui.BoldLineMiddle,
			},
		},
		watch_gitdir = {
			interval = 1000,
			follow_files = true,
		},
		attach_to_untracked = true,
		current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
		update_debounce = 200,
		max_file_length = 40000,
		preview_config = {
			border = "rounded",
			style = "minimal",
			relative = "cursor",
			row = 0,
			col = 1,
		},
	})
end

return M
