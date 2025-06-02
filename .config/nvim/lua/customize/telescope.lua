local entry_display = require("telescope.pickers.entry_display")
local make_entry = require("telescope.make_entry")
local themes = require("telescope.themes")
local builtin = require("telescope.builtin")


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

local get_filename_fn = function()
  local bufnr_name_cache = {}
  return function(bufnr)
    bufnr = vim.F.if_nil(bufnr, 0)
    local c = bufnr_name_cache[bufnr]
    if c then
      return c
    end

    local n = vim.api.nvim_buf_get_name(bufnr)
    bufnr_name_cache[bufnr] = n
    return n
  end
end

local M = {}


--- gen_entries_from_lsp_symbols will generate lsp symbols with a slightly
--- different layout. It will display SymbolType first and it will add an
--- additional indentation to the Field symbols to make it easier to
--- comprehend.
---@param opts any supported: opts.symbol_width, opts.symbol_highlights
local function gen_entries_from_lsp_symbols(opts)
  opts = opts or {}

  -- display entries in two columns format "SymbolType SymbolName"
  local display_items = {
    { width = opts.symbol_width or 25 },
    { remaining = true },
  }

  local displayer = entry_display.create {
    separator = " ",
    hl_chars = { ["["] = "TelescopeBorder", ["]"] = "TelescopeBorder" },
    items = display_items,
  }

  local type_highlight = vim.F.if_nil(opts.symbol_highlights or lsp_type_highlight)

  local make_display = function(entry)
    return displayer({
      { entry.symbol_type:lower(), type_highlight[entry.symbol_type] },
      entry.symbol_name,
    })
  end

  local get_filename = get_filename_fn()
  return function(entry)
    local filename = vim.F.if_nil(entry.filename, get_filename(entry.bufnr))
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

function M.lsp_document_symbols()
  local opts = themes.get_ivy()
  opts.symbol_width = 8
  opts.entry_maker = gen_entries_from_lsp_symbols(opts)
  return builtin.lsp_document_symbols(opts)
end

function M.lsp_references()
  local opts = themes.get_dropdown({
    layout_strategy = "vertical",
    preview_title = "",
    layout_config = {
      mirror = true,
      prompt_position = "top",
      height = 0.8,

      width = function(_, max_columns, _)
        local computed = math.min(120, math.floor(max_columns * 0.6)) -- 60% of screen width, max 80 columns
        return computed
      end,
    },
  })
  opts.include_declaration = true
  opts.include_current_line = true
  return builtin.lsp_references(opts)
end

function M.lsp_implementations()
  -- local opts = require("telescope.themes").get_ivy()
  local opts = themes.get_dropdown({
    layout_strategy = "vertical",
    preview_title = "",
    layout_config = {
      mirror = true,
      prompt_position = "top",
      height = 0.8,

      width = function(_, max_columns, _)
        return math.min(120, math.floor(max_columns * 0.6)) -- 60% of screen width, max 80 columns
      end,
    },
  })
  return builtin.lsp_implementations(opts)
end

function M.buffers()
  local opts = themes.get_ivy({
    preview_title = "",
  })
  opts.sort_mru = true
  opts.sort_lastused = true
  return builtin.buffers(opts)
end

---@function get_git root searches for the git root directory
---@return string|nil
local function get_git_root(path)
  local git_dir = vim.fs.find('.git', {
    path = path or vim.fn.expand("%:p:h"),
    upward = true,
    type = 'directory',
  })[1]
  if git_dir then
    return vim.fs.dirname(git_dir)
  end
end

local function diplay(dirname, filename)
  if #dirname > 0 then dirname = dirname .. "/" end
  local display = entry_display.create({
    separator = "",
    items = {
      { width = #dirname }, -- dirname
      { remaining = true }, -- filename
    },
  })
  return display({
    { dirname,  "TelescopeResultsComment" },
    { filename, "TelescopeResultsIdentifier" },
  })
end

local function home_path_display(opts, path)
  path = vim.fs.abspath(path)
  local dirname, filename = vim.fs.dirname(path), vim.fs.basename(path)
  local this_file = vim.api.nvim_buf_get_name(opts.bufnr or 0)
  local this_dir = vim.fs.dirname(this_file)

  if this_dir == dirname then
    dirname = ""
  else
    ---@diagnostic disable-next-line: undefined-field
    local home = vim.loop.os_homedir()
    dirname = "~/" .. vim.fs.relpath(home, dirname)
  end

  return diplay(dirname, filename)
end

local function cwd_path_display(opts, path)
  if not opts.cwd then
    return home_path_display(opts, path)
  end

  path = vim.fs.abspath(path)
  local dirname, filename = vim.fs.dirname(path), vim.fs.basename(path)
  dirname = vim.fs.relpath(opts.cwd, dirname) or vim.fs.abspath(dirname)

  return diplay(dirname, filename)
end

function M.list_project_files()
  local opts = themes.get_ivy({
    preview_title = "",
  })
  local cwd = vim.fn.expand("%:p:d")
  cwd = cwd:gsub("^oil://", "") -- remove oil:// prefix if present
  opts.cwd = get_git_root(cwd) or cwd
  print("Using cwd: " .. opts.cwd)
  opts.find_command = {
    "fd",
    "--type=f",
    "--exclude='.git'",
    "--hidden",
    "--color=never",
  }
  opts.hidden = false
  opts.path_display = cwd_path_display
  return builtin.find_files(opts)
end

function M.lsp_goto_definition()
  local opts = require("telescope.themes").get_ivy()
  opts.show_line = false
  return require("telescope.builtin").lsp_definitions(opts)
end

function M.path_display(opts, path)
  return home_path_display(opts, path)
end

return M
