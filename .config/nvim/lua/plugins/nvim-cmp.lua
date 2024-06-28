local function has_words_before()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- limited width completion formatting inspired by
-- https://github.com/hrsh7th/nvim-cmp/discussions/609#discussioncomment-5727678
local function make_formatting_function()
  local lspkind_format = require("lspkind").cmp_format({
    maxwidth = 50,
    ellipsis_char = "...",
  })

  return function(entry, item)
    -- Get the width of the current window.
    local win_width = vim.api.nvim_win_get_width(0)
    -- Set the max content to a percentage of the window width, in this case 20%.
    local max_content_width = math.floor(win_width * 0.2)
    -- Truncate the completion entry text if it's longer than the
    -- max content width. We subtract 3 from the max content width
    -- to account for the "..." that will be appended to it.
    local content = item.abbr
    if #content > max_content_width then
      item.abbr = vim.fn.strcharpart(content, 0, max_content_width - 3) .. "..."
    else
      item.abbr = content .. (" "):rep(max_content_width - #content)
    end
    return lspkind_format(entry, item)
  end
end

return {
  'hrsh7th/nvim-cmp',
  event = "BufWinEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "FelipeLema/cmp-async-path",
    "hrsh7th/cmp-cmdline",
    "onsails/lspkind.nvim",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip"
  },
  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')

    local actions = {
      --- select next should select next completion item of jump to the next snippet parameter
      select_next = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          vim.print("has words before: trigger completion")
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),

      select_prev = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    }

    ---@diagnostic disable-next-line: missing-fields
    cmp.setup({
      enabled = true,
      ---@diagnostic disable-next-line: missing-fields
      completion = {
        autocomplete = false,
        completeopt = "menu,menuone,preview,noselect",
      },
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = actions.select_next,
        ['<C-n>'] = actions.select_next,

        ["<S-Tab>"] = actions.select_prev,
        ['<C-p>'] = actions.select_prev,

        ['<C-k>'] = cmp.mapping.scroll_docs(-4),
        ['<C-j>'] = cmp.mapping.scroll_docs(4),

        ['<C-e>'] = cmp.mapping.abort(),
        ['<cr>'] = cmp.mapping.confirm(), -- pick a selected entry only
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp',  keyword_length = 3 },
        { name = 'luasnip',   keyword_length = 2 },
        { name = 'async_path' },
      }, {
        { name = 'buffer', keyword_length = 3 },
      }),
      -- the only working option having multiple sources
      preselect = cmp.PreselectMode.None,

      ---@diagnostic disable-next-line: missing-fields
      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = make_formatting_function(),
      },
    })
  end
}
