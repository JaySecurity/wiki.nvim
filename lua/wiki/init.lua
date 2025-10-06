local module_lookups = {
	config = "wiki.config",
	fs = "wiki.fs",
	utils = "wiki.utils",
}

local M = setmetatable({}, {
	__index = function(t, k)
		local require_path = module_lookups[k]
		if not require_path then
			return
		end

		local mod = require(require_path)
		t[k] = mod

		return mod
	end,
})

M.setup = function(opts)
	M.config.set_config(opts)
end

return M
