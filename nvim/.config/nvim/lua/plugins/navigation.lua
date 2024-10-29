return {
	{
		"stevearc/oil.nvim",
		config = function()
			require("config.oil").setup()
		end,
		opts = {},
		-- Optional dependencies
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
}
