local k = require("util.keymapping")
local icons = require('config.icons')

local M = {}

M.setup = function()
  vim.lsp.enable(
    {
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
      "buf_ls",
    }
  )

  -- Disable inlay hints
  vim.lsp.inlay_hint.enable(false)

  -- Create default capabilities without cmp
  local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()

  vim.lsp.config("*", {
    capabilities = lsp_capabilities,
  })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
      k.map("n", "gD", k.cmd("lua vim.lsp.buf.declaration()"), { desc = "Go to Declaration", buffer = ev.buf })
      k.map("n", "gd", k.cmd("lua vim.lsp.buf.definition()"), { desc = "Go to Definition", buffer = ev.buf })
      k.map("n", "K", k.cmd("lua vim.lsp.buf.hover()"), { desc = "Hover Documentation", buffer = ev.buf })
      k.map("n", "gi", k.cmd("lua vim.lsp.buf.implementation()"), { desc = "Go to Implementation", buffer = ev.buf })
      k.map("n", "K", k.cmd("lua vim.lsp.buf.signature_help()"), { desc = "Signature Help", buffer = ev.buf })
      k.map("n", "gr", k.cmd("lua vim.lsp.buf.references()"), { desc = "Find References", buffer = ev.buf })
      k.map("n", "gl", k.cmd("lua vim.diagnostic.open_float()"), { desc = "Line Diagnostics", buffer = ev.buf })
      k.map("n", "<leader>la", k.cmd("lua vim.lsp.buf.code_action()"), { desc = "Code Action", buffer = ev.buf })
      k.map("n", "<leader>lr", k.cmd("lua vim.lsp.buf.rename()"), { desc = "Rename", buffer = ev.buf })
      k.map("n", "<leader>lj", k.cmd("lua vim.diagnostic.goto_next()"), { desc = "Next Diagnostic", buffer = ev.buf })
      k.map("n", "<leader>lk", k.cmd("lua vim.diagnostic.goto_prev()"), { desc = "Prev Diagnostic", buffer = ev.buf })

      local telescope_ok, telescope = pcall(require, "telescope")
      if telescope_ok then
        k.map("n", "<leader>ls", k.cmd("Telescope lsp_document_symbols"), { desc = "Document Symbols", buffer = ev.buf })
        k.map("n", "<leader>lS", k.cmd("Telescope lsp_dynamic_workspace_symbols"),
          { desc = "Workspace Symbols", buffer = ev.buf })
        k.map("n", "<leader>ld", k.cmd("Telescope diagnostics layout_strategy=bottom_pane previewer=false"),
          { desc = "LSP Diagnostics", buffer = ev.buf })
      end
    end,
  })

  -- Configure diagnostic display with custom signs
  vim.diagnostic.config({
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = true, -- Show source in diagnostic popup window
      header = "",
      prefix = "",
    },
    virtual_text = false,
    virtual_lines = false,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error.." ",
        [vim.diagnostic.severity.WARN] = icons.diagnostics.Warning.." ",
        [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint.." ",
        [vim.diagnostic.severity.INFO] = icons.diagnostics.Information.." ",
      },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
  })
end
return M
