local M = {}

---having will execute fn if module is available
---@param module string name of the module to check
---@param fn function with signature function(module) to execute if module is available
function M.having(module, fn)
  local ok, m = pcall(require, module)
  if ok then
    fn(m)
  end
end

---missing will execute fn if module is not available
---@param module string name of the module to check
---@param fn function to execute if module is available
function M.missing(module, fn)
  local ok, m = pcall(require, module)
  if not ok then
    fn()
  end
end

return M
