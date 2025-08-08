local M = {}

---@param s string|number
---@param ... any
function M.warn(s, ...)
  local msg = string.format(s, ...)
  vim.notify(msg, vim.log.levels.WARN)
end

---@param s string|number
---@param ... any
function M.debug(s, ...)
  local msg = string.format(s, ...)
  vim.notify(msg, vim.log.levels.DEBUG)
end

---@param s string|number
---@param ... any
function M.info(s, ...)
  local msg = string.format(s, ...)
  vim.notify(msg, vim.log.levels.INFO)
end

return M
