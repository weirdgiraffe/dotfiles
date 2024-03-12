M = {}

---run command and return its output
---@param cmd string command to run
---@return string output
function M.cmd(cmd)
  local envcmd = "export PATH=/opt/homebrew/bin:$PATH;" .. cmd
  local output, status, type, rc = hs.execute(envcmd, false)
  if status then
    return output
  else
    local errmsg = ("failed to run %s: %s(%d)"):format(cmd, type, rc)
    error(errmsg)
  end
end

return M
