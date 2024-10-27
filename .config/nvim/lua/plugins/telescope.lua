return {
  "nvim-telescope/telescope.nvim",
  tag = '0.1.8',
  dependencies = {
    'nvim-telescope/telescope-ui-select.nvim',
    'nvim-lua/plenary.nvim',
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({
      defaults = {
        path_display = { "smart" },
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_ivy()
        },
      }
    })
    require("telescope").load_extension("ui-select")
  end,
}
