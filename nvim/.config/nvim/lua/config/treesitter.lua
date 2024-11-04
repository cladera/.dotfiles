local M = {}

function M.setup()
	local tsc_ok, tsc = pcall(require, "nvim-treesitter.configs")

	if not tsc_ok then
		return
	end

	tsc.setup({
		ensure_installed = {
			"comment",
			"lua",
			"markdown",
			"markdown_inline",
			"typescript",
		},
		highlight = { enable = true },
		indent = { enable = true },
	})
end

return M
