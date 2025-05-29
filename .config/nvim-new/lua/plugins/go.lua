local stdpath = require("config.stdpath")
return {
  "weirdgiraffe/go.nvim",
  ft = { "go", "gomod", "gowork", "gotmpl" },
  dependencies = {
    -- I don't like guihua because its ugly
    -- "ray-x/guihua.lua",
    "nvim-tree/nvim-web-devicons",
  },
  build = function() require("go.install").install_all_sync() end,
  opts = {
    log_path            = stdpath.log .. "/go.nvim.log",
    lsp_cfg             = true,
    lsp_keymaps         = false,            -- disable default lsp keymaps
    lsp_inlay_hints     = { enable = false },
    tag_transform       = "camelcase",      -- check -transform of gomodifytags
    tag_options         = 'json=omitempty', -- check -add-options of gomodifytags
    comment_placeholder = "",               -- placeholder for require("go.comment").gen()
    trouble             = false,
  },
}
