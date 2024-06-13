return {
  "LunarVim/bigfile.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    filesize = 1,                    -- size of the file in MiB, the plugin round file sizes to the closest MiB
    pattern = { "*.json", "*.csv" }, -- autocmd pattern or function see <### Overriding the detection of big files>
    features = {                     -- features to disable
      "indent_blankline",
      "illuminate",
      "lsp",
      "treesitter",
      "syntax",
      "matchparen",
      "vimopts",
      "filetype",
    },
  }
}
