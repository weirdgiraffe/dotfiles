local M = {}

function M.setup()
	require("config.options") -- set up default editor options
	require("config.colors").setup() -- set up colors functions
end

return M
