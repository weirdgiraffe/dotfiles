return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  lazy = false,
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require("nvim-treesitter.configs").setup({
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,   -- whether to set jumps in the jumplist

          goto_previous_start = { ["[["] = "@function.outer" },
          goto_next_end = { ["]]"] = "@function.outer" },

          goto_next_start = { ["}}"] = "@function.outer" },
          goto_previous_end = { ["{{"] = "@function.outer" },
        },
      },
    })
  end,
}
