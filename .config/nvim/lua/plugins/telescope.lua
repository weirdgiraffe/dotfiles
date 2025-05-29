return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    'nvim-telescope/telescope-ui-select.nvim',
    'nvim-lua/plenary.nvim',
  },
  config = function()
    local telescope = require("telescope")
    local custom = require("customize.telescope")
    local actions = require("telescope.actions")
    telescope.setup({
      defaults = {
        path_display = custom.path_display,
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
