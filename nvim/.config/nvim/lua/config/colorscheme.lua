local catppuccin_ok, catppuccin = pcall(require, "catppuccin")

if catppuccin_ok then
	catppuccin.setup({
		flavour = "macchiato",
		custom_highlights = function(colors)
			return {
				CursorColumn = { bg = colors.surface0 },
				CursorLine = { bg = colors.surface0 },
				CursorLineNr = { fg = colors.text, bg = colors.surface1 },
				LineNr = { fg = colors.teal },
				LineNrAbove = { fg = colors.peach },
				NvimTreeWinSeparator = { bg = "none" },
			}
		end,
	})

	vim.cmd.colorscheme("catppuccin")
end
