local k = require("util.keymapping")

local M = {}

local servers = {
	"lua_ls",
	"cssls",
	"html",
	"ts_ls",
	"eslint",
	"bashls",
	"jsonls",
	"angularls",
	"tailwindcss",
	"terraformls",
	"gopls",
	"kotlin_language_server",
	"terraformls",
}

local function lsp_keymaps(bufnr)
	local opts = { noremap = true, silent = true }
	local keymap = vim.api.nvim_buf_set_keymap
	keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
end

function M.common_capabilities()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	return capabilities
end

M.on_attach = function(client, bufnr)
	lsp_keymaps(bufnr)

	if client.supports_method("textDocument/inlayHint") then
		vim.lsp.inlay_hint.enable(true)
	end
end

M.setup = function()
	k.map("n", "<leader>la", k.cmd("lua vim.lsp.buf.code_action()"), { desc = "Code Action" })
	k.map("n", "<leader>lr", k.cmd("lua vim.lsp.buf.rename()"), { desc = "Rename" })
	k.map(
		"n",
		"<leader>lf",
		k.cmd(
			"lua vim.lsp.buf.format({async = true, filter = function(client) return client.name ~= 'typescript-tools' end})"
		),
		{ desc = "Format" }
	)

	local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
	local icons = require("config.icons")
	if not lspconfig_ok then
		return
	end

	local default_diagnostic_config = {
		signs = {
			active = true,
			values = {
				{ name = "DiagnosticSignError", text = icons.diagnostics.Error },
				{ name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
				{ name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
				{ name = "DiagnosticSignInfo", text = icons.diagnostics.Information },
			},
		},
		virtual_text = false,
		update_in_insert = false,
		underline = true,
		severity_sort = true,
		float = {
			focusable = true,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}

	vim.diagnostic.config(default_diagnostic_config)

	for _, sign in ipairs(vim.tbl_get(vim.diagnostic.config(), "signs", "values") or {}) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
	end

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
	vim.lsp.handlers["textDocument/signatureHelp"] =
		vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

	require("lspconfig.ui.windows").default_options.border = "rounded"

	for _, server in pairs(servers) do
		print(server .. "server detected")

		local opts = {
			on_attach = M.on_attach,
			capabilities = M.common_capabilities(),
		}

		local require_ok, settings = pcall(require, "lspsettings." .. server)
		if not require_ok then
      print(vim.inspect(settings))
			print("no custom settings found")
			settings = {
				lsp_enabled = true,
				lsp_opts = {},
			}
		end

		if settings.lsp_opts == nil then
			print(server .. "'s custom opts are in the root of the config, normalizing is required")
			settings.lsp_opts = vim.tbl_deep_extend("force", {}, settings)
			settings.lsp_enabled = true
		end

		if settings.lsp_enabled then
			print(server .. "server is enabled, applying custom configuration")
			opts = vim.tbl_deep_extend("force", settings.lsp_opts, opts)
			if server == "lua_ls" then
				require("neodev").setup({})
			end
			lspconfig[server].setup(opts)
		else
			print(server .. "server is disabled")
		end
	end
end
return M
