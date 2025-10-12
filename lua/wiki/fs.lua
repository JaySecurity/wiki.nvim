local config = require("wiki.config")

local M = {}

--- Read Dir
---@param path string | nil
M.read_dir = function(path)
	if path == nil then
		path = config.ClientOpts.current_vault.path
	end
	local data = vim.fs.dir(path)
	local result = {}
	if not data then
		print("Error accessing path ")
	else
		while true do
			local name, type = data()
			if name == nil then
				break
			end
			if name ~= "." and name ~= ".." then
				if type == "directory" then
					table.insert(result, config.ClientOpts.icons.dir .. " " .. name)
				else
					table.insert(result, config.ClientOpts.icons.note .. " " .. name)
					-- table.insert(result, name)
				end
			end
		end
		table.sort(result, function(a, b)
			local special = ""

			-- Check if they start with the special char
			local a_is_special = a:sub(1, #special) == special
			local b_is_special = b:sub(1, #special) == special

			if a_is_special and not b_is_special then
				return true
			elseif b_is_special and not a_is_special then
				return false
			else
				-- If both special or both normal, compare alphabetically
				return a < b
			end
		end)
	end
	M.open_buffer(result, path, true)
end

--- Open Buffer
---@param data string[]
---@param path string | ?
---@param is_dir boolean | ?
M.open_buffer = function(data, path, is_dir)
	---@diagnostic disable-next-line: redefined-local
	local is_dir = is_dir or false
	local bufnr = vim.api.nvim_create_buf(not is_dir, is_dir)
	vim.api.nvim_buf_set_var(bufnr, "path", path)
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, data)
	vim.api.nvim_set_current_buf(bufnr)
	vim.api.nvim_set_option_value("filetype", "wiki", {})
end

return M
