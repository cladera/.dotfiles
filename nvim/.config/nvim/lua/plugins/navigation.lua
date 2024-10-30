return {
	{
		"stevearc/oil.nvim",
		config = function()
			require("config.oil").setup()
		end,
		opts = {},
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
}
