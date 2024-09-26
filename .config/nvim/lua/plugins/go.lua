return {
  "weirdgiraffe/go.nvim",
  dir = "~/code/github.com/weirdgiraffe/go.nvim",
  dependencies = {
    "ray-x/guihua.lua",
    "folke/trouble.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  ft = { "go, gomod, gowork, gotmpl" },
  build = function() require("go.install").install_all_sync() end,
  opts = {
    log_path = vim.fn.stdpath('cache') .. "/go.nvim.log", -- this plugin has a weird default log path, so fix it
    lsp_cfg = false,                                      -- use go.nvim specific convig for gopls
    lsp_keymaps = false,                                  -- disable default lsp keymaps
    lsp_inlay_hints = {
      enable = false,                                     -- inlay hints are always toggling on save, so it's quite annoying
    },
    tag_transform = "camelcase",                          -- check -transform of gomodifytags
    tag_options = 'json=omitempty',                       -- check -add-options of gomodifytags
    comment_placeholder = "",                             -- placeholder for require("go.comment").gen()
    trouble = true,                                       -- true: use trouble to open quickfix
  },
}
