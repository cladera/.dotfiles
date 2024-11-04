local catppuccin_ok, catppuccin = pcall(require, "catppuccin")

if catppuccin_ok then
	catppuccin.setup({
		flavour = "macchiato",
		custom_highlights = function(colors)
			return {
				LineNr = { fg = colors.teal },
				LineNrAbove = { fg = colors.peach },
				CursorLineNr = { fg = colors.text, bg = colors.surface1 },
				CursorLine = { bg = colors.surface1 },
				NvimTreeWinSeparator = { bg = "none" },
			}
		end,
	})

	vim.cmd.colorscheme("catppuccin")
end
