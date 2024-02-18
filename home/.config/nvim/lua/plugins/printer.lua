return {
  "weirdgiraffe/printer.nvim",
  dependencies = {
    "weirdgiraffe/plenary.nvim",
  },
  enable = true,
  dev = true,
  lazy = false,
  config = function()
    require("printer").setup({})
  end,
}
