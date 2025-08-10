vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.textwidth = 110
vim.o.colorcolumn = "+1"


--- Wrap a function to run in the folder of a current file
---@param fn function
local function with_current_file_cwd(fn)
  assert(type(fn) == "function", "argument should be a function")
  local dir = vim.fn.expand("%:h")
  return function()
    local save_dir = vim.fn.chdir(dir)
    fn()
    vim.fn.chdir(save_dir)
  end
end

local function keymap(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, {
    buffer = 0,
    silent = true,
    noremap = true,
    desc = desc,
  })
end

keymap("<leader>a", function()
  require("go.alternate").switch("", "")
end, "go alternate")

keymap("<leader>b", with_current_file_cwd(function()
  vim.cmd([[GoBuild]])
end), "go build")

keymap("<leader>t", with_current_file_cwd(function()
  vim.cmd([[GoTestPkg]])
end), "go test")

keymap("<leader>c", with_current_file_cwd(function()
  vim.cmd([[GoCoverage -p]])
end), "go coverage")

keymap("<leader>cc", function()
  require("go.comment").gen()
end, "go: add comment")

keymap("<leader>m", with_current_file_cwd(function()
  vim.cmd([[GoModTidy]])
  vim.cmd([[LspRestart]])
end), "go mod tidy")

keymap("<leader>tc", with_current_file_cwd(function()
  vim.cmd([[GoCoverage -t]])
end), "toggle coverage")
