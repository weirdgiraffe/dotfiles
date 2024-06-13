return {
  'stevearc/aerial.nvim',
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons"
  },
  config = function()
    require("aerial").setup({
      backends = { "treesitter", "lsp", "markdown", "asciidoc", "man" },
      layout = {
        -- These control the width of the aerial window.
        -- They can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        -- min_width and max_width can be a list of mixed types.
        -- max_width = {40, 0.2} means "the lesser of 40 columns or 20% of total"
        max_width = { 40, 0.3 },
        min_width = 10,
        -- When the symbols change, resize the aerial window (within min/max constraints) to fit
        resize_to_content = true,
      },
    })
  end,
}
