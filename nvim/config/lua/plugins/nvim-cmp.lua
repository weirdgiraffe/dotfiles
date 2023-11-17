return {
  'hrsh7th/nvim-cmp',
  event = "BufWinEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/vim-vsnip",
    "hrsh7th/cmp-vsnip",
    "hrsh7th/cmp-buffer",
    "onsails/lspkind.nvim",
    "hrsh7th/cmp-nvim-lsp-signature-help",
  },
  config = function()
    local cmp = require('cmp')

    cmp.setup({
      snippet = {
        expand = function(args)
          vim.fn["vsnip#anonymous"](args.body)
        end,
      },
      window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' }, -- For vsnip users.
        -- { name = 'luasnip' }, -- For luasnip users.
        -- { name = 'ultisnips' }, -- For ultisnips users.
        -- { name = 'snippy' }, -- For snippy users.
      }, {
        { name = 'buffer' },
      })
    })
  end
}
