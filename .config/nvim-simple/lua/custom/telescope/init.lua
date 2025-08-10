local log = require("utils.log")
local themes = require("telescope.themes")
local builtin = require("telescope.builtin")
local make_entry = require("telescope.make_entry")
local entry_display = require("telescope.pickers.entry_display")
local display = require("custom.telescope.display")

local M = {}

local lsp_type_highlight = {
  ["Class"] = "TelescopeResultsClass",
  ["Constant"] = "TelescopeResultsConstant",
  ["Field"] = "TelescopeResultsField",
  ["Function"] = "TelescopeResultsFunction",
  ["Method"] = "TelescopeResultsMethod",
  ["Property"] = "TelescopeResultsOperator",
  ["Struct"] = "TelescopeResultsStruct",
  ["Variable"] = "TelescopeResultsVariable",
}

--- Get filename for the provided bufnr.
---
--- @param bufnr number|nil buffer number, defaults to 0 (current buffer)
--- @return string filename
local function get_filename(bufnr)
  return vim.api.nvim_buf_get_name(bufnr or 0)
end


--- Generate lsp symbols with a slightly different layout. It will display
--- SymbolType first and it will add an additional indentation to the Field
--- symbols to make it easier to comprehend.
---
---@param opts any supported: opts.symbol_width, opts.symbol_highlights
---@return function entry_maker function
local function gen_entries_from_lsp_symbols(opts)
  opts = opts or {}

  -- display entries in two columns format "SymbolType SymbolName"
  local display_items = {
    { width = opts.symbol_width or 25 },
    { remaining = true },
  }

  local displayer = entry_display.create({
    separator = " ",
    hl_chars = { ["["] = "TelescopeBorder", ["]"] = "TelescopeBorder" },
    items = display_items,
  })

  local type_highlight = opts.symbol_highlights or lsp_type_highlight
  local make_display = function(entry)
    return displayer({
      { entry.symbol_type:lower(), type_highlight[entry.symbol_type] },
      entry.symbol_name,
    })
  end

  return function(entry)
    local filename = entry.filename or get_filename(entry.bufnr)
    local symbol_msg = entry.text
    local symbol_type, symbol_name = symbol_msg:match "%[(.+)%]%s+(.*)"
    local ordinal = ""
    ordinal = ordinal .. symbol_name .. " " .. (symbol_type or "unknown")
    -- indent field symbols
    if symbol_type == "Field" then
      symbol_name = "  " .. symbol_name
    end
    return make_entry.set_default_entry_mt({
      value = entry,
      ordinal = ordinal,
      display = make_display,

      filename = filename,
      lnum = entry.lnum,
      col = entry.col,
      symbol_name = symbol_name,
      symbol_type = symbol_type,
      start = entry.start,
      finish = entry.finish,
    }, opts)
  end
end


--- Searches for the git root directory for the provided path
---@param path string path to serarch
---@return string|nil
local function git_repository(path)
  local git_dir = vim.fs.find('.git', {
    path = path or vim.fn.expand("%:p:h"),
    upward = true,
    type = 'directory',
  })[1]
  return git_dir and vim.fs.dirname(git_dir)
end

local function telescope_opts()
  local opts = themes.get_ivy()
  local cwd = vim.fn.expand("%:p:h")
  local repo = git_repository(cwd)
  opts.cwd = repo or cwd
  opts.path_display = display.relpath_display
  return opts
end

--- List lsp references using telescope
function M.lsp_references()
  local opts = telescope_opts()
  opts.include_declaration = true
  opts.include_current_line = true
  return builtin.lsp_references(opts)
end

--- List document symbols using telescope
function M.lsp_document_symbols()
  local opts = telescope_opts()
  opts.symbol_width = 8
  opts.entry_maker = gen_entries_from_lsp_symbols(opts)
  return builtin.lsp_document_symbols(opts)
end

--- List implementations for the symbol under cursor
function M.lsp_implementations()
  local opts = telescope_opts()
  return builtin.lsp_implementations(opts)
end

--- List all definitions
function M.lsp_goto_definition()
  local opts = telescope_opts()
  opts.show_line = false
  return builtin.lsp_definitions(opts)
end

-- List all buffers
function M.buffers()
  local opts = telescope_opts()
  opts.sort_mru = true
  opts.sort_lastused = true
  opts.preview_title = ''
  return builtin.buffers(opts)
end

--- Extracts path components from the path
--- Example: {"/home/user/foo", "/home/user", "/home"}
---@param path string
local function path_components(path)
  local components = {}
  while path ~= "/" and path ~= "" do
    table.insert(components, path)
    path = vim.fs.dirname(path)
  end
  return vim.fn.reverse(components)
end

--- Computes boost for the provided path
---@param path string
---@param components table<string>
---@return number
local function compute_boost(path, components)
  local boost = 0
  for _, component in pairs(components) do
    if not vim.startswith(path, component) then
      break
    end
    boost = boost - 0.001
  end
  return boost
end

--- Boost boost_prefix path in scoring
--- @param boost_prefix string|nil if provided, boost this prefix
local function file_sorter_boosting_prefix(boost_prefix)
  -- I would like to boost the results from the current dir, so they will appear on
  -- top of the list. So I need to configure the scoring for the fuzzy searcher.
  local file_sorter = require("telescope.sorters").get_fzy_sorter()
  if not boost_prefix then
    return file_sorter
  end

  local components = path_components(boost_prefix)
  local base_score = file_sorter.scoring_function
  file_sorter.scoring_function = function(sorter, prompt, line)
    local boost = compute_boost(line, components)
    local score = base_score(sorter, prompt, line)
    -- NOTE: we need to return -1 for the items which should be filtered out
    return math.max(-1, score + boost)
  end
  return file_sorter
end


-- List all files for current git repository
function M.project_files()
  local opts = telescope_opts()
  local cwd = vim.fn.expand("%:p:h"):gsub("^oil://", "") -- remove oil:// prefix if present
  local repo = git_repository(cwd)
  opts.cwd = repo or cwd
  opts.sorter = file_sorter_boosting_prefix(cwd)
  opts.find_command = {
    "fd",
    "--type=f",
    "--unrestricted",
    "--absolute-path",
    "--exclude=.git",
    "--color=never",
  }
  opts.hidden = false
  opts.path_display = display.relpath_display
  opts.preview_title = ''
  return builtin.find_files(opts)
end

-- Live grep
function M.live_grep()
  local opts = telescope_opts()
  local cwd = vim.fn.expand("%:p:h"):gsub("^oil://", "") -- remove oil:// prefix if present
  opts.cwd = cwd
  opts.sorter = file_sorter_boosting_prefix(cwd)
  -- opts.type_filter = "f"
  opts.hidden = false
  opts.path_display = display.relpath_display
  opts.preview_title = ''
  return builtin.live_grep(opts)
end

-- List diagnostics
function M.diagnostics()
  -- local opts = vertical_display_opts()
  local opts = telescope_opts()
  opts.show_line = false
  opts.path_display = "hidden"
  return builtin.diagnostics(opts)
end

return M
