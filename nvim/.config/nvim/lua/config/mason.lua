local M = {}

function M.setup()
	local mason_ok, mason = pcall(require, "mason")
	if not mason_ok then
		return
	end

	mason.setup({
	    ui = {
	      check_outdated_packages_on_open = true,
	      width = 0.8,
	      height = 0.9,
	      border = "rounded",
	      keymaps = {
		toggle_package_expand = "<CR>",
		install_package = "i",
		update_package = "u",
		check_package_version = "c",
		update_all_packages = "U",
		check_outdated_packages = "C",
		uninstall_package = "X",
		cancel_installation = "<C-c>",
		apply_language_filter = "<C-f>",
	      },
	    },

	    icons = {
	      package_installed = "◍",
	      package_pending = "◍",
	      package_uninstalled = "◍",
	    },
	})

end

return M
