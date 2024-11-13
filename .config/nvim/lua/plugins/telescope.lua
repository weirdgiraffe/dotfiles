local Path = require("plenary.path")
local utils = require("utils")

local function path_filename_first(path)
  local sep = Path.path.sep
  local dirs = vim.split(path, sep)
  local filename = dirs[#dirs]

  -- typical file path which I expect is something like:
  --  - .../github.com/username/...
  --  - .../gitlab.com/username/...
  -- so I will just start from it
  for i = 1, #dirs do
    if dirs[i] == "github.com" or dirs[i] == "gitlab.com" then
      for j = 1, i do
        table.remove(dirs, 1)
      end
    end
  end

  local tail = table.concat(dirs, sep)
  -- Trim prevents a top-level filename to have a trailing white space
  local transformed_path = vim.trim(filename .. " " .. tail)
  local path_style = { { { #filename, #transformed_path }, "TelescopeResultsComment" } }
  return transformed_path, path_style
end



return {
  "nvim-telescope/telescope.nvim",
  tag = '0.1.8',
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
        path_display = function(opts, path)
          return path_filename_first(path)
        end,
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
