vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.cmdheight = 1 -- more space in the neovim command line for displaying messages

local status, jdtls = pcall(require, "jdtls")
if not status then
	return
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.signatureHelp = {
	dynamicRegistration = false,
	signatureInformation = {
		documentationFormat = { "markdown", "plaintext" },
		parameterInformation = { labelOffsetSupport = true },
	},
}

-- Determine OS
local home = os.getenv("HOME")
if vim.fn.has("mac") == 1 then
	WORKSPACE_PATH = home .. "/Workspace/"
	CONFIG = "mac"
elseif vim.fn.has("unix") == 1 then
	WORKSPACE_PATH = home .. "/workspace/"
	CONFIG = "linux"
else
	print("Unsupported system")
end

-- Find root of project
local root_markers = { ".git/", "mvnw", "gradlew" }
local root_dir = require("jdtls.setup").find_root(root_markers)

if root_dir == "" then
	return
end

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

local workspace_dir = WORKSPACE_PATH .. project_name

local bundles = {}
local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/packages")
-- java-test Mason package is outdated so I installed it manually.
-- vim.list_extend(bundles, vim.split(vim.fn.glob(mason_path .. "packages/java-test/extension/server/*.jar"), "\n"))
local java_test_glob = home .. "/code/vscode-java-test/server/*.jar"
vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_glob, 1), "\n"))

local java_debug_adapter_glob = mason_path
	.. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"
vim.list_extend(bundles, vim.split(vim.fn.glob(java_debug_adapter_glob, 1), "\n"))

local function java_mappings()
	local k = require("util.keymapping")
	local wk_ok, wk = pcall(require, "which-key")

	if wk_ok then
		wk.add({ "<leader>j", group = "Java", mode = "v" })
	end

	k.map("n", "<leader>lo", k.cmd("lua require'jdtls'.organize_imports()"), { desc = "Organize Imports" })

	k.map("n", "<leader>jo", k.cmd("lua require'jdtls'.organize_imports()"), { desc = "Organize Imports" })
	k.map("n", "<leader>jb", k.cmd("JdtCompile"), { desc = "Compile" })
	k.map("n", "<leader>jT", k.cmd("lua require('jdtls').test_class()"), { desc = "Test class" })
	k.map("n", "<leader>jt", k.cmd("lua require('jdtls').test_nearest_method()"), { desc = "Test method" })

	k.map("v", "<leader>jv", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", { desc = "Extract Variable" })
	k.map("v", "<leader>jc", "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>", { desc = "Extract Constant" })
	k.map("v", "<leader>jm", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", { desc = "Extract Method" })
end

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
	-- The command that starts the language server
	-- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
	cmd = {

		-- 💀
		-- "java", -- or '/path/to/java11_or_newer/bin/java'
		"java",
		-- depends on if `java` is in your $PATH env variable and if it points to the right version.

		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-javaagent:" .. home .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar",
		"-Xms1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",

		-- 💀
		"-jar",
		vim.fn.glob(home .. "/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
		-- 💀
		"-configuration",
		home .. "/.local/share/nvim/mason/packages/jdtls/config_" .. CONFIG,
		-- 💀
		-- See `data directory configuration` section in the README
		"-data",
		workspace_dir,
	},

	-- on_attach = require("lvim.lsp").on_attach,
	capabilities = capabilities,

	-- 💀
	-- This is the default if not provided, you can remove it. Or adjust as needed.
	-- One dedicated LSP server & client will be started per unique root_dir
	root_dir = root_dir,

	-- Here you can configure eclipse.jdt.ls specific settings
	-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
	-- or https://github.com/redhat-developer/vscode-java#supported-vs-code-settings
	-- for a list of options
	settings = {
		java = {
			-- jdt = {
			--   ls = {
			--     vmargs = "-XX:+UseParallelGC -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dsun.zip.disableMemoryMapping=true -Xmx1G -Xms100m"
			--   }
			-- },
			eclipse = {
				downloadSources = true,
			},
			configuration = {
				updateBuildConfiguration = "interactive",
				runtimes = {
					{
						name = "JavaSE-11",
						path = "~/.sdkman/candidates/java/11.0.19-zulu",
					},
					{
						name = "JavaSE-17",
						path = "~/.sdkman/candidates/java/17.0.7-zulu",
					},
					{
						name = "JavaSE-19",
						path = "~/.sdkman/candidates/java/19.0.2-zulu",
					},
				},
			},
			maven = {
				downloadSources = true,
			},
			implementationsCodeLens = {
				enabled = false,
			},
			referencesCodeLens = {
				enabled = false,
			},
			references = {
				includeDecompiledSources = true,
			},
			format = {
				enabled = true,
				settings = {
					url = home .. "/code/styleguide/eclipse-java-styleguide.xml",
					profile = "TwilioStyle",
				},
			},
			inlayHints = {
				parameterTypes = {
					enabled = true,
				},
				variableTypes = {
					enabled = true,
				},
				parameterNames = {
					enabled = "all",
				},
			},
			signatureHelp = {
				enabled = true,
				description = {
					enabled = true,
				},
			},
			completion = {
				favoriteStaticMembers = {
					"org.hamcrest.MatcherAssert.assertThat",
					"org.hamcrest.Matchers.*",
					"org.hamcrest.CoreMatchers.*",
					"org.junit.jupiter.api.Assertions.*",
					"java.util.Objects.requireNonNull",
					"java.util.Objects.requireNonNullElse",
					"org.mockito.Mockito.*",
				},
			},
			contentProvider = { preferred = "fernflower" },
			codeGeneration = {
				toString = {
					template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
				},
				useBlocks = true,
			},
			sources = {
				organizeImports = {
					starThreshold = 9999,
					staticStarThreshold = 9999,
				},
			},
		},
		extendedClientCapabilities = extendedClientCapabilities,
	},

	flags = {
		allow_incremental_sync = true,
	},

	-- Language server `initializationOptions`
	-- You need to extend the `bundles` with paths to jar files
	-- if you want to use additional eclipse.jdt.ls plugins.
	--
	-- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
	--
	-- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
	init_options = {
		-- bundles = {},
		bundles = bundles,
	},
}

config["on_attach"] = function(client, bufnr)
	local _, _ = pcall(vim.lsp.codelens.refresh)
	require("jdtls").setup_dap()
	require("jdtls.dap").setup_dap_main_class_configs()
	java_mappings()
	if client.supports_method("textDocument/inlayHint") then
		vim.lsp.inlay_hint.enable(true)
	end
end

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = { "*.java" },
	callback = function()
		local _, _ = pcall(vim.lsp.codelens.refresh)
	end,
})

-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
jdtls.start_or_attach(config)
