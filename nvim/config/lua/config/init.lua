local M = {}

function M.setup()
	print("Loading config module")
	require("config.options").setup() -- set up default editor options
	require("config.lazy").setup() -- set up default lazy.nvim
	require("config.colors").setup() -- set up colors functions
	require("config.keymaps").setup() -- set up keymaps functions
end

return M
