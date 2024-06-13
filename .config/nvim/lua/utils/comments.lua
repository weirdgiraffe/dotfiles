-- for compatibility with lua versions
local unpack = unpack or table.unpack

local function map(list, fn)
  local result = {}
  for _, item in pairs(list) do
    table.insert(result, fn(item))
  end
  return result
end

local function reduce(list, fn)
  local result = nil
  for _, item in pairs(list) do
    result = fn(result, item)
  end
  return result
end

local function is_in_visual_mode()
  local visual_modes = {
    ["v"] = true,
    ["vs"] = true,
    ["V"] = true,
    ["Vs"] = true,
    ["CTRL-V"] = true,
    ["CTRL-Vs"] = true,
  }
  return visual_modes[vim.api.nvim_get_mode().mode] or false
end

local function visual_selection_line_range()
  local selection_start = { unpack(vim.fn.getpos('v'), 2, 3) }
  -- NOTE: getpos's column is 1-based, and we need 0-based
  selection_start[2] = selection_start[2] - 1

  local selection_end = vim.api.nvim_win_get_cursor(0)

  -- NOTE: handle "reverse" selection (the cursor is at the start of the
  -- selection, not the end)
  -- Flip based on lines
  if selection_start[1] > selection_end[1] then
    local temp_selection_end = selection_end
    selection_end = selection_start
    selection_start = temp_selection_end
  end

  -- Flip based on columns
  if selection_start[2] > selection_end[2] then
    local temp_selection_end = selection_end[2]
    selection_end[2] = selection_start[2]
    selection_start[2] = temp_selection_end
  end

  return { selection_start[1], selection_end[1] }
end

local function comment_pattern(commentstring)
  local pattern = string.sub(commentstring, 1, -3) -- get just a comment sign
  if vim.bo.filetype == "lua" then
    -- treat lua comments specially because they use regex special symbols
    return "^%s*%-%-"
  else
    return pattern
  end
end

---toggle_line_comments will comment out lines in range [first,last)
---@param range map {first: number, last: number}
local function toggle_line_comments(range)
  local commentstring = vim.api.nvim_get_option_value("commentstring", { buf = 0 })
  local lines = vim.api.nvim_buf_get_lines(0, range.first - 1, range.last, false)
  local pattern = comment_pattern(commentstring)

  local num_commented_lines = reduce(map(lines, function(x)
    return string.match(x, pattern) and 1 or 0
  end), function(x, y)
    return (x or 0) + y
  end)

  local fn = nil
  if num_commented_lines == #lines then
    fn = function(x) return string.gsub(x, pattern, "", 1) end
  else
    fn = function(x) return string.format(commentstring, x) end
  end

  for i, line in pairs(lines) do
    lines[i] = fn(line)
  end

  vim.api.nvim_buf_set_lines(0, range.first - 1, range.last, false, lines)
end

local function toggle_current_line_comment()
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  toggle_line_comments({ first = row, last = row })
end

local function toggle_selection_comment()
  local first, last = unpack(visual_selection_line_range())
  toggle_line_comments({ first = first, last = last })
end

local M = {}

function M.toggle()
  if is_in_visual_mode() then
    toggle_selection_comment()
  else
    toggle_current_line_comment()
  end
end

return M
