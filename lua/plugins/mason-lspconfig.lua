-- mason is needed to automatically install LSP servers
return {
  {
    "mason-org/mason.nvim",
    config = function()
      require("mason").setup({})
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    lazy = false,
    config = function()
      require("mason-lspconfig").setup({})
    end,
  },
}
