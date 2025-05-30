local stdpath = require("config.stdpath")
-- =============================================================================
-- configure the leader key to be <Space>
-- NOTE: it is configured as the first thing in the config to avoid any further
--       keybinding configuration issues.
-- =============================================================================
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- =============================================================================
-- configure paths for special files
-- =============================================================================
vim.opt.directory = stdpath.state .. "/swap"
vim.opt.swapfile = true
vim.opt.undodir = stdpath.state .. "/undo"
vim.opt.undofile = true
vim.opt.backupdir = stdpath.state .. "/backup"
vim.opt.backup = true

-- =============================================================================
-- configure display of the line numbers
-- =============================================================================
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "number"
vim.o.statuscolumn = "%@SignCb@%s%=%T%@NumCb@%l│%T"

-- =============================================================================
-- syntax highlighting
-- =============================================================================
vim.cmd([[filetype on]])
vim.cmd([[filetype plugin indent on]])
vim.opt.syntax           = "enable" -- ensure that syntax highlighting is enabled
vim.opt.synmaxcol        = 300 -- turn off syntax coloring after 300 symbols in one line
vim.opt.autoindent       = true -- automaticaly indent based of filetype

-- =============================================================================
-- folding
-- =============================================================================
vim.opt.foldlevel        = 10 -- do not fold first 10 levels when open a file
vim.opt.foldmethod       = "syntax" -- do folding based on syntax

-- =============================================================================
-- configuratio of the whitespace characters
-- =============================================================================
vim.opt.listchars        = {
  eol = "↴",
  tab = ">-",
  trail = ".",
  extends = ">",
  precedes = "<",
  space = "⋅",
  nbsp = "%",
}
vim.opt.showbreak        = "^"

-- =============================================================================
-- tab completion for vim commands
-- =============================================================================
-- vim.opt.wildignore = require("utils").binary_files
-- vim.opt.wildmode = { "list:longest", "full" }

-- =============================================================================
-- splits
-- =============================================================================
vim.opt.splitright       = true -- vertical split focus on the right pane
vim.opt.splitbelow       = true -- horisontal split focus on the bottom pane

-- =============================================================================

-- configure clipboard to not use registers but to use system clipboard
-- instead. here is the good explanation how vim/nvim clipboard works:
-- https://stackoverflow.com/a/30691754/1208553
vim.opt_global.clipboard = { "unnamed", "unnamedplus" }

vim.o.shortmess          = vim.o.shortmess .. 'WI' -- disable intro message and write messages
vim.go.termguicolors     = true           -- enable 24-bit RGB colors in the terminal
vim.o.guicursor          = "n-i-v-c-ci-ve:block" ..
    ",r-cr:hor20,o:hor50" ..
    ",n-i-r:Cursor/lCursor" ..
    ",c-ci-cr:TermCursor"

vim.opt.scrolloff        = 20 -- min number of lines to keep above/bellow current line

-- do not stop on the long messages, because I can always
-- grab them using :messages if I need to
vim.o.more               = true

-- allow switch off from modified buffers. that allows to use buffers instead of tabs
vim.opt.hidden           = true

vim.opt.ignorecase       = true -- Always ignore case when searching
vim.opt.smartcase        = true -- unless search includes uppercase
