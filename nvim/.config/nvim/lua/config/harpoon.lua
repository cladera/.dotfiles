local M = {}
local k = require("util.keymapping")

function M.setup()
	local harpoon_ok, harpoon = pcall(require, "harpoon")

	if not harpoon_ok then
		return
	end

	harpoon.setup({
		menu = {
			width = vim.api.nvim_win_get_width(0) - 12,
		},
	})

	local telescope_ok, telescope = pcall(require, "telescope")
	local find_cmd = nil

	if telescope_ok then
		telescope.load_extension("harpoon")
		find_cmd = ":Telescope harpoon marks<cr>"
	else
		find_cmd = ':lua require("harpoon.ui").toggle_quick_menu()<cr>'
	end

	k.map("n", "<s-m>", k.cmd("lua require('config.harpoon').mark_file()"), { desc = "Hapoon File" })
	k.map("n", "<TAB>", k.cmd("lua require('harpoon.ui').toggle_quick_menu()"), { desc = "Show Harpoon Menu" })
	k.map("n", "<leader>aa", find_cmd, { desc = "Find Files in Harpoon" })
	k.map("n", "<leader>ac", k.cmd("lua require('harpoon.mark').clear_all()"), { desc = "Clear Files in Harpoon" })
	k.map("n", "<leader>an", k.cmd("lua require('harpoon.ui').nav_next()"), { desc = "Next Harpoon File" })
	k.map("n", "<leader>ap", k.cmd("lua require('harpoon.ui').nav_prev()"), { desc = "Previous Harpoon File" })

	for i = 1, 12, 1 do
		k.map(
			"n",
			"<F" .. (i + 12) .. ">",
			k.cmd("lua require('harpoon.ui').nav_file(" .. i .. ")"),
			{ desc = "Go To Harpoon File #" .. i }
		)
	end
end

function M.mark_file()
	require("harpoon.mark").add_file()
	vim.notify("󱡅  marked file")
end

return M
