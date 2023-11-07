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

local function delete_buffer(bufnr)
	if vim.fn.buflisted(bufnr) == 0 then
    -- skip bufnr if it's a special kind of a buffer
    -- i.e. if it is not listed
		return
	end

	if vim.fn.getbufvar(bufnr, "&modified") == 0 then
    -- delete only not modified buffers
		vim.cmd.bdel(bufnr)
	end
end

-- close_all_buffers will close all the buffers but the current one
-- NOTE: if buffers do have some unsaved changes it will not be closed
function M.close_other_buffers()
	local this_buffer = vim.fn.bufnr("%")
	local last_buffer = vim.fn.bufnr("$")

	local bufnr = 1
	while bufnr <= last_buffer do
		if bufnr ~= this_buffer then
			delete_buffer(bufnr)
		end
		bufnr = bufnr + 1
	end
end

return M
