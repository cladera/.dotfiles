return {
	{ "tpope/vim-fugitive" },
	{ "tpope/vim-surround" },
	{
		"lewis6991/gitsigns.nvim",
		event = "BufEnter",
		cmd = "Gitsigns",
		config = function()
			require("config.gitsigns").setup()
		end,
	},
	{
		"kdheepak/lazygit.nvim",
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
    config = function ()
      require("config.lazygit").setup()
    end
	},
}
