return {
  -- NOTE: needs ripgrep
  -- NOTE: needs fd
  "ibhagwan/fzf-lua",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "rose-pine/neovim",
  },
  opts = {
    fzf_opts = {
      ["--color"] = require("user.colors").fzf(),
    },
  }
}
