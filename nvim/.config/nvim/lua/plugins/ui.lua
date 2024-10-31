return {
	{
		"folke/which-key.nvim",
		config = function()
			require("config.whichkey").setup()
		end,
	},
	-- Winbar
	{
		"LunarVim/breadcrumbs.nvim",
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("nvim-navic").setup({
				lsp = {
					auto_attach = true,
				},
			})
			require("breadcrumbs").setup()
		end,
	},
	-- Homescreen
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
    config = function ()
      require("config.alpha").setup();
    end
	},
}
