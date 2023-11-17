M = {
  opts = {
    prefix = nil,
    log_level = vim.log.levels.INFO,
    log_file = nil,
  }
}

local function write_message(msg)
  local line = string.format("%s %s\n",
    os.date("!%Y-%m-%dT%H:%M:%SZ"),
    msg)
  if M.opts.log_file then
    local fp = io.open(M.opts.log_file, "a")
    _ = fp:write(line)
    _ = fp:close()
  else
    print(line)
  end
end

local function write_level_message(prefix, level, msg)
  if not M.opts.log_level then
    return
  end

  if M.opts.log_level <= level then
    msg = prefix and prefix .. " " .. msg or msg
    if level == vim.log.levels.TRACE then
      return write_message("TRACE: " .. msg)
    elseif level == vim.log.levels.DEBUG then
      return write_message("DEBUG: " .. msg)
    elseif level == vim.log.levels.INFO then
      return write_message("INFO: " .. msg)
    elseif level == vim.log.levels.WARN then
      return write_message("WARN: " .. msg)
    elseif level == vim.log.levels.ERROR then
      return write_message("ERROR: " .. msg)
    end
  end
end

function M.setup(opts)
  M.opts = vim.tbl_extend("force", M.opts, opts or {})
end

function M.named(name)
  return {
    debug = function(msg)
      write_level_message(name, vim.log.levels.DEBUG, msg)
    end,
    info = function(msg)
      write_level_message(name, vim.log.levels.INFO, msg)
    end,
    error = function(msg)
      write_level_message(name, vim.log.levels.ERROR, msg)
    end,
  }
end

return M
