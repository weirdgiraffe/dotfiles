-- mason is needed to automatically install LSP servers
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "folke/neodev.nvim",
  },
  config = function()
    require("neodev").setup({})
    require("mason").setup({})
    require("mason-lspconfig").setup({
      -- install lsp servers configured via lspconfig automatically.
      -- servers should be configured in giraffe/lsp.lua
      automatic_enable = true
    })
  end,
}
