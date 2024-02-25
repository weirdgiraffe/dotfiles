return {
  "williamboman/mason.nvim",
  priority = 999,
  lazy = false,
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    "hrsh7th/cmp-nvim-lsp",
    "folke/neodev.nvim",
    "weirdgiraffe/go.nvim",
  },
  config = function()
    require("mason").setup({
      ui = {
        icons = {
          package_installed = "",
          package_pending = "",
          package_uninstalled = "",
        },
      }
    })

    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "gopls",
        "yamlls",
        "rust_analyzer",
      },
    })


    local lspconfig = require("lspconfig")
    require("neodev").setup()
    lspconfig["lua_ls"].setup({
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
      settings = {
        Lua = {
          workspace = {
            -- diable annoying message about lua environment
            checkThirdParty = false,
          },
        },
      },
    })

    lspconfig["rust_analyzer"].setup({
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
      settings = {
        ["rust-analyzer"] = {
          checkOnSave = {
            command = "clippy-driver",
          },
        }
      }
    })
    require("go").setup()

    local to_install = {}
    if vim.fn.executable('yamlfmt') == 0 then
      table.insert(to_install, "yamlfmt")
    end
    if #to_install > 0 then
      require("mason.api.command").MasonInstall(to_install)
    end
  end,
}
