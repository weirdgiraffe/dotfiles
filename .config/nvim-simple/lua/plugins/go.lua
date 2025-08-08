local stdpath = require("config.stdpath")
return {
  "ray-x/go.nvim",
  main = "go",
  ft = { "go", "gomod", "gowork", "gotmpl" },
  event = { "CmdlineEnter" },
  dependencies = {
    -- I don't like guihua because its ugly "ray-x/guihua.lua",
    "neovim/nvim-lspconfig",
    "nvim-tree/nvim-web-devicons",
  },
  build = ':lua require("go.install").update_all_sync()',
  opts = {
    log_path            = stdpath.log .. "/go.nvim.log",
    lsp_cfg             = true,
    lsp_keymaps         = false,            -- disable default lsp keymaps
    lsp_inlay_hints     = { enable = false },
    tag_transform       = "snakecase",      -- check -transform of gomodifytags
    tag_options         = 'json=omitempty', -- check -add-options of gomodifytags
    comment_placeholder = "",               -- placeholder for require("go.comment").gen()
    trouble             = false,
  }
}
