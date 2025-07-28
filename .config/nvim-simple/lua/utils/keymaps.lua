local M = {}

--- nnoremap is equivalent to nnoremap in vimscript
---@param lhs string Left-hand side |{lhs}| of the mapping.
---@param rhs string|function Right-hand side |{rhs}| of the mapping, can be a Lua function.
---@param desc string mapping description
function M.nnoremap(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, {
    silent = true,
    noremap = true,
    desc = desc,
  })
end

--- vnoremap is equivalent to vnoremap in vimscript
---@param lhs string           Left-hand side |{lhs}| of the mapping.
---@param rhs string|function  Right-hand side |{rhs}| of the mapping, can be a Lua function.
---@param desc string mapping description
function M.vnoremap(lhs, rhs, desc)
  vim.keymap.set({ "n", "v" }, lhs, rhs, {
    silent = true,
    noremap = true,
    desc = desc,
  })
end

return M
