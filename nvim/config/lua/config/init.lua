local M = {}

function M.setup()
	print("Loading config module")
	require("config.options").setup() -- set up default editor options
	require("config.colors").setup() -- set up colors functions
end

return M
