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

keymap("<leader>a", function()
  require("go.alternate").switch("", "")
end, "go alternate")

keymap("<leader>b", cfcd(function()
  vim.cmd([[Trouble close]]) -- close trobule window if was opened
  vim.cmd([[GoBuild]])
end), "go build")

keymap("<leader>t", cfcd(function()
  vim.cmd([[Trouble close]])
  vim.notify("RUN: go test", vim.log.levels.INFO)
  vim.cmd([[GoTestPkg]])
end), "go test")

keymap("<leader>c", cfcd(function()
  vim.cmd([[Trouble close]])
  vim.notify("RUN: go test -cover", vim.log.levels.INFO)
  vim.cmd([[GoCoverage -p]])
end), "go coverage")

keymap("<leader>cc", require("go.comment").gen, "go: add comment")

keymap("<leader>m", cfcd(function()
  vim.cmd([[GoModTidy]])
end), "go mod tidy")

keymap("<leader>tc", cfcd(function()
  vim.cmd([[GoCoverage -t]])
  vim.notify("toggle coverage", vim.log.levels.INFO)
end), "toggle coverage")

keymap("<leader>ti", function()
  require('go.inlay').toggle_inlay_hints()
  vim.notify("toggle inlay hints", vim.log.levels.INFO)
end, "toggle inlay hints")

keymap("<leader>tgc", function()
  local lens = vim.lsp.codelens.get(0)
  if #lens == 1 then
    local lens_range = lens[1].range
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_win_set_cursor(0, {
      lens_range["start"].line + 1,
      lens_range["start"].character,
    })
    vim.lsp.codelens.run()
    vim.api.nvim_win_set_cursor(0, pos)
  end
  vim.notify("toggle gc details", vim.log.levels.INFO)
end, "toggle gc details")
