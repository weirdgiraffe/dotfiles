local cmp = require('cmp')

local actions = {
  complete_or_select_next_item = cmp.mapping(function(fallback)
    if cmp.visible() then
      -- vim.notify("select_next: cmp visible: select_next_item")
      cmp.select_next_item()
    elseif vim.api.nvim_buf_get_option(0, 'buftype') ~= 'prompt' then
      -- vim.notify("select next: cmp not visible: complete")
      cmp.complete()
    else
      -- vim.notify("select_next: cmp not visible: fallback")
      fallback()
    end
  end, { "i", "s" }),

  select_prev_item = cmp.mapping(function(fallback)
    if cmp.visible() then
      -- vim.notify("select_prev: cmp visible: select_prev_item")
      cmp.select_prev_item()
    else
      -- vim.notify("select_prev: cmp not visible: fallback")
      fallback()
    end
  end, { "i", "s" }),

  comfirm_or_next_placeholder = cmp.mapping(function(fallback)
    if cmp.visible() then
      -- vim.notify("next paceholder: confirm")
      cmp.confirm({ select = true })
    elseif vim.snippet.active({ direction = 1 }) then
      -- vim.notify("next paceholder: jump")
      vim.snippet.jump(1)
    else
      -- vim.notify("next paceholder: fallback")
      fallback()
    end
  end, { "i", "s" }),

  prev_placeholder = cmp.mapping(function(fallback)
    if vim.snippet.active({ direction = -1 }) then
      -- vim.notify("prev paceholder: jump")
      vim.snippet.jump(-1)
    else
      -- vim.notify("prev paceholder: fallback")
      fallback()
    end
  end, { "i", "s" }),
}

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


local compare = require('cmp.config.compare')


---@param entry1 cmp.Entry
---@param entry2 cmp.Entry
---@return boolean
local function prefer_lsp_completions(entry1, entry2)
  local source = { entry1.source.name, entry2.source.name }
  if source[1] == "nvim_lsp" and source[2] ~= "nvim_lsp" then return true end
  if source[1] ~= "nvim_lsp" and source[2] == "nvim_lsp" then return false end
end

return {
  mapping = cmp.mapping.preset.insert({
    -- words completion
    ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
    ["<C-n>"] = complete_or_next_item,
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sorting = {
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
  },
}
