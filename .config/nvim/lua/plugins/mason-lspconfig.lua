-- mason is needed to automatically install LSP servers
return {
  "mason-org/mason-lspconfig.nvim",
  lazy = false,
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "neovim/nvim-lspconfig",
  },
  opts = {
    ensure_installed = {
      "bashls",
      "docker_language_server",
      "docker_compose_language_service",
      "gopls",
      "lua_ls",
      "yamlls",
    },
  }
}
