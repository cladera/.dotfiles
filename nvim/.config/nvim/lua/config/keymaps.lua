local k = require("util.keymapping")

-- Navigation
k.map('n', '<leader>e', k.cmd('Oil'))

-- Buffers
k.map('i', 'jk', '<Esc>')
k.map('i', 'jj', '<Esc>')
k.map('i', 'kk', '<Esc>')
k.map('n', '<leader>w', '<CMD>w<CR>')

-- Windows
k.map('n', '<C-l>', '<C-w>l')
k.map('n', '<C-h>', '<C-w>h')
k.map('n', '<C-k>', '<C-w>k')
k.map('n', '<C-j>', '<C-w>j')
