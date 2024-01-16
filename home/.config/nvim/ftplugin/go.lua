local having = require("util.modules").having

vim.o.shiftwidth = 4
vim.o.tabstop = 4

having("go", function()
  local opts = { noremap = true, silent = true }
  vim.keymap.set("n", "<leader>a", function()
    require("go.alternate").switch("", "")
  end, opts)
  vim.keymap.set("n", "<Leader>t", function()
    vim.cmd("GoTest" .. vim.fn.expand('%:p:h') .. "/...")
  end, opts)
  vim.keymap.set("n", "<Leader>tf", "<cmd>GoTestFunc<cr>", opts)
  vim.keymap.set("n", "<Leader>tc", "<cmd>GoCoverage -p<cr>", opts)
  vim.keymap.set("n", "<Leader>b", "<cmd>GoBuild<cr>", opts)
  vim.keymap.set("n", "<leader>cc", require("go.comment").gen, opts)
end)
