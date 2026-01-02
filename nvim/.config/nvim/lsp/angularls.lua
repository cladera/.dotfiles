local util = require("lspconfig.util")

return {
  root_dir = function(bufn, on_dir)
    if util.root_pattern("angular.json", "project.json") ~= nil then
      on_dir(vim.fn.getcwd())
    end
  end
}
