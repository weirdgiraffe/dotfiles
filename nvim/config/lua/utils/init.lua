local M = {}

function M.git_relative_files()
	local fzf = require("fzf-lua")

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

return M
