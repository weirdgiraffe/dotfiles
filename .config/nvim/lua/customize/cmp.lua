local cmp = require('cmp')
local compare = require('cmp.config.compare')

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

local mapping_cmdline = cmp.mapping.preset.cmdline({
  ["<Tab>"]   = { c = complete_or_next_item({ behavior = cmp.SelectBehavior.Select }) },
  ["<S-Tab>"] = { c = complete_or_prev_item({ behavior = cmp.SelectBehavior.Select }) },
  ["<CR>"]    = {
    c = cmp.mapping.confirm({
      select = true,
      behavior = cmp.ConfirmBehavior.Replace,
    })
  },
})

local mapping_insert = cmp.mapping.preset.insert({
  ["<C-p>"] = { i = complete_or_prev_item({ behavior = cmp.SelectBehavior.Select }) },
  ["<C-n>"] = { i = complete_or_next_item({ behavior = cmp.SelectBehavior.Select }) },
  ["<CR>"]  = {
    i = cmp.mapping.confirm({
      select = true,
      behavior = cmp.ConfirmBehavior.Insert,
    })
  },
})

---@param entry1 cmp.Entry
---@param entry2 cmp.Entry
---@return boolean|nil
local function prefer_lsp_completions(entry1, entry2)
  local source = { entry1.source.name, entry2.source.name }
  if source[1] == "nvim_lsp" and source[2] ~= "nvim_lsp" then return true end
  if source[1] ~= "nvim_lsp" and source[2] == "nvim_lsp" then return false end
end

local sorting = {
  priority_weight = 2,
  comparators = {
    prefer_lsp_completions,
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
