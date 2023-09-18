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

local function delete_buffer(buffer_number)
	-- skip all kind of special buffers
	if vim.fn.buflisted(curr_buffer) == 0 then
		return
	end

	-- skip all modified buffers
	if vim.fn.getbufvar(curr_buffer, "&modified") == 0 then
		vim.cmd.bdel(curr_buffer)
	end
end

-- close_all_buffers will close all the buffers but the current one
-- NOTE: if buffers do have some unsaved changes it will not be closed
function M.close_other_buffers()
	local this_buffer = vim.fn.bufnr("%")
	local last_buffer = vim.fn.bufnr("$")

	local curr_buffer = 1
	while curr_buffer <= last_buffer do
		if curr_buffer ~= this_buffer then
			delete_buffer(cur_buffer)
		end
		curr_buffer = curr_buffer + 1
	end
end

return M
