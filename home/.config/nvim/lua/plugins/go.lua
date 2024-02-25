return {
  {
    "weirdgiraffe/go.nvim",
    enabled = true,
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
      "williamboman/mason.nvim",
    },
    ft = { "go", "gomod" },
    event = { "CmdlineEnter" },
    build = function()
      require("go.install").install_all_sync()
    end,
    config = function()
      require("go").setup({
        -- this plugin has a weird default log path, so fix it
        log_path = vim.fn.stdpath('cache') .. "/gonvim.log",
        verbose = true,
        lsp_cfg = true,
        lsp_keymaps = false,            -- disable default lsp keymaps, we have our own in user.lsp
        lsp_document_formatting = true, -- just configure lsp capability
        lsp_codelens = true,
        lsp_inlay_hints = { enable = true, },
        textobjects = false, -- do not use theirs definition

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
