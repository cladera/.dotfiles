local M = {}
local k = require("util.keymapping")

function M.setup()
	k.map("i", "<C-m>", 'copilot#Accept("\\<CR>")', {
		expr = true,
		replace_keycodes = false,
	})
	k.map("i", "<C-]>", 'copilot#Next()', {
		expr = true,
		replace_keycodes = false,
	})
	k.map("i", "<C-[>", 'copilot#Previous()', {
		expr = true,
		replace_keycodes = false,
	})

  vim.g.copilot_no_tab_map = true
end

return M
