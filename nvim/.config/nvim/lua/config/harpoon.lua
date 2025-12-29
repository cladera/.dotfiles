local k = require("util.keymapping")

local M = {}

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
	-- Workaround for S-F3
	k.map("n", "<S-F3>", function()
		harpoon:list():select(3)
	end, { desc = "Go to Harpoon File #3" })

	local telescope_ok, telescope = pcall(require, "telescope")

	if not telescope_ok then
		return
	end

	local conf = require("telescope.config").values
	local function toggle_telescope(harpoon_files)
		local file_paths = {}
		for _, item in ipairs(harpoon_files.items) do
			table.insert(file_paths, item.value)
		end

		require("telescope.pickers")
			.new({}, {
				prompt_title = "Harpooned Files",
				finder = require("telescope.finders").new_table({
					results = file_paths,
				}),
				previewer = conf.file_previewer({}),
				sorter = conf.generic_sorter({}),
			})
			:find()
	end

	k.map("n", "<leader>af", function()
		toggle_telescope(harpoon:list())
	end, { desc = "Open harpoon window" })
end

return M
