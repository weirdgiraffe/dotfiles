local cmp = require('cmp')
local compare = require('cmp.config.compare')

local cmp_select = { behavior = cmp.SelectBehavior.Select }

local complete_or_next_item = cmp.mapping(function(fallback)
  local fn = function()
    if cmp.visible() then
      return cmp.select_next_item(cmp_select)
    end
    return cmp.complete()
  end
  if not fn() then
    fallback()
  end
end)

local select_prev_item = cmp.mapping(function(fallback)
  if not cmp.visible() then
    fallback()
  end

  if not cmp.select_prev_item(cmp_select) then
    fallback()
  end
end)

local confirm_item = cmp.mapping(function(fallback)
  if not cmp.visible() then
    fallback()
  end
  if not cmp.confirm({ select = true }) then
    fallback()
  end
end)

local dismiss_completion = cmp.mapping(function(fallback)
  if not cmp.visible() then
    fallback()
  end
  if not cmp.abort() then
    fallback()
  end
end)

local mapping = cmp.mapping.preset.insert({
  ["<C-p>"] = select_prev_item,
  ["<C-n>"] = complete_or_next_item,
  ["<C-e>"] = dimiss_completion,
  ["<C-l>"] = confirm_item,
  ["<CR>"]  = confirm_item,
})

---@param entry1 cmp.Entry
---@param entry2 cmp.Entry
---@return boolean
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
  mapping = mapping,
  sorting = sorting,
}
