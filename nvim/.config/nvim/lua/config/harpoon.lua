local M = {}
local k = require("util.keymapping")

function M.setup()
	local harpoon_ok, harpoon = pcall(require, "harpoon")

	if not harpoon_ok then
		return
	end

	harpoon:setup()

	k.map("n", "<s-m>", function()
		harpoon:list():add()
		vim.notify("🪝 File harpooned")
	end, { desc = "Harpoon file" })

	k.map("n", "<C-e>", function()
		harpoon.ui:toggle_quick_menu(harpoon:list())
	end, { desc = "Show harpooned files" })

	k.map("n", "<leader>ac", function()
		harpoon:list():clear()
	end, { desc = "Release all harpooned files" })

	k.map("n", "<leader>an", function()
		harpoon:list():next()
	end, { desc = "Go to next harpooned file" })
	k.map("n", "<leader>ap", function()
		harpoon:list():prev()
	end, { desc = "Go to previous harpooned file" })

	for i = 1, 12, 1 do
		k.map("n", "<F" .. (i + 12) .. ">", function()
			harpoon:list():select(i)
		end, { desc = "Go To Harpoon File #" .. i })
	end
end

return M
