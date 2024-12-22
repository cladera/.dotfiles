local util = require("lspconfig.util")

local function maybe_angular_project()
	return util.root_pattern("project.json", "angular.json")(vim.fn.getcwd()) ~= nil
end

return {
	lsp_enabled = maybe_angular_project(),
	lsp_opts = {
		root_dir = util.root_pattern("project.json", "angular.json"),
	},
}
