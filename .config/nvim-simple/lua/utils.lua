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

--- close_other_buffers will close all buffers except the current one if the
--- buffer is not modified.
function M.close_other_buffers()
  local buffers = vim.api.nvim_list_bufs()
  local current_buffer = vim.api.nvim_get_current_buf()
  for _, bufnr in ipairs(buffers) do
    local listed = vim.api.nvim_get_option_value("buflisted", { buf = bufnr })
    local modified = vim.api.nvim_get_option_value("modified", { buf = bufnr })
    local current = current_buffer == bufnr
    if not current and listed and not modified then
      vim.api.nvim_buf_delete(bufnr, {})
    end
  end
end

--- switch_focus_to_buffer will switch focus to a buffer with the given bufnr.
---@param bufnr number buffer number to switch focus to
function M.switch_focus_to_buffer(bufnr)
  -- we need to pass "!" instead of "<bang>" here to actually
  -- pass the bang sign to the underlying function, otherwise
  -- it will panic if we would try to switch to the buffer
  -- which not exists
  require("lualine.components.buffers").buffer_jump(bufnr, '!')
end

-- @function fzf_cwd will figure out the base directory to use for fzf related
-- searches and the relative path to the current directory from the base
-- directory. @return string,string
local function fzf_cwd()
  local fzf = require("fzf-lua")
  local Path = require("plenary.path")

  local function relpath(path)
    local home_dir = vim.fn.expand("~")
    local rel = Path:new(path):make_relative(home_dir)
    return path:len() == rel:len() and path or "~/" .. rel
  end

  local cwd = vim.fn.expand("%:p:h")
  local git_root = fzf.path.git_root({ cwd = cwd }, true)
  if git_root then
    -- In case our cwd is inside of some symlink to the git repository, we
    -- don't want to use the git root as cwd, so ensure that our cwd is withing
    -- the git root.
    if cwd:len() >= git_root:len() and cwd:sub(1, git_root:len()) == git_root then
      local rel = Path:new(cwd):make_relative(git_root)
      return relpath(git_root), rel == "." and "" or rel
    end
  end
  return relpath(cwd), ""
end

function M.list_repo_files()
  local fzf = require("fzf-lua")

  local base, _ = fzf_cwd()
  return fzf.files({
    winopts = { preview = { layout = "vertical" } },
    formatter = { "path.dirname_first" },
    fzf_opts = { ["--tiebreak"] = "end,length" },
    fd_opts = table.concat({
      "--color=never",
      "--exclude='.git'",
      "--hidden",
      "--type=f",
    }, " "),
    cwd = base,
  })
end

return M
