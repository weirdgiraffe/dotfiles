-- I don't like telescope because it feels buggy to me, so I stick with
-- my favorite FZF
-- NOTE: need fzf and ripgrep installed

local M = {
	"ibhagwan/fzf-lua",
	lazy = false,
	requires = {
		"nvim-tree/nvim-web-devicons",
	},
	build = "./install --bin",
}

local function git_relative_files(fzf)
	return function()
		local git_root = fzf.path.git_root({}, true)
		if not git_root then
			return fzf.files()
		end
		local relative = fzf.path.relative(vim.loop.cwd(), git_root)
		local opts = {
			fd_opts = table.concat({
				"--type=f",
				"--exclude={.git,vendor,node_modules}",
			}, " "),
			fzf_opts = {
				["--query"] = git_root ~= relative and relative or nil,
			},
			cwd = git_root,
		}
		return fzf.files(opts)
	end
end

local function keymap(fzf)
	local files = git_relative_files(fzf)

	vim.keymap.set("n", "<C-p>", files, {}) -- list files (just for convience)
	vim.keymap.set("n", "<leader>ff", files, {}) -- list files
	vim.keymap.set("n", "<leader>fb", fzf.buffers, {}) -- grep buffers
	vim.keymap.set("n", "<leader>fg", fzf.live_grep_glob, {}) -- live grep
	vim.keymap.set({ "n", "v" }, "<leader>ca", fzf.lsp_code_actions, {}) -- code actions
end

function M.config()
	local fzf = require("fzf-lua")
	fzf.setup({
		fzf_opts = {
			["--color"] = require("colors").fzf_colors(),
		},
	})
	keymap(fzf)
end

return M
