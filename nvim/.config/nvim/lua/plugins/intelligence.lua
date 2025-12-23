return {
	{
	-- Treesitter
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
		event = "BufRead",
		config = function()
			require("config.treesitter").setup()
		end,
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
		end,
	},
	{ "mfussenegger/nvim-jdtls" },
	-- Mason
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			{
				"williamboman/mason.nvim",
			},
		},
		config = function()
			require("config.mason").setup()
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
		-- config = true,
		config = function()
			require("config.cmp").setup()
		end,
	},

	-- Formatting
	-- {
	-- 	"nvimtools/none-ls.nvim",
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 	},
	-- 	config = function()
	-- 		require("config.null-ls").setup()
	-- 	end,
	-- },

	-- AI
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({});
    end
  },
  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end
  },
	-- {
	-- 	"github/copilot.vim",
	-- 	config = function()
	-- 		require("config.copilot").setup()
	-- 	end,
	-- },
	-- {
	-- 	"codota/tabnine-nvim",
	-- 	build = "./dl_binaries.sh",
	-- 	config = function()
	-- 		require("config.tabnine").setup()
	-- 	end,
	-- },
	{
		"olimorris/codecompanion.nvim",
		config = function()
			require("config.codecompanion").setup()
		end,
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-treesitter/nvim-treesitter" },
			{ "hrsh7th/nvim-cmp" },
		},
	},
}
