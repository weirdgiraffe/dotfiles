local log = require("utils.log")
local entry_display = require("telescope.pickers.entry_display")

local function utf8_advance(b)
  if b < 128 then
    return 1
  elseif b < 224 then
    return 2
  elseif b < 240 then
    return 3
  else
    return 4
  end
end

local function utf8_len(str)
  -- Check each byte
  local len = 0
  local i = 1
  while i <= #str do
    local step = utf8_advance(str:byte(i))
    i = i + step
    len = len + 1
    -- NOTE: I don't understand why, but for
    -- each emoji or complex utf8 symbol I
    -- need to add 1 to the length to get
    -- the correct display width
    if step > 1 then
      len = len + 1
    end
  end
  return len
end

local function diplay(dirname, filename)
  if #dirname > 0 then dirname = dirname .. "/" end
  local display_entry = entry_display.create({
    separator = "",
    items = {
      { width = utf8_len(dirname) }, -- dirname
      { remaining = true },          -- filename
    },
  })
  return display_entry({
    { dirname,  "TelescopeResultsComment" },
    { filename, "TelescopeResultsIdentifier" },
  })
end

local M = {}

local homedir = vim.uv.os_homedir()

local function smart_dirname(dirname, repo)
  -- replace long paths for cargo packages
  local _, end_pos = string.find(dirname, "registry/src/index.crates.io")
  if end_pos then
    end_pos = string.find(dirname, "/", end_pos)
    if end_pos then
      return "📦 " .. string.sub(dirname, end_pos + 1)
    end
  end
  -- replace long paths for go packages
  _, end_pos = string.find(dirname, "pkg/mod/")
  if end_pos then
    if end_pos then
      return "📦 " .. string.sub(dirname, end_pos + 1)
    end
  end
  -- replace repo relative paths
  if repo and string.sub(dirname, 1, #repo) == repo then
    local replacement = vim.fs.relpath(repo, dirname)
    if replacement == "." then
      return replacement
    end
    return "./" .. replacement
  end
  -- replace home relative paths
  if homedir and string.sub(dirname, 1, #homedir) == homedir then
    return "~/" .. vim.fs.relpath(homedir, dirname)
  end
  return dirname
end

function M.smart_display(repo)
  return function(_, path)
    local dirname = vim.fs.dirname(path)
    local filename = vim.fs.basename(path)
    if dirname == "." then
      dirname = vim.fn.getcwd()
    end
    -- ensure that we have absolute path for
    -- the dirname, so substitutions would
    -- keep working
    dirname = smart_dirname(vim.fn.expand(dirname), repo)
    return diplay(dirname, filename)
  end
end

return M
