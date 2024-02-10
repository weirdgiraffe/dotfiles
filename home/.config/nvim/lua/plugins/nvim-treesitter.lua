return {
  "nvim-treesitter/nvim-treesitter",
  lazy   = false,
  build  = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "go",
        "gomod",
        "gosum",
        "gowork",
        "html",
        "json",
        "jq",
        "lua",
        "luadoc",
        "make",
        "markdown",
        "markdown_inline",
        "dockerfile",
        "vim",
        "vimdoc",
        "sql",
        "python",
        "bash",
        "rust",
      },
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}
