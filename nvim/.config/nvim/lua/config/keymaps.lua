local k = require("util.keymapping")

-- Navigation
k.map("n", "<leader>e", k.cmd("Oil"))

-- Buffers
k.map("i", "jk", "<Esc>")
k.map("i", "jj", "<Esc>")
k.map("i", "kk", "<Esc>")
k.map("n", "<leader>w", k.cmd("w"))
k.map("n", "<leader>wy", k.cmd('let @" = expand("%")'), { desc = "Yank buffer filepath" })
k.map("n", "<leader>wY", k.cmd('let @* = expand("%")'), { desc = "Yank buffer filepath (clipboard)" })

-- Windows
k.map("n", "<C-l>", "<C-w>l")
k.map("n", "<C-h>", "<C-w>h")
k.map("n", "<C-k>", "<C-w>k")
k.map("n", "<C-j>", "<C-w>j")
k.map("n", "<M-Left>", k.cmd("vertical resize-2"))
k.map("n", "<M-Right>", k.cmd("vertical resize+2"))
k.map("n", "<M-Up>", k.cmd("horizontal resize-2"))
k.map("n", "<M-Down>", k.cmd("horizontal resize+2"))

-- Tabs
k.map("n", "<C-M-l>", k.cmd("+tabnext"), { desc = "Next Tab" })
k.map("n", "<C-M-h>", k.cmd("-tabnext"), { desc = "Previous Tab" })
k.map("n", "<C-M-q>", k.cmd("tabc"), { desc = "Close Tab" })

-- Center scroll when searching
k.map("n", "n", "nzz")
k.map("n", "N", "Nzz")
k.map("n", "*", "*zz")
k.map("n", "#", "#zz")
k.map("n", "g*", "g*zz")
k.map("n", "g#", "g#zz")

-- Stay in indent mode
k.map("v", "<", "<gv")
k.map("v", ">", ">gv")
