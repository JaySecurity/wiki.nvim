local c = require("wiki.config")
local config = c.get_config()

local M = {}
M.is_dir = function(line) end
M.select_and_open = function(event)
	vim.keymap.set("n", "<CR>", function()
		local path = config.current_vault.path
		local line = vim.api.nvim_get_current_line()
		if line == "" then
			return
		end
	end, { buffer = event.buf })
end

return M
