return {
  "j-hui/fidget.nvim",
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
  },
}
