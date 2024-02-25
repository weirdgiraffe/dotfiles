return {
  "weirdgiraffe/copilot-chat.nvim",
  dependencies = {
    "weirdgiraffe/plenary.nvim",
  },
  enabled = false,
  dev = true,
  config = function()
    require("copilot-chat").setup({})
  end,
}
