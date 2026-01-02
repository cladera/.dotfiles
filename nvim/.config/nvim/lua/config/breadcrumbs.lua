local icons = require("config.icons")

local M = {}

function M.setup()
  local navic_ok, navic = pcall(require, "nvim-navic")
  if not navic_ok then
    return
  end

  local breadcrumbs_ok, breadcrumbs = pcall(require, "breadcrumbs")
  if not breadcrumbs_ok then
    return
  end

  navic.setup({
    icons = icons,
    highlight = true,
    lsp = {
      auto_attach = true,
      preference = {
        "templ",
        "ts_ls"
      }
    },
    clieck = true,
    separator = " " .. icons.ui.ChevronRight .. " ",
    depth_limit = 5,
    depth_limit_indicator = "..",
  })

  breadcrumbs.setup()
end

return M
