-- pure lua replacement of github/copilot.vim
return {
  "zbirenbaum/copilot.lua",
  event = "InsertEnter", -- check available events: https://neovim.io/doc/user/autocmd.html#autocmd-events
  config = function()
    require("copilot").setup({
      panel = { enabled = false },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = "<C-l>",
          accept_word = false,
          accept_line = false,
          next = "<C-j>",
          prev = "<C-k>",
          dismiss = "<C-h>",
        },
      },
      filetypes = {
        gotexttmpl = false,
        kitty = false,
        markdown = false,
        yaml = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
      },
    })
  end
}
