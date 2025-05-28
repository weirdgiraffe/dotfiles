local entry_display = require("telescope.pickers.entry_display")
local make_entry = require("telescope.make_entry")

local M = {}

local symbols_sorter = function(symbols)
  if vim.tbl_isempty(symbols) then
    return symbols
  end

  local current_buf = vim.api.nvim_get_current_buf()

  -- sort adequately for workspace symbols
  local filename_to_bufnr = {}
  for _, symbol in ipairs(symbols) do
    if filename_to_bufnr[symbol.filename] == nil then
      filename_to_bufnr[symbol.filename] = vim.uri_to_bufnr(vim.uri_from_fname(symbol.filename))
    end
    symbol.bufnr = filename_to_bufnr[symbol.filename]
  end

  table.sort(symbols, function(a, b)
    if a.bufnr == b.bufnr then
      return a.lnum < b.lnum
    end
    if a.bufnr == current_buf then
      return true
    end
    if b.bufnr == current_buf then
      return false
    end
    return a.bufnr < b.bufnr
  end)

  return symbols
end


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

--- gen_entries_from_lsp_symbols will generate lsp symbols with a slightly
--- different layout. It will display SymbolType first and it will add an
--- additional indentation to the Field symbols to make it easier to
--- comprehend.
---@param opts any supported: opts.symbol_width, opts.symbol_highlights
function M.gen_entries_from_lsp_symbols(opts)
  opts = opts or {}

  local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()

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
  local opts = require("telescope.themes").get_ivy()
  opts.symbol_width = 8
  opts.entry_maker = require("customize.telescope").gen_entries_from_lsp_symbols(opts)
  return require("telescope.builtin").lsp_document_symbols(opts)
end

function M.lsp_references()
  -- local opts = require("telescope.themes").get_ivy()
  local opts = require("telescope.themes").get_dropdown({
    layout_strategy = "vertical",
    preview_title = "",
    layout_config = {
      mirror = true,
      prompt_position = "top",
      height = 0.8,

      width = function(_, max_columns, _)
        local computed = math.min(120, math.floor(max_columns * 0.6)) -- 60% of screen width, max 80 columns
        vim.print("computed=" .. computed)
        return computed
      end,
    },
  })
  opts.include_current_line = true
  return require("telescope.builtin").lsp_references(opts)
end

function M.lsp_implementations()
  -- local opts = require("telescope.themes").get_ivy()
  local opts = require("telescope.themes").get_dropdown({
    layout_strategy = "vertical",
    preview_title = "",
    layout_config = {
      mirror = true,
      prompt_position = "top",
      height = 0.8,

      width = function(_, max_columns, _)
        local computed = math.min(120, math.floor(max_columns * 0.6)) -- 60% of screen width, max 80 columns
        vim.print("computed=" .. computed)
        return computed
      end,
    },
  })
  opts.include_current_line = true
  return require("telescope.builtin").lsp_implementations(opts)
end

function M.buffers()
  local opts = require("telescope.themes").get_ivy({
    preview_title = "",
  })
  opts.sort_mru = true
  opts.sort_lastused = true
  return require("telescope.builtin").buffers(opts)
end

return M
