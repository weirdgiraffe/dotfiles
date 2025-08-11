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

local select_prev_item = function(opts)
  return function(fallback)
    local fn = function()
      if cmp.visible() then
        return cmp.select_prev_item(opts)
      elseif luasnip.jumpable(-1) then
        return luasnip.jump(-1)
      end
      return false
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
    local fn = function()
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
    end

    if not fn() then
      fallback()
    end
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

local selectBehavior = { behavior = cmp.SelectBehavior.Select }

local mapping_cmdline = cmp.mapping.preset.cmdline({
  ["<Tab>"]   = cmp.mapping(complete_or_next_item(selectBehavior), { "c" }),
  ["<S-Tab>"] = cmp.mapping(complete_or_prev_item(selectBehavior), { "c" }),
  ["<CR>"]    = cmp.mapping(confirm_or_quit({
    select = true,
    behavior = cmp.ConfirmBehavior.Replace,
  }), { "c" }),
})

local mapping_buffer = cmp.mapping.preset.insert({
  ["<S-Tab>"] = cmp.mapping(select_prev_item(selectBehavior), { "i", "s" }),
  ["<Tab>"]   = cmp.mapping(confirm_or_next_item(selectBehavior), { "i", "s" }),
  ["<C-p>"]   = cmp.mapping(complete_or_prev_item(selectBehavior), { "i" }),
  ["<C-n>"]   = cmp.mapping(complete_or_next_item(selectBehavior), { "i" }),
  ["<CR>"]    = cmp.mapping(cmp.mapping.confirm({
    select = true,
    behavior = cmp.ConfirmBehavior.Insert,
  }), { "i" }),
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
    buffer = mapping_buffer,
    cmdline = mapping_cmdline,
  },
  sorting = sorting,
}
