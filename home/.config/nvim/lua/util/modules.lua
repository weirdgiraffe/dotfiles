local M = {}

---having will execute fn if module is available
---@param module string name of the module to check
---@param fn function with signature function(module) to execute if module is available
function M.having(module, fn)
  local module = require(module)
  if module then
    fn(module)
  end
end

---missing will execute fn if module is not available
---@param module string name of the module to check
---@param fn function to execute if module is available
function M.missing(module, fn)
  local has_module = require(module) ~= nil
  if not has_module then
    fn()
  end
end

return M
