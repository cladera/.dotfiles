local M = {}

function M.setup()
	local ok, codecompanion = pcall(require, "codecompanion")
	if not ok then
		return
	end

	codecompanion.setup({
		strategies = {
			chat = {
				adapter = "copilot",
			},
			inline = {
				adapter = "copilot",
			},
		},
    display = {
      chat = {
				window = {
					width = 0.33,
				},
      },
      diff = {
        enabled = false,
      }
    }
	})
end

return M
