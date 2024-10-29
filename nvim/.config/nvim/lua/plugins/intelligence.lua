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
-- Cmp
	{
		  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    {
      "hrsh7th/cmp-nvim-lsp",
      event = "InsertEnter",
    },
    {
      "hrsh7th/cmp-emoji",
      event = "InsertEnter",
    },
    {
      "hrsh7th/cmp-buffer",
      event = "InsertEnter",
    },
    {
      "hrsh7th/cmp-path",
      event = "InsertEnter",
    },
    {
      "hrsh7th/cmp-cmdline",
      event = "InsertEnter",
    },
    {
      "saadparwaiz1/cmp_luasnip",
      event = "InsertEnter",
    },
    {
      "L3MON4D3/LuaSnip",
      event = "InsertEnter",
      dependencies = {
        "rafamadriz/friendly-snippets",
      },
    },
    {
      "hrsh7th/cmp-nvim-lua",
    },
  },
  config = function()
	  require("config.cmp").setup()
  end,

	}
}
