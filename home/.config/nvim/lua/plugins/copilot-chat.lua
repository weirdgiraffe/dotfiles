return {
  "weirdgiraffe/copilot-chat.nvim",
  dependencies = {
    "weirdgiraffe/plenary.nvim",
  },
  enable = true,
  dev = true,
  lazy = false,
  config = function()
    require("copilot-chat").setup({})
  end,
}
