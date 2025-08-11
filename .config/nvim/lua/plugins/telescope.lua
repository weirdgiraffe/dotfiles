return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    'nvim-telescope/telescope-ui-select.nvim',
    'nvim-lua/plenary.nvim',
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    telescope.setup({
      defaults = {
        dynamic_preview_title = true,
        path_display = require("custom.telescope.display").relpath_display,
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
    telescope.load_extension("ui-select")
  end,
}
