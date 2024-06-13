local M = {}

--- nnoremap is equivalent to nnoremap in vimscript
---@param lhs string           Left-hand side |{lhs}| of the mapping.
---@param rhs string|function  Right-hand side |{rhs}| of the mapping, can be a Lua function.
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

---cfcd will wrap a function, so it will run in the folder of a current file
---@param what function what to run in current file dir
function M.cfcd(what)
  assert(type(what) == "function", "argument should be a function")
  local dstdir = vim.fn.expand("%:h")
  if dstdir:sub(1, 6) == "oil://" then
    dstdir = dstdir:sub(7)
  end
  if dstdir == "" then
    return what
  end

  return function()
    local curdir = vim.fn.chdir(dstdir)
    vim.print("cd front: " .. dstdir)
    what()
    vim.print("cd back: " .. curdir)
    vim.fn.chdir(curdir)
  end
end

return M
