local tbl_override = function(defaults, overrides)
	local out = vim.tbl_extend("force", defaults, overrides)
	for k, v in pairs(out) do
		if v == vim.NIL then
			out[k] = nil
		end
	end
	return out
end

local M = {}
---@class wiki.config.Vault
---@field name string
---@field path string

---@class wiki.config.ClientOpts
---@field vaults wiki.config.Vault[]
---@field current_vault wiki.config.Vault
---@field icons table<string,string>
M.ClientOpts = {}

--- Get defaults.
---
---@return wiki.config.ClientOpts
M.ClientOpts.default = function()
	return {
		current_vault = { name = "default", path = vim.fn.stdpath("data") .. "/vaults/default" },
		vaults = {
			{
				name = "default",
				path = vim.fn.stdpath("data") .. "/vaults/default",
			},
		},
		icons = {
			dir = "",
			note = "󰎛",
		},
	}
end

M.set_config = function(opts)
	opts = opts or {}
	opts = tbl_override(M.ClientOpts.default(), opts)
	for _, vault in ipairs(opts.vaults) do
		vault.path = vim.fs.normalize(vault.path)
		if string.sub(vault.path, -1) ~= "/" then
			vault.path = vault.path .. "/"
		end
	end
	opts.current_vault = opts.vaults[1]
	M.ClientOpts = opts
end

M.get_config = function()
	return M.ClientOpts
end

M.get_vaults = function()
	return M.ClientOpts.vaults
end

M.select_vault = function()
	local vaults = {}
	for i, val in ipairs(M.ClientOpts.vaults) do
		table.insert(vaults, i .. ": " .. val.name)
	end
	vim.ui.select(vaults, {
		prompt = "Change Current Vault: ",
		format_item = function(item)
			return item
		end,
	}, function(choice)
		if choice then
			print(choice)
			local index = vim.fn.split(choice, ":", true)
			M.ClientOpts.current_vault = M.ClientOpts.vaults[tonumber(index[1])]
			print("Vault changed to " .. M.ClientOpts.current_vault.name)
		end
	end)
end

return M
