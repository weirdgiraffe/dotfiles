vim.o.textwidth = 80
vim.o.colorcolumn = "+1"
-- set color of the 80th column
vim.api.nvim_set_hl(0, "ColorColumn", { bg = 'lightgrey' })

vim.o.tabstop = 8
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = false
