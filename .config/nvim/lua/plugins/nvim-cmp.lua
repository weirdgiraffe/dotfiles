-- some example configs:
--
--  https://github.com/dreamsofcode-io/dotfiles/blob/main/.config/nvim/lua/plugins/configs/cmp.lua
--  https://github.com/linkarzu/dotfiles-latest/blob/main/neovim/neobean/lua/plugins/nvim-cmp.lua
--  https://github.com/omerxx/dotfiles/blob/master/nvim/lua/plugins/cmp.lua
--  https://github.com/tjdevries/config.nvim/blob/master/lua/custom/completion.lua
--

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

  local floors = {}
  return function(entry, item)
    -- Get the width of the current window.
    local win_width = vim.api.nvim_win_get_width(0)
    -- Set the max content to a percentage of the window width, in this case 20%.
    local max_content_width = floors[win_width]
    if not max_content_width then
      max_content_width = math.floor(win_width * 0.2)
      floors[win_width] = max_content_width
    end
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
  lazy = false,
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
        elseif vim.api.nvim_buf_get_option(0, 'buftype') ~= 'prompt' and has_words_before() then
          cmp.complete()
        else
          local info = debug.getinfo(fallback)
          local msg = string.format("cmp: fallback to %s:%d", info.source, info.linedefined)
          vim.notify(msg)
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
      --  I would like the following keymapping for my completions:
      --
      --  - <Tab> starts the completion
      --  - <C-n> next item
      --  - <C-p> previous item
      --  - <C-j> scroll down the documentation
      --  - <C-k> scroll up the documentation
      --  - <C-y> go to the next snippet placeholder
      --  - <C-y>p go to the previous snippet placeholder
      --
      --  This setup should not interfere with the default keybinding
      --  of the copilot and may work way better for me.
      mapping = cmp.mapping.preset.insert({
        -- ["<Tab>"] = actions.select_next,
        -- ['<C-n>'] = actions.select_next,
        ["<Tab>"] = actions.select_next,
        ['<C-n>'] = actions.select_next,

        ["<S-Tab>"] = actions.select_prev,
        ['<C-p>'] = actions.select_prev,

        ['<C-k>'] = cmp.mapping.scroll_docs(-4),
        ['<C-j>'] = cmp.mapping.scroll_docs(4),

        ['<C-e>'] = cmp.mapping.abort(),
        ['<cr>'] = cmp.mapping.confirm({ select = true }), -- pick a selected entry only
      }),
      sources = cmp.config.sources({
        { name = 'luasnip' },
        { name = 'nvim_lsp',  keyword_length = 2 },
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
