-- soft wrap long lines in markdown
-- vim.o.textwidth = 120
-- vim.o.colorcolumn = "+1"
-- vim.cmd [[ hi ColorColumn ctermbg=grey guibg=grey ]]

-- soft wrap long lines in markdown
vim.o.wrap = true
vim.o.linebreak = true
vim.o.showbreak = " "
vim.o.colorcolumn = "110"
vim.o.textwidth = 0  -- disable hard wrapping
vim.o.wrapmargin = 0 -- disable wrap margin
vim.o.list = false   -- disable whitespaces display

vim.o.tabstop = 8
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = false
