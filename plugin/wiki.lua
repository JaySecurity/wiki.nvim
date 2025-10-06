local w = require("wiki")
local c = require("wiki.config")
local config = c.get_config()

vim.api.nvim_create_user_command("WikiSelectVault", function()
	c.select_vault()
end, {})

vim.api.nvim_create_user_command("WikiOpen", function()
	w.open_dir()
end, {})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "wiki",
	callback = w.utils.select_and_open,
})
