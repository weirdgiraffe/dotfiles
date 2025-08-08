return {
  'saghen/blink.cmp',
  version = '1.*',
  lazy = false,
  enabled = true,
  dependencies = {
    { "L3MON4D3/LuaSnip" },
  },
  opts = {
    keymap = {
      preset = 'none',
      ["<C-n>"] = { -- show completions or move to the next one
        'show',
        'select_next',
        'fallback',
      },
      ["<C-p>"] = { -- show completions or move to the next one
        'select_prev',
        'fallback',
      },
      ["<C-l>"] = { -- accept the completion
        'accept',
        'fallback'
      },
      ["<CR>"] = { -- accept the completion
        'accept',
        'fallback'
      },
    },
    appearance = {
      nerd_font_variant = 'normal',
    },
    cmdline = { enabled = false },
    completion = {
      trigger = {
        show_on_insert = false,
        show_on_keyword = false,
        show_on_trigger_character = false,
      },
      accept = { auto_brackets = { enabled = false } },
      list = { selection = { preselect = false, auto_insert = true } },
      ghost_text = { enabled = true },
      documentation = { auto_show = true },
      menu = {
        auto_show = false,
        draw = {
          columns = {
            { "label",     "label_description", gap = 1 },
            { "kind_icon", "kind" }
          },
        },
      },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    -- Use a preset for snippets, check the snippets documentation for more information
    snippets = { preset = 'luasnip' },
    -- Experimental signature help support
    signature = { enabled = true }
  }
}
