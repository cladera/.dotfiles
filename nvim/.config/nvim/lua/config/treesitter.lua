local M = {}

function M.setup()
	local tsc_ok, tsc = pcall(require, "nvim-treesitter.config")

	if not tsc_ok then
    print('error');
		return
	end

	tsc.setup()

	vim.api.nvim_create_autocmd("FileType", {
		callback = function(ev)
			local ok = pcall(vim.treesitter.start, ev.buf)
			if not ok then
				return
			end
		end,
	})
end

return M
