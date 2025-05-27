local M = {}

M.binary_files = {
  ".DS_Store",
  "*.jpg",
  "*.jpeg",
  "*.gif",
  "*.png",
  "*.psd",
  "*.o",
  "*.obj",
  "*.min.js",
  "*.pyc",
  "*/__pycache_/*",
  "*/.git/*",
  "*/.hg/*",
  "*/.svn/*",
  "*.gz",
  "*.bz",
  "*.tar",
  "*.tar.gz",
  "*.tar.bz",
  "*.tgz",
  "*.tbz",
  "*.lzma",
  "*.zip",
  "*.rar",
  "*.iso",
}

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
    what()
    vim.fn.chdir(curdir)
  end
end

--- trim_prefix will remove a prefix from a string
---@param s string string which will be trimmed
---@param prefix string prefix to trim
---@return string trimmed string without a prefix
function M.trim_prefix(s, prefix)
  if s:sub(1, prefix:len()) == prefix then
    return s:sub(prefix:len() + 1)
  end
  return s
end

return M
