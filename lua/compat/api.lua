local M


--- Prints a message given error message
--- @param msg string message to print
function M.echo_error(msg)
  if vim.fh.has("nvim-0.5") == 1 then
    vim.api.nvim_echo({ msg }, true, { err = true })
  else
    vim.api.nvim_err_writeln(msg)
  end
end

return M
