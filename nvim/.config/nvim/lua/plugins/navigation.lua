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
	{
		"ThePrimeagen/harpoon",
		event = "VeryLazy",
    branch = "harpoon2",
	 	dependencies = {
			{ "nvim-lua/plenary.nvim" },
		},
    config = function()
      require("config.harpoon").setup()
    end
	},
}
