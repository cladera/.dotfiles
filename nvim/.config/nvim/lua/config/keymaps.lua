local k = require("util.keymapping")
local opts = { noremap = true, silent = true }

-- Navigation
k.map("n", "<leader>e", k.cmd("Oil"), opts)

-- Buffers
k.map("i", "jk", "<Esc>", opts)
k.map("i", "jj", "<Esc>", opts)
k.map("i", "kk", "<Esc>", opts)
k.map("n", "<leader>w", k.cmd("w"), opts)

-- Windows
k.map("n", "<C-l>", "<C-w>l", opts)
k.map("n", "<C-h>", "<C-w>h", opts)
k.map("n", "<C-k>", "<C-w>k", opts)
k.map("n", "<C-j>", "<C-w>j", opts)

-- Tabs
k.map("n", "<C-M-l>", k.cmd("+tabnext"), {desc = "Next Tab"})
k.map("n", "<C-M-h>", k.cmd("-tabnext"), {desc = "Previous Tab"})
k.map("n", "<C-M-q>", k.cmd("tabc"), {desc = "Close Tab"})

-- Center scroll when searching
k.map("n", "n", "nzz", opts)
k.map("n", "N", "Nzz", opts)
k.map("n", "*", "*zz", opts)
k.map("n", "#", "#zz", opts)
k.map("n", "g*", "g*zz", opts)
k.map("n", "g#", "g#zz", opts)


-- Stay in indent mode
k.map("v", "<", "<gv", opts)
k.map("v", ">", ">gv", opts)

