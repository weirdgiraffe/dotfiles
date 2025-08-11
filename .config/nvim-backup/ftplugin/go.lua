local cfcd = require("utils").cfcd

local function keymap(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, {
    buffer = 0,
    silent = true,
    noremap = true,
    desc = desc,
  })
end

vim.o.shiftwidth = 4
vim.o.tabstop = 4

vim.o.textwidth = 110
vim.o.colorcolumn = "+1"

keymap("<leader>a", function()
  require("go.alternate").switch("", "")
end, "go alternate")

keymap("<leader>b", cfcd(function()
  vim.cmd([[GoBuild]])
end), "go build")

keymap("<leader>t", cfcd(function()
  vim.cmd([[GoTestPkg]])
end), "go test")

keymap("<leader>c", cfcd(function()
  vim.cmd([[GoCoverage -p]])
end), "go coverage")

keymap("<leader>cc", function() require("go.comment").gen() end, "go: add comment")

keymap("<leader>m", cfcd(function()
  vim.cmd([[GoModTidy]])
  vim.cmd([[LspRestart]])
end), "go mod tidy")

keymap("<leader>tc", cfcd(function()
  vim.cmd([[GoCoverage -t]])
end), "toggle coverage")
