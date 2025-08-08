local log = require("utils.log")
local entry_display = require("telescope.pickers.entry_display")

local function diplay(dirname, filename)
  if #dirname > 0 then dirname = dirname .. "/" end
  local display_entry = entry_display.create({
    separator = "",
    items = {
      { width = #dirname }, -- dirname
      { remaining = true }, -- filename
    },
  })
  return display_entry({
    { dirname,  "TelescopeResultsComment" },
    { filename, "TelescopeResultsIdentifier" },
  })
end

local M = {}

local homedir = vim.loop.os_homedir()

function M.path_display(opts, path)
  local cwd = opts.cwd or vim.fn.getcwd()
  path = cwd .. "/" .. path

  local dirname = vim.fs.dirname(path)
  local filename = vim.fs.basename(path)
  if homedir then
    dirname = "~/" .. vim.fs.relpath(homedir, dirname)
  end
  return diplay(dirname, filename)
end

function M.relpath_display(opts, path)
  local dirname = vim.fs.dirname(path)
  local filename = vim.fs.basename(path)
  if opts.cwd then
    dirname = dirname:gsub("^" .. opts.cwd, ""):gsub("^/", "")
  end
  return diplay(dirname, filename)
end

return M
