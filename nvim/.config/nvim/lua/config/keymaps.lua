local function map(mode, lhs, rhs, opts)
  local options = { noremap=true, silent=true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Navigation
map('n', '<leader>e', '<CMD>Oil<CR>')

-- Buffers
map('i', 'jk', '<Esc>')
map('n', '<leader>w', '<CMD>w<CR>') 

