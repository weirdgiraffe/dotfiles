return {
  "j-hui/fidget.nvim",
  version = "1.3.0",
  event = "LspAttach",
  opts = {
    progress = {
      display = {
        progress_icon = {
          pattern = "meter",
          period = 1,
        },
      },
    },
    notification = {
      -- make background of popup notifications transparent
      window = { winblend = 0, },
    },
  },
}
