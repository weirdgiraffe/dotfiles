local utils = require("utils")

local M = {}

function M.setup()
	print("settting up keymaps")

	local fzf = require("fzf-lua")

	vim.keymap.set("n", "<leader>ff", utils.git_relative_files, {}) -- list files
	vim.keymap.set("n", "<C-p>", utils.git_relative_files, {}) -- list files
	vim.keymap.set("n", "<leader>fb", fzf.buffers, {}) -- grep buffers
	vim.keymap.set("n", "<leader>fg", fzf.live_grep_glob, {}) -- live grep
	vim.keymap.set({ "n", "v" }, "<leader>ca", fzf.lsp_code_actions, {}) -- code actions
end

return M
