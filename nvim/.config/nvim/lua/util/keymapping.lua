local M = {}

function M.map(mode, lhs, rhs, opts)
  local options = { noremap=true, silent=true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function M.cmd(c)
	return '<CMD>'..c..'<CR>'
end

return M;
