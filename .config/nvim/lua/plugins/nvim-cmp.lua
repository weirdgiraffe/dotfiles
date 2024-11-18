-- some example configs:
--
--  https://github.com/dreamsofcode-io/dotfiles/blob/main/.config/nvim/lua/plugins/configs/cmp.lua
--  https://github.com/linkarzu/dotfiles-latest/blob/main/neovim/neobean/lua/plugins/nvim-cmp.lua
--  https://github.com/omerxx/dotfiles/blob/master/nvim/lua/plugins/cmp.lua
--  https://github.com/tjdevries/config.nvim/blob/master/lua/custom/completion.lua
--  https://github.com/Roundlay/nvim/blob/main/lua/plugins/lazy-cmp.lua
--

-- limited width completion formatting inspired by
-- https://github.com/hrsh7th/nvim-cmp/discussions/609#discussioncomment-5727678
local function make_format_function()
  local lspkind = require("lspkind")
  local impl = lspkind.cmp_format({
    mode = "symbol_text", -- show only symbol annotations
    maxwidth = {
      menu = 50,
      abbr = 50,
    },
    ellipsis_char = "...",
    show_labelDetails = true,
  })
  return function(entry, item)
    return impl(entry, item)
  end
end

return {
  'hrsh7th/nvim-cmp',
  event = "BufWinEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "onsails/lspkind.nvim",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip"
  },
  lazy = false,
  config = function()
    local cmp = require('cmp')

    local actions = {
      complete_or_select_next_item = cmp.mapping(function(fallback)
        if cmp.visible() then
          vim.notify("select_next: cmp visible: select_next_item")
          cmp.select_next_item()
        elseif vim.api.nvim_buf_get_option(0, 'buftype') ~= 'prompt' then
          vim.notify("select next: cmp not visible: complete")
          cmp.complete()
        else
          vim.notify("select_next: cmp not visible: fallback")
          fallback()
        end
      end, { "i", "s" }),

      select_prev_item = cmp.mapping(function(fallback)
        if cmp.visible() then
          vim.notify("select_prev: cmp visible: select_prev_item")
          cmp.select_prev_item()
        else
          vim.notify("select_prev: cmp not visible: fallback")
          fallback()
        end
      end, { "i", "s" }),

      comfirm_or_next_placeholder = cmp.mapping(function(fallback)
        if cmp.visible() then
          vim.notify("next paceholder: confirm")
          cmp.confirm({ select = true })
        elseif vim.snippet.active({ direction = 1 }) then
          vim.notify("next paceholder: jump")
          vim.snippet.jump(1)
        else
          vim.notify("next paceholder: fallback")
          fallback()
        end
      end, { "i", "s" }),

      prev_placeholder = cmp.mapping(function(fallback)
        if vim.snippet.active({ direction = -1 }) then
          vim.notify("prev paceholder: jump")
          vim.snippet.jump(-1)
        else
          vim.notify("prev paceholder: fallback")
          fallback()
        end
      end, { "i", "s" }),

    }

    -- based on: https://www.reddit.com/r/neovim/comments/woih9n/comment/ikbd6iy
    local types = require("cmp.types")
    local function deprioritize_snippet(entry1, entry2)
      if entry1:get_kind() == types.lsp.CompletionItemKind.Snippet then return false end
      if entry2:get_kind() == types.lsp.CompletionItemKind.Snippet then return true end
    end

    cmp.setup({
      mapping = {
        -- words completion
        ["<C-n>"] = actions.complete_or_select_next_item,
        ["<C-p>"] = actions.select_prev_item,
        ["<Tab>"] = actions.comfirm_or_next_placeholder,
        ["<S-Tab>"] = actions.prev_placeholder,
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
      },
      completion = {
        completeopt = "menu,menuone,noselect",
        placeholder = true,
        autocomplete = false,
      },
      sources = {
        { name = 'nvim_lsp_signature_help', priority = 4 },
        { name = "nvim_lsp",                priority = 3 },
        { name = 'luasnip',                 priority = 2 },
        { name = "path",                    priority = 1 },
      },
      view = { entries = { name = "native" } },
      -- the only working option having multiple sources
      preselect = cmp.PreselectMode.None,
      snippet = {
        expand = function(args)
          -- in this case snippet is already set to luasnip
          vim.snippet.expand(args.body)
        end,
      },
      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = make_format_function(),
        expandable_indicator = true,
      },
      sorting = {
        priority_weight = 10,
        comparators = {
          deprioritize_snippet,
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          function(entry1, entry2)
            local _, entry1_under = entry1.completion_item.label:find "^_+"
            local _, entry2_under = entry2.completion_item.label:find "^_+"
            entry1_under = entry1_under or 0
            entry2_under = entry2_under or 0
            if entry1_under > entry2_under then
              return false
            elseif entry1_under < entry2_under then
              return true
            end
          end,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      },
    })

    -- complete search with words from this buffer
    cmp.setup.cmdline('/', {
      mapping = cmp.mapping.preset.cmdline(),
      view = { entries = { name = "custom" } },
      formatting = {
        fields = { "abbr" },
        format = make_format_function(),
        expandable_indicator = true,
      },
      sources = { { name = 'buffer' } }
    })
    -- complete wim commands
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      view = { entries = { name = "custom" } },
      formatting = {
        fields = { "abbr" },
        format = make_format_function(),
        expandable_indicator = true,
      },
      window = {
        completion = cmp.config.window.bordered({ border = 'none' }),
      },
      sources = cmp.config.sources(
        { { name = 'path' } },
        { { name = 'cmdline', option = { ignore_cmds = { 'Man', '!' } } } }
      )
    })
  end
}
