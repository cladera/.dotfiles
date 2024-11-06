require("config.lazy")
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.colorscheme")

if vim.fn.executable("nvr") == 1 then
	vim.env.GIT_EDITOR = "nvr --remote-tab-wait +'set bufhidden=delete'"
end
