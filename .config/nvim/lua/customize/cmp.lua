local cmp = require('cmp')
local compare = require('cmp.config.compare')
local luasnip = require('luasnip')

local complete_or_next_item = function(opts)
  return function(fallback)
    local fn = function()
      if cmp.visible() then
        return cmp.select_next_item(opts)
      end
      return cmp.complete()
    end
    if not fn() then
      fallback()
    end
  end
end

local complete_or_prev_item = function(opts)
  return function(fallback)
    local fn = function()
      if cmp.visible() then
        return cmp.select_prev_item(opts)
      end
      return cmp.complete()
    end
    if not fn() then
      fallback()
    end
  end
end

local confirm_or_next_item = function(opts)
  return function(fallback)
    if cmp.visible() then
      local items = cmp.get_entries()
      if #items == 1 then
        return cmp.confirm({
          select = true,
          behavior = cmp.ConfirmBehavior.Insert,
        })
      end
      return cmp.select_next_item(opts)
    end

    if luasnip.expand_or_jumpable() then
      return luasnip.expand_or_jump()
    end

    fallback()
  end
end

local confirm_or_quit = function(opts)
  return function(fallback)
    local fn = function()
      if not cmp.get_selected_entry() then
        return false
      end
      return cmp.confirm(opts)
    end
    if not fn() then
      fallback()
    end
  end
end

local mapping_cmdline = cmp.mapping.preset.cmdline({
  ["<Tab>"]   = { c = complete_or_next_item({ behavior = cmp.SelectBehavior.Select }) },
  ["<S-Tab>"] = { c = complete_or_prev_item({ behavior = cmp.SelectBehavior.Select }) },
  ["<CR>"]    = {
    c = confirm_or_quit({
      select = true,
      behavior = cmp.ConfirmBehavior.Replace,
    })
  },
})

local mapping_insert = cmp.mapping.preset.insert({
  ["<Tab>"] = {
    i = confirm_or_next_item({ behavior = cmp.SelectBehavior.Select }),
    s = confirm_or_next_item({ behavior = cmp.SelectBehavior.Select }),
  },
  ["<C-p>"] = { i = complete_or_prev_item({ behavior = cmp.SelectBehavior.Insert }) },
  ["<C-n>"] = { i = complete_or_next_item({ behavior = cmp.SelectBehavior.Insert }) },
  ["<CR>"]  = {
    i = cmp.mapping.confirm({
      select = true,
      behavior = cmp.ConfirmBehavior.Insert,
    })
  },
})

local sorting = {
  priority_weight = 2,
  comparators = {
    compare.offset,
    compare.exact,
    -- compare.scopes,
    compare.score,
    compare.recently_used,
    compare.locality,
    compare.kind,
    compare.sort_text,
    compare.length,
    compare.order,
  },
}

return {
  mapping = {
    insert = mapping_insert,
    cmdline = mapping_cmdline,
  },
  sorting = sorting,
}
