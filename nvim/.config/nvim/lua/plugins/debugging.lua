return {
	{
		"mfussenegger/nvim-dap",
		config = function()
			require("config.dap").setup()
		end,
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
		},
	},
}
