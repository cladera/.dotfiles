return {
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    cmd = {
      "TSInstall",
      "TSUninstall",
      "TSUpdate",
      "TSUpdateSync",
      "TSInstallInfo",
      "TSInstallSync",
      "TSInstallFromGrammar",
    },
    event = "User FileOpened",
  },
-- LSP
  {
	  "neovim/nvim-lspconfig",
	  event = { "BufReadPre", "BufNewFile" },
	  dependencies = {
	    {
	      "folke/neodev.nvim",
	    },
	  },
	  config = function()
		  require("config.lsp").setup()
	  end
  },
-- Mason
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
    	{
		"williamboman/mason.nvim",
	},
    },
    config = function()
	    require('config.mason').setup()
    end,
  },
}
