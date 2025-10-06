local _default_vaults = {
	{
		name = "default",
		path = vim.fn.stdpath("data") .. "/vaults/default",
	},
}

local config = {}

local M = {}

M.set_config = function(opts)
	opts = opts or {}
	config.vaults = opts.vaults or _default_vaults
	config.current_vault = opts.vaults[1]
end

M.get_config = function()
	return config
end

M.get_vaults = function()
	return config.vaults
end

M.select_vault = function()
	local vaults = {}
	for i, val in ipairs(config.vaults) do
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
			config.current_vault = config.vaults[tonumber(index[1])]
			print("Vault changed to " .. config.current_vault.name)
		end
	end)
end

return M
