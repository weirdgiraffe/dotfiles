local cmp = require('cmp')
local compare = require('cmp.config.compare')

local complete_or_next_item = function(opts, modes)
  return cmp.mapping(function(fallback)
    local fn = function()
      if cmp.visible() then
        print("select next item " .. vim.inspect(opts))
        return cmp.select_next_item(opts)
      end
      print("complete")
      return cmp.complete()
    end
    if not fn() then
      fallback()
    end
  end, modes)
end

local select_prev_item = function(opts, modes)
  return cmp.mapping(function(fallback)
    if not cmp.visible() then
      fallback()
    end

    if not cmp.select_prev_item(opts) then
      fallback()
    end
  end, modes)
end

local confirm_item = function(opts, modes)
  return cmp.mapping(function(fallback)
    if not cmp.visible() then
      fallback()
    end
    if not cmp.confirm({ select = true }) then
      fallback()
    end
  end, modes)
end

local dismiss_completion = cmp.mapping(function(fallback)
  if not cmp.visible() then
    fallback()
  end
  if not cmp.abort() then
    fallback()
  end
end)

local mapping_cmdline = cmp.mapping.preset.cmdline({
  ["<Tab>"] = complete_or_next_item({ behavior = cmp.SelectBehavior.Select }, { "c" }),
  ["<S-Tab>"] = select_prev_item({ behavior = cmp.SelectBehavior.Select }, { "c" }),
  ["<C-l>"] = confirm_item({ behavior = cmp.ConfirmBehavior.Replace }, { "c" }),
  ["<CR>"] = confirm_item({ behavior = cmp.ConfirmBehavior.Replace }, { "c" }),
})

local mapping_insert = cmp.mapping.preset.insert({
  ["<C-p>"] = select_prev_item({ behavior = cmp.SelectBehavior.Select }),
  ["<C-n>"] = complete_or_next_item({ behavior = cmp.SelectBehavior.Select }),
  ["<C-e>"] = dismiss_completion,
  ["<C-l>"] = confirm_item({ behavior = cmp.ConfirmBehavior.Insert }),
  ["<CR>"] = confirm_item({ behavior = cmp.ConfirmBehavior.Insert }),
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
  mapping = {
    insert = mapping_insert,
    cmdline = mapping_cmdline,
  },
  sorting = sorting,
}
