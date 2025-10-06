local config = require("wiki.config")

local M = {}

M.open_dir = function(path)
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

		-- print(vim.inspect(result))
		local bufnr = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, result)
		vim.api.nvim_set_current_buf(bufnr)
		vim.api.nvim_set_option_value("filetype", "wiki", {})
	end
end
return M
