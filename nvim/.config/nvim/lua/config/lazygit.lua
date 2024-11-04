local M = {}
local k = require("util.keymapping")

function M.setup()
	k.map("n", "<leader>gg", k.cmd("LazyGit"), { desc = "LazyGit" })
end

return M
