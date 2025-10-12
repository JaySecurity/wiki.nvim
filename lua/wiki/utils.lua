local c = require("wiki.config")

local M = {}
M.select_and_open = function()
	-- local base_path = c.ClientOpts.current_vault.path
	local line = vim.api.nvim_get_current_line()
	if line == "" then
		return
	end
	print("Select and Open Fired")
end

return M
