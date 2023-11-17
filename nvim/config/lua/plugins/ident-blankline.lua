return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = "BufWinEnter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter"
  },
  config = function()
    local hooks = require("ibl.hooks")

    -- disable indendation of the first level
    hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
    hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_tab_indent_level)

    require("ibl").setup {
      indent = {
        char = "┊",
      },
      scope = {
        enabled = true,
        show_start = false,
        show_end = false,
        show_exact_scope = true,
        char = "▎",
        highlight = "SpecialComment",
      },
    }
  end,
}
