---@class TelescopeEntry
---@field value any value key can be anything but still required
---@field valid? boolean is an optional key because it defaults to true but if
---       the key is set to false it will not be displayed by the picker
---@field ordinal string is the text that is used for filtering
---@field display string|function is either a string of the text that is being
---       displayed or a function receiving the entry at a later stage, when
---       the entry is actually being displayed. A function can be useful here
---       if anything complex calculation has to be done. `make_entry` can also
---       return a second value - a highlight array which will then apply to
---       the line. Highlight entry in this array has the following signature
---       `{ { start_col, end_col }, hl_group }`
---@field filename? string will be interpreted by the default `<cr>` action as
---       open this file
---@field bufnr? number will be interpreted by the default `<cr>` action as
---       open this buffer
---@field lnum? number: lnum value which will be interpreted by the default
---       `<cr>` action as a jump to this line
---@field col? number col value which will be interpreted by the default `<cr>`
---       action as a jump to this column



local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local harpoon = require("harpoon")

---@param selection TelescopeEntry
---@param item HarpoonItem
---@return boolean
local function selection_match_harpoon_item(selection, item)
  if selection.value ~= item.value then
    return false
  end
  if selection.lnum ~= item.context.row then
    return false
  end
  return selection.col == item.context.col
end

---@param item HarpoonItem
---@return TelescopeEntry
local function entry_maker(item)
  assert(item.value, "item value should not be nil")
  local path = require("plenary.path"):new(item.value)
  local relpath = path:normalize(path.home)
  local entry = {
    ordinal = relpath,
    display = string.format("%s:%s:%s",
      relpath,
      item.context.row,
      item.context.col),
    value = item.value,
    filename = item.value,
    lnum = item.context.row,
    col = item.context.col,
  }
  return entry
end

local function not_empty_list_entries()
  local list = harpoon:list()
  local items = list.items
  local next = {}
  for _, item in ipairs(items) do
    if item then
      table.insert(next, item)
    end
  end
  return next
end

local function finder(entries)
  entries = entries or not_empty_list_entries()
  return require("telescope.finders").new_table({
    results = entries,
    entry_maker = entry_maker,
  })
end

local function delete_mark(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  picker:delete_selection(function(selection)
    harpoon:list():remove({
      value = selection.value,
      context = {
        row = selection.lnum,
        col = selection.col,
      },
    })
  end)
end

local function telescope()
  -- local opts = require("telescope.themes").get_dropdown()
  -- local opts = require("telescope.themes").get_cursor()
  local opts = require("telescope.themes").get_ivy()

  local entries = not_empty_list_entries()
  if #entries == 0 then
    vim.notify("harpoon: there are no marks", vim.log.levels.INFO)
    return
  end

  local conf = require("telescope.config").values
  local previewer = conf.grep_previewer(opts)

  require("telescope.pickers").new(opts, {
    prompt_title = "Harpoon Marks (C-d to delete a mark)",
    finder = finder(entries),
    sorter = conf.generic_sorter(opts),
    previewer = previewer,
    attach_mappings = function(_, map)
      map({ "i", "n" }, "<c-d>", delete_mark)
      -- map({ "i", "n" }, "<c-p>", prev_mark)
      -- map({ "i", "n" }, "<c-n>", next_mark)
      return true
    end,
  }):find()
end

local function add_mark()
  vim.notify("harpoon: add mark")
  return harpoon:list():add()
end

return {
  telescope = telescope,
  add_mark = add_mark,
  clear = function()
    harpoon:list():clear()
  end,
}
