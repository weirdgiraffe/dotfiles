return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  build = function()
    pcall(require('nvim-treesitter.install').update { with_sync = true })
  end,
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require("nvim-treesitter.configs").setup({
      -- A list of parser names, or "all"
      ensure_installed = {
        "c", "lua", "vim", "vimdoc", "query",
        "go", "gomod", "gosum", "gowork",
        "html", "json", "jq",
        "luadoc",
        "markdown", "markdown_inline",
        "dockerfile",
        "sql",
        "python",
        "bash",
        "rust",
      },
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on "syntax" being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = { "markdown" },
      },
      indent = {
        enable = true,
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
            ['ii'] = '@conditional.inner',
            ['ai'] = '@conditional.outer',
            ['il'] = '@loop.inner',
            ['al'] = '@loop.outer',
            ['at'] = '@comment.outer',
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            [']f'] = '@function.outer',
            [']]'] = '@class.outer',
          },
          goto_next_end = {
            [']F'] = '@function.outer',
            [']['] = '@class.outer',
          },
          goto_previous_start = {
            ['[f'] = '@function.outer',
            ['[['] = '@class.outer',
          },
          goto_previous_end = {
            ['[F'] = '@function.outer',
            ['[]'] = '@class.outer',
          },
        },
      },
    })
  end
}
