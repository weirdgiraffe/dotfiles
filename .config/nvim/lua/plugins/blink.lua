local log = require("utils.log")

--- Remove all matches from items for which filter returns true
---@param items any[] items to process
---@param filter fun(item:any):boolean filter to apply
local function filter_out(items, filter)
  for i = #items, 1, -1 do
    if filter(items[i]) then
      table.remove(items, i)
    end
  end
  return items
end

local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  if col == 0 then return false end
  local before = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(1, col)
  return not before:match("%s$")
end

return {
  'saghen/blink.cmp',
  version = '1.*',
  lazy = false,
  enabled = true,
  dependencies = {
    { "L3MON4D3/LuaSnip" },
    { 'milanglacier/minuet-ai.nvim' },
  },
  config = function()
    require("blink-cmp").setup({
      keymap = {
        preset = 'none',
        ["<C-n>"] = { 'show', 'select_next', 'fallback', },
        ["<C-p>"] = { 'show', 'select_prev', 'fallback', },
        ['<C-k>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-j>'] = { 'scroll_documentation_down', 'fallback' },
        ["<CR>"] = { 'accept', 'fallback' },
        ["<Tab>"] = {
          function(cmp)
            if not has_words_before() then return end

            -- next snippet item if we are inside of the snippet
            if cmp.snippet_active({ direction = 1 }) then
              return cmp.snippet_forward()
            end

            -- completion may be active because of the trigger character,
            if cmp.is_active() then
              local items = cmp.get_items()
              if cmp.is_visible() then
                return #items == 1 and cmp.accept() or cmp.select_next()
              end
              return cmp.show_and_insert()
            end

            return cmp.is_visible() or cmp.show({ providers = { "snippets" } })
          end,
          'fallback'
        },
      },
      appearance = {
        nerd_font_variant = 'normal',
      },
      cmdline = { enabled = false },
      completion = {
        trigger = {
          prefetch_on_insert = false,
          show_on_insert = false,
          show_on_keyword = true,
          show_on_trigger_character = true,
        },
        accept = { auto_brackets = { enabled = false } },
        list = { selection = { preselect = false, auto_insert = false } },
        ghost_text = { enabled = true },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
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
        default = { "lsp", "path", "buffer" },
        transform_items = function(_, items)
          local kind = require("blink.cmp.types").CompletionItemKind
          return filter_out(items, function(item)
            return item.source_name == "LSP" and item.client_name == "gopls" and item.kind == kind.Snippet
          end)
        end,
      },
      -- Use a preset for snippets, check the snippets documentation for more information
      snippets = { preset = 'luasnip' },
      -- Experimental signature help support
      signature = { enabled = true }
    })
  end
}
