local M = {}

local function is_listed(bufnr)
  return vim.api.nvim_get_option_value("buflisted", { buf = bufnr })
end

local function is_modified(bufnr)
  return vim.api.nvim_get_option_value("modified", { buf = bufnr })
end

---fileter_buffers will filter the list of buffers based on a given filter function.
---@param buffers table list of buffer numbers to filter
---@param filter_fn function function that takes a buffer number and returns true if the buffer should be
local function filter_buffers(buffers, filter_fn)
  local result = {}
  for _, bufnr in ipairs(buffers) do
    if filter_fn(bufnr) then
      table.insert(result, bufnr)
    end
  end
  return result
end

local function switch_to_buffer(bufnr)
  vim.api.nvim_set_current_buf(bufnr)
end

--- switch focus to a buffer with the given bufnr.
---@param bufnr number buffer number to switch focus to
function M.switch_to_buffer(bufnr)
  return switch_to_buffer(bufnr)
end

--- switch focus to the next listed buffer.
function M.next_buffer()
  local buffers = filter_buffers(vim.api.nvim_list_bufs(), is_listed)
  local current = vim.api.nvim_get_current_buf()
  for i, bufnr in ipairs(buffers) do
    if bufnr == current then
      if i == #buffers then
        switch_to_buffer(buffers[1])
      else
        switch_to_buffer(buffers[i + 1])
      end
      return
    end
  end
end

--- switch focus to the previous listed buffer.
function M.prev_buffer()
  local buffers = filter_buffers(vim.api.nvim_list_bufs(), is_listed)
  local current = vim.api.nvim_get_current_buf()
  for i, bufnr in ipairs(buffers) do
    if bufnr == current then
      if i == 1 then
        switch_to_buffer(buffers[#buffers])
      else
        switch_to_buffer(buffers[i - 1])
      end
      return
    end
  end
end

---close all not modified buffers except the current one.
function M.close_other_buffers()
  local current = vim.api.nvim_get_current_buf()
  local buffers = filter_buffers(vim.api.nvim_list_bufs(), function(bufnr)
    if is_listed(bufnr) and not is_modified(bufnr) then
      return current ~= bufnr
    end
    return false
  end)
  for _, bufnr in ipairs(buffers) do
    vim.api.nvim_buf_delete(bufnr, {})
  end
end

return M
