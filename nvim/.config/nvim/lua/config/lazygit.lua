local M = {}
local k = require("util.keymapping")

function M.setup()
	k.map("n", "<leader>gg", k.cmd("LazyGitCurrentFile"), { desc = "LazyGit" })
end

return M
