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
}
