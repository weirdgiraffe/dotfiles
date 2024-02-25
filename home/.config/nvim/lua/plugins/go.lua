return {
  {
    "ray-x/go.nvim",
    enabled = true,
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
    },
    ft = { "go", "gomod" },
    event = { "CmdlineEnter" },
    build = function() require("go.install").install_all_sync() end,
  }
}
