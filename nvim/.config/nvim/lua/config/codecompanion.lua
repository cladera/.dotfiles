local km = require("util.keymapping")

local M = {}

local function deep_merge(base, override)
	local result = vim.deepcopy(base)

	for key, value in pairs(override) do
		if type(value) == "table" and type(result[key]) == "table" then
			result[key] = deep_merge(result[key], value)
		else
			result[key] = value
		end
	end

	return result
end

local function get_default_config()
	return {
		memory = {
			opts = {
				chat = {
					enabled = true,
				},
			},
		},
		interactions = {
			chat = {
				roles = {
					llm = function(adapter)
						if adapter.model and adapter.model.name then
							return adapter.formatted_name .. " (" .. adapter.model.name .. ")"
						end
						return adapter.formatted_name
					end,
					user = "Me",
				},
				tools = {
					opts = {
						default_tools = {
							"neovim",
						},
					},
				},
			},
		},
		display = {
			chat = {
				window = {
					width = 0.33,
					border = "single", -- Add border to chat window
					opts = {
						breakindent = true,
						cursorcolumn = false,
						cursorline = false,
						foldcolumn = "0",
						linebreak = true,
						list = true,
						numberwidth = 1,
						signcolumn = "yes",
						spell = true,
						wrap = true,
					},
				},
			},
			diff = {
				enabled = true,
			},
		},
		extensions = {
			mcphub = {
				callback = "mcphub.extensions.codecompanion",
				opts = {
					-- MCP Tools
					make_tools = true, -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
					show_server_tools_in_chat = true, -- Show individual tools in chat completion (when make_tools=true)
					add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
					show_result_in_chat = true, -- Show tool results directly in chat buffer
					format_tool = nil, -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
					-- MCP Resources
					make_vars = true, -- Convert MCP resources to #variables for prompts
					-- MCP Prompts
					make_slash_commands = true, -- Add MCP prompts as /slash commands
				},
			},
			history = {
				enabled = true,
				opts = {
					-- Keymap to open history from chat buffer (default: gh)
					keymap = "gh",
					-- Keymap to save the current chat manually (when auto_save is disabled)
					save_chat_keymap = "sc",
					-- Save all chats by default (disable to save only manually using 'sc')
					auto_save = true,
					-- Number of days after which chats are automatically deleted (0 to disable)
					expiration_days = 0,
					-- Picker interface (auto resolved to a valid picker)
					picker = "telescope", --- ("telescope", "snacks", "fzf-lua", or "default")
					---Optional filter function to control which chats are shown when browsing
					chat_filter = function(chat_data)
						return chat_data.cwd == vim.fn.getcwd()
					end, -- function(chat_data) return boolean end
					-- Customize picker keymaps (optional)
					picker_keymaps = {
						rename = { n = "r", i = "<M-r>" },
						delete = { n = "d", i = "<M-d>" },
						duplicate = { n = "<C-y>", i = "<C-y>" },
					},
					---Automatically generate titles for new chats
					auto_generate_title = true,
					title_generation_opts = {
						---Adapter for generating titles (defaults to current chat adapter)
						adapter = "copilot", -- "copilot"
						---Model for generating titles (defaults to current chat model)
						model = "gpt-4o", -- "gpt-4o"
						---Number of user prompts after which to refresh the title (0 to disable)
						refresh_every_n_prompts = 3, -- e.g., 3 to refresh after every 3rd user prompt
						---Maximum number of times to refresh the title (default: 3)
						max_refreshes = 3,
						format_title = function(original_title)
							-- this can be a custom function that applies some custom
							-- formatting to the title.
							return original_title
						end,
					},
					---On exiting and entering neovim, loads the last chat on opening chat
					continue_last_chat = false,
					---When chat is cleared with `gx` delete the chat from history
					delete_on_clearing_chat = false,
					---Directory path to save the chats
					dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
					---Enable detailed logging for history extension
					enable_logging = false,

					-- Summary system
					summary = {
						-- Keymap to generate summary for current chat (default: "gcs")
						create_summary_keymap = "gCs",
						-- Keymap to browse summaries (default: "gbs")
						browse_summaries_keymap = "gbs",

						generation_opts = {
							adapter = nil, -- defaults to current chat adapter
							model = nil, -- defaults to current chat model
							context_size = 90000, -- max tokens that the model supports
							include_references = true, -- include slash command content
							include_tool_outputs = true, -- include tool execution results
							system_prompt = nil, -- custom system prompt (string or function)
							format_summary = nil, -- custom function to format generated summary e.g to remove <think/> tags from summary
						},
					},

					-- Memory system (requires VectorCode CLI)
					-- memory = {
					-- 	-- Automatically index summaries when they are generated
					-- 	auto_create_memories_on_summary_generation = true,
					-- 	-- Path to the VectorCode executable
					-- 	vectorcode_exe = "vectorcode",
					-- 	-- Tool configuration
					-- 	tool_opts = {
					-- 		-- Default number of memories to retrieve
					-- 		default_num = 10,
					-- 	},
					-- 	-- Enable notifications for indexing progress
					-- 	notify = true,
					-- 	-- Index all existing memories on startup
					-- 	-- (requires VectorCode 0.6.12+ for efficient incremental indexing)
					-- 	index_on_startup = false,
					-- },
				},
			},
		},
	}
end

local function load_user_config()
	local config_paths = {
		vim.fn.expand("~/.local/nvim/codecompanion.lua"),
		vim.fn.getcwd() .. "/.nvim/codecompanion.lua",
	}

	local result_config = {}

	for _, path in ipairs(config_paths) do
		if vim.fn.filereadable(path) == 1 then
			local ok, user_config = pcall(dofile, path)
			if ok and type(user_config) == "table" then
				if type(user_config.setup) == "function" then
					local success, result = pcall(user_config.setup)
					if success and type(result) == "table" then
						result_config = deep_merge(result_config, result)
					elseif not success then
						vim.notify(
							"Error in CodeCompanion user config setup(): " .. tostring(result) .. ": " .. path,
							vim.log.levels.ERROR
						)
					end
				elseif type(user_config) == "table" then
					result_config = deep_merge(result_config, user_config)
				end
			end
		end
	end

	return result_config
end

function M.setup()
	local ok, codecompanion = pcall(require, "codecompanion")
	if not ok then
		return
	end

	local default_config = get_default_config()
	local user_config = load_user_config()

	codecompanion.setup(deep_merge(default_config, user_config))

	km.map("n", "<leader>ca", km.cmd("CodeCompanionActions"), { desc = "CodeCompanion Actions" })
	km.map("n", "<leader>cc", km.cmd("CodeCompanionChat"), { desc = "CodeCompanion Chat" })
	km.map("n", "<leader>ch", km.cmd("CodeCompanionHistory"), { desc = "CodeCompanion History" })
	km.map("n", "<leader>cs", km.cmd("CodeCompanionSummaries"), { desc = "CodeCompanion Summaries" })
end

return M
