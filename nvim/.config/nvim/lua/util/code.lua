local M = {}

function M.get_test_at_cursor()
	local grep = nil
	local node = vim.treesitter.get_node()
	local maxAppends = 4

	while node do
		if node:type() == "call_expression" then
			local fn = vim.treesitter.get_node_text(node:child(0), 0)
			if fn == "it" or fn == "describe" or fn == "context" then
				local arguments = node:child(1)
				local spec = vim.treesitter.get_node_text(arguments:child(1):child(1), 0)
				if grep == nil then
					grep = spec
				else
					grep = spec .. " " .. grep
				end
				maxAppends = maxAppends - 1
				if maxAppends == 0 then
					break
				end
			end
		end
		node = node:parent()
	end
	if grep == nil then
		return ""
	end

	return string.gsub(grep, "([()$])", "\\%1")
end

return M
