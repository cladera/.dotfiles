return {
	-- Files Explorer
	{
		"stevearc/oil.nvim",
		config = function()
			require("config.oil").setup()
		end,
		opts = {},
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	-- Find
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { { "nvim-telescope/telescope-fzf-native.nvim", build = "make", lazy = true } },
		config = function()
			require("config.telescope").setup()
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
	},
}
