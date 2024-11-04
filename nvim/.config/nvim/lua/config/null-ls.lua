local M = {}

function M.setup()
	local null_ls_ok, null_ls = pcall(require, "null-ls")
	if not null_ls_ok then
		return
	end

	local formatting = null_ls.builtins.formatting

	null_ls.setup({
		debug = false,
		sources = {
			formatting.stylua,
			formatting.prettier,
			null_ls.builtins.completion.spell,
		},
	})
end

return M
