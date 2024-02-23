local function with_defaults(defaults)
  defaults = defaults or function() return {} end
  local configs = {}
  return {
    extend = function(server_configs)
      if type(server_configs) == "table" then
        for server_name, config in pairs(server_configs) do
          if type(config) == "function" then
            configs[server_name] = config
          else
            vim.notify(string.format(
                "[%s]: invalid config (must be a function): %s\n",
                server_name,
                vim.inspect(config)),
              vim.log.levels.WARN,
              {})
          end
        end
      end
    end,
    setup_server = function(name)
      local lspconfig = require("lspconfig")

      local default_opts = defaults() or {}
      local server_opts = configs[name] and configs[name]() or {}
      local opts = vim.tbl_extend("force", default_opts, server_opts)
      vim.print("setting up the server using mason:" .. name)

      -- check if we have any of the previous settings
      local prev = lspconfig[name]
      if prev ~= nil then
        vim.print("has previous settings for: " .. name)
        vim.print(vim.inspect(prev))
        if prev.on_attach then
          local on_attach = opts.on_attach
          vim.print("wrapping pevious: " .. vim.inspect(on_attach))
          opts.on_attach = function(client, bufnr)
            prev.on_attach(client, bufnr)
            on_attach(client, bufnr)
          end
        end
      end

      require("lspconfig")[name].setup(opts)
    end
  }
end

return {
  "williamboman/mason.nvim",
  lazy = false,
  build = function()
    ---@diagnostic disable-next-line: param-type-mismatch
    pcall(vim.cmd, "MasonUpdate")
  end,
  dependencies = {
    "folke/neodev.nvim",
    "neovim/nvim-lspconfig",
    "williamboman/mason-lspconfig.nvim",
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
    local lspconfig = with_defaults(function()
      return {
        on_attach = require('user.lsp').on_attach,
        capabilities = require('cmp_nvim_lsp').default_capabilities()
      }
    end)
    lspconfig.extend({
      ["lua_ls"] = function()
        require("neodev").setup()
        return {
          on_attach = require('user.lsp').on_attach,
          settings = {
            Lua = {
              workspace = {
                -- diable annoying message about lua environment
                checkThirdParty = false,
              },
            },
          },
        }
      end,
      ["rust_analyzer"] = function()
        return {
          on_attach = require('user.lsp').on_attach,
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = {
                command = "clippy-driver",
              },
            }
          }
        }
      end
    })
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "gopls",
        "yamlls",
        "rust_analyzer",
      },
      handlers = {
        -- The first entry (without a key) will be the default handler
        -- and will be called for each installed server that doesn't have
        -- a dedicated handler.
        lspconfig.setup_server
      },
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
