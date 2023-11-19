return {
  "zbirenbaum/copilot.lua",
  -- pure lua replacement of github/copilot.vim
  event = "InsertEnter",   -- check available events: https://neovim.io/doc/user/autocmd.html#autocmd-events
  config = function()
    require("copilot").setup({
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = "<M-l>",
          accept_word = false,
          accept_line = false,
          next = "<M-j>",
          prev = "<M-k>",
          dismiss = "<M-h>",
        },
      },
    })
  end
}
