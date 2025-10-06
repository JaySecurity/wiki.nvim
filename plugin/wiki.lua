local w = require("wiki")

vim.api.nvim_create_user_command("WikiSelectVault", function()
	w.config.select_vault()
end, {})

vim.api.nvim_create_user_command("WikiOpen", function()
	w.fs.open_dir()
end, {})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "wiki",
	callback = w.utils.select_and_open,
})
