local function with_default_options(default_opts)
  return {
    setup = function(server_name, opts)
      opts = vim.tbl_extend("force", default_opts, opts or {})
      local msg = string.format("[%s].opts=%s\n", server_name, vim.inspect(opts))
      vim.print(msg)
      local lspconfig = require("lspconfig")
      lspconfig[server_name].setup(opts)
    end
  }
end


return {
  "williamboman/mason.nvim",
  lazy = false,
  build = function()
    pcall(vim.cmd, "MasonUpdate")
  end,
  dependencies = {
    "folke/neodev.nvim",
    "neovim/nvim-lspconfig",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    require("mason").setup()
    local lspconfig = require("lspconfig")
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "gopls",
        "rust_analyzer",
        "yamlls",
      },
      handlers = {
        -- The first entry (without a key) will be the default handler
        -- and will be called for each installed server that doesn't have
        -- a dedicated handler.
        function(server_name) -- default handler (optional)
          lspconfig[server_name].setup({
            on_attach = require('user.lsp').on_attach,
            capabilities = capabilities,
          })
        end,
        ["lua_ls"] = function()
          require("neodev").setup()
          lspconfig.lua_ls.setup({
            on_attach = require('user.lsp').on_attach,
            settings = {
              Lua = {
                workspace = {
                  -- diable annoying message about lua environment
                  checkThirdParty = false,
                },
              },
            },
          })
        end,
        ["rust_analyzer"] = function()
          lspconfig.rust_analyzer.setup({
            on_attach = require('user.lsp').on_attach,
            settings = {
              ["rust-analyzer"] = {
                checkOnSave = {
                  command = "clippy-driver",
                },
              }
            }
          })
        end
      },
    })
    require("mason.api.command").MasonInstall({
      "yamlfmt",
      --"rustfmt",
    })
  end,
}
