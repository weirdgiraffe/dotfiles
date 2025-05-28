local Path = require("plenary.path")


local function split_path(path)
  local filename = vim.fn.fnamemodify(path, ":t")
  local dirname = vim.fn.fnamemodify(path, ":h")
  return dirname, filename
  --[[
  local sep = Path.path.sep
  local components = vim.split(path, sep)
  local filename = components[#components]
  local dirname = ""
  for i = 1, #components - 1 do
    if i ~= 1 then dirname = dirname .. sep end
    dirname = dirname .. components[i]
  end
  return dirname, filename
  --]]
end

local function nice_path(absolute_path)
  ---@diagnostic disable-next-line: undefined-field
  local home = vim.loop.os_homedir()
  if vim.startswith(absolute_path, home) then
    return "~/" .. Path:new(absolute_path):make_relative(home)
  end
  return absolute_path
end

local function nice_path_display(opts, path)
  path = Path.new(path):absolute()
  local dirname, filename = split_path(path)
  local this_file = vim.api.nvim_buf_get_name(opts.bufnr or 0)
  local this_dir = vim.fn.fnamemodify(this_file, ":h")

  if this_file == path or this_dir == dirname then
    dirname = ""
  else
    dirname = nice_path(dirname) .. Path.path.sep
  end

  local display = require("telescope.pickers.entry_display").create({
    separator = "",
    items = {
      { width = #dirname }, -- dirname + "/"
      { remaining = true }, -- filename
    },
  })
  return display({
    { dirname,  "TelescopeResultsComment" },
    { filename, "TelescopeResultsIdentifier" },
  })
end



return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    'nvim-telescope/telescope-ui-select.nvim',
    'nvim-lua/plenary.nvim',
  },
  config = function()
    local actions = require "telescope.actions"
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    telescope.setup({
      defaults = {
        path_display = nice_path_display,
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-n>"] = actions.move_selection_next,
            ["<C-p>"] = actions.move_selection_previous,
          }
        }
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_ivy()
        },
      },
      attach_mappings = function(_, map)
        map({ "n", "i", "c", "x" }, "<c-n>", actions.move_selection_next)
        map({ "n", "i", "c", "x" }, "<c-p>", actions.move_selection_previous)
      end,
    })
    require("telescope").load_extension("ui-select")
  end,
}
