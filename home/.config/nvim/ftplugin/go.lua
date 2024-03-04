local having = require("util.modules").having

vim.o.shiftwidth = 4
vim.o.tabstop = 4

having("go", function()
  local opts = { noremap = true, silent = true }
  vim.keymap.set("n", "<leader>u", function()
    require("go.alternate").switch("", "")
  end, {
    silent = true,
    noremap = true,
    desc = "go alternate",
  })
  vim.keymap.set("n", "<leader>i", "<cmd>GoBuild<cr>", {
    silent = true,
    noremap = true,
    desc = "go build",
  })
  vim.keymap.set("n", "<leader>o", function()
    vim.cmd("GoTest" .. vim.fn.expand('%:p:h') .. "/...")
  end, {
    silent = true,
    noremap = true,
    desc = "go test",
  })
  vim.keymap.set("n", "<leader>p", function()
    require("go.coverage").toggle()
  end, {
    silent = true,
    noremap = true,
    desc = "go coverage toggle",
  })
  vim.keymap.set("n", "<leader>pr", "<cmd>GoCoverage -p<cr>", {
    silent = true,
    noremap = true,
    desc = "go coverage for current package",
  })
  vim.keymap.set("n", "<leader>cc", require("go.comment").gen, opts)
end)
