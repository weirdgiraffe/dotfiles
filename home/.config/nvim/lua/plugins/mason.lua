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
    require("mason-lspconfig").setup_handlers({
      function(server_name) -- default handler (optional)
        require("lspconfig")[server_name].setup {}
      end,
      ["lua_ls"] = function()
        require("neodev").setup()
        require("lspconfig")["lua_ls"].setup({
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
      end,
      ["rust_analyzer"] = function()
        require("lspconfig")["rust_analyzer"].setup({
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = {
                command = "clippy-driver",
              },
            }
          }
        })
      end,
      ["gopls"] = function()
        require("go").setup({
          log_path = vim.fn.stdpath('cache') .. "/gonvim.log", -- this plugin has a weird default log path, so fix it
          lsp_cfg = false,
          lsp_keymaps = false,                                 -- disable default lsp keymaps, we have our own in user.lsp
          lsp_codelens = true,
          lsp_document_formatting = true,
          lsp_inlay_hints = { enable = true, },
          textobjects = false, -- do not use theirs definitions
          gofmt = 'gofumpt',
          max_line_len = 120,  -- max line length in golines format
          -- [snakecase, camelcase, lispcase, pascalcase, titlecase, keep]
          -- check -transform of gomodifytags
          tag_transform = "snakecase",
          -- check -add-options of gomodifytags
          tag_options = 'json=omitempty',
          -- placeholder for require("go.comment").gen()
          comment_placeholder = "",
          run_in_floaterm = false,
          trouble = true,
        })
        local config = require('go.lsp').config()
        local capabilities = require("cmp_nvim_lsp").default_capabilities(config.capabilities)
        config.capabilities = capabilities
        require("lspconfig")["gopls"].setup(config)
      end,
    })


    local to_install = {}
    if vim.fn.executable('yamlfmt') == 0 then
      table.insert(to_install, "yamlfmt")
    end
    if #to_install > 0 then
      require("mason.api.command").MasonInstall(to_install)
    end
  end,
}
