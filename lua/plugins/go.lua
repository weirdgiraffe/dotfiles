return {
  "ray-x/go.nvim",
  ft = { "go", "gomod", "gowork", "gotmpl" },
  dependencies = {
    "ray-x/guihua.lua",
    "nvim-tree/nvim-web-devicons",
  },
  build = function() require("go.install").install_all_sync() end,
  opts = {
    log_path = require("stdpath").state .. "/go.nvim.log",
    lsp_cfg = false,                -- lsp will get configured exteranlly
    lsp_keymaps = false,            -- disable default lsp keymaps
    lsp_inlay_hints = { enable = false, },
    tag_transform = "camelcase",    -- check -transform of gomodifytags
    tag_options = 'json=omitempty', -- check -add-options of gomodifytags
    comment_placeholder = "",       -- placeholder for require("go.comment").gen()
    trouble = false,
  },
}
