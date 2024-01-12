Logger = {
  name = nil,
  log_level = vim.log.levels.INFO,
  log_file = nil,
}
Logger.__index = Logger

function Logger:create(opts)
  local this = {}
  this = vim.tbl_extend("force", self, opts or {})
  setmetatable(this, self)
  return this
end

function Logger:write_message(msg)
  local line = string.format("%s %s\n",
    os.date("!%Y-%m-%dT%H:%M:%SZ"),
    msg)
  if self.log_file then
    local fp = io.open(self.log_file, "a")
    fp:write(line)
    fp:close()
  else
    print(line)
  end
end

function Logger:write_level_message(level, msg)
  if not self.log_level then
    return
  end
  if self.log_level <= level then
    local name = self.name and "(" .. self.name .. ")" or ""
    if level == vim.log.levels.TRACE then
      self:write_message("TRACE" .. name .. ": " .. msg)
    elseif level == vim.log.levels.DEBUG then
      self:write_message("DEBUG" .. name .. ": " .. msg)
    elseif level == vim.log.levels.INFO then
      self:write_message("INFO" .. name .. ": " .. msg)
    elseif level == vim.log.levels.WARN then
      self:write_message("WARN" .. name .. ": " .. msg)
    elseif level == vim.log.levels.ERROR then
      self:write_message("ERROR" .. name .. ": " .. msg)
    end
  end
end

local M = {}

function M.new(opts)
  local logger = Logger:create(opts)
  return {
    debug = function(msg)
      logger:write_level_message(vim.log.levels.DEBUG, msg)
    end,
    info = function(msg)
      logger:write_level_message(vim.log.levels.INFO, msg)
    end,
    error = function(msg)
      logger:write_level_message(vim.log.levels.ERROR, msg)
    end,
  }
end

return M
