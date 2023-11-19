return {
  {
    "weirdgiraffe/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/cmp-nvim-lsp",
    },
    ft = {
      "go",
      "gomod",
      "gosum",
      "gotmpl",
      "gohtmltmpl",
      "gotexttmp",
    },
    build = function()
      require("go.install").install_all()
    end,
    config = function()
      require("go").setup({
        verbose = false,
        -- this plugin has a weird default log path, so fix it
        log_path = vim.fn.stdpath('cache') .. "/gonvim.log",
        lsp_cfg = {
          capabilities = require('cmp_nvim_lsp').default_capabilities(),
        },
        lsp_keymaps = false,            -- disable default lsp keymaps, we have our own in user.lsp
        lsp_document_formatting = true, -- just configure lsp capability
        lsp_codelens = true,
        lsp_inlay_hints = { enable = true, },
        textobjects = false, -- do not use theirs definition

        -- call our common lsp handler afer go.nvim default handler
        lsp_on_client_start = function(client, bufnr)
          require("user.lsp").on_attach(client, bufnr)
        end,

        gofmt = 'gofumpt',
        -- max line length in golines format
        max_line_len = 120,
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
    end
  }
}
