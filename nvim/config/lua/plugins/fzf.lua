return {
  -- NOTE: needs ripgrep
  -- NOTE: needs fd
  "ibhagwan/fzf-lua",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    fzf_opts = {
      ["--color"] = require("user.colors").fzf(),
    },
  }
}
