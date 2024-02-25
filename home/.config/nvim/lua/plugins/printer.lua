return {
  "weirdgiraffe/printer.nvim",
  dependencies = {
    "weirdgiraffe/plenary.nvim",
  },
  enabled = false,
  dev = true,
  lazy = false,
  config = function()
    require("printer").setup({})
  end,
}
