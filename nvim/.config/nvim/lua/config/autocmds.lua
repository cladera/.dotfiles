-- Transparent background
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		local hl_groups = {
			"Normal",
			"SignColumn",
			"NormalNC",
			"TelescopeBorder",
			"NvimTreeNormal",
			"NvimTreeNormalNC",
			"EndOfBuffer",
			"MsgArea",
		}
		for _, name in ipairs(hl_groups) do
			vim.cmd(string.format("highlight %s ctermbg=none guibg=none", name))
		end
	end,
})

vim.opt.fillchars = "eob: "

-- Highlight on yank
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  callback = function()
    vim.highlight.on_yank { higroup = "Visual", timeout = 40 }
  end,
})

