-- Disable Ex mode, i.e compatibility mode with ex editor
-- reference: https://vimdoc.sourceforge.net/htmldoc/intro.html#Ex
vim.api.nvim_set_keymap("n", "Q", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gQ", "<Nop>", { noremap = true, silent = true })

-- enable mouse in all modes
vim.opt.mouse = "a"

-- disable cursor styling, i.e. always use block shaped cursor
vim.opt.guicursor = ""

-- set leader key to space because it is the most ergonomic key (could
-- be pressed by both of my thumbs)
vim.g.mapleader = " "

-- allow switch off from modified buffers. that allows to use buffers instead of tabs
vim.opt.hidden = true

-- setup tmux colors compatibility, i.e. allow 256 colors
vim.go.termguicolors = true

-- configure clipboard to not use registers but to use system clipboard instead.
-- here is the good explanation how vim/nvim clipboard works:
--   https://stackoverflow.com/a/30691754/1208553
vim.opt_global.clipboard = { "unnamed", "unnamedplus" }

-- configure search
vim.opt.ignorecase = true -- ignore case if search with /,? etc.
vim.opt.smartcase = true  -- make search case sensitive if uppercase in search pattern
vim.opt.showmatch = true  -- show matching bracets
vim.opt.hlsearch = true   -- highlight all search results by default (to clean use :noh)

-- configure special characters
vim.opt.listchars = {
  eol = "↴",
  tab = ">-",
  trail = ".",
  extends = ">",
  precedes = "<",
  space = "⋅",
  nbsp = "%",
}
vim.opt.showbreak = "^"

-- configure filename pattern to ignore for filename completion
vim.opt.wildignore = {
  ".DS_Store",
  "*.jpg",
  "*.jpeg",
  "*.gif",
  "*.png",
  "*.psd",
  "*.o",
  "*.obj",
  "*.min.js",
  "*.pyc",
  "*/__pycache_/*",
  "*/.git/*",
  "*/.hg/*",
  "*/.svn/*",
  "*.gz",
  "*.bz",
  "*.tar",
  "*.tar.gz",
  "*.tar.bz",
  "*.tgz",
  "*.tbz",
  "*.lzma",
  "*.zip",
  "*.rar",
  "*.iso",
}

-- autocomplete full file names, don't pick anything automatically
vim.opt.wildmode = {
  "full",
  "list:full",
}

-- min number of lines to keep above/bellow current line
vim.opt.scrolloff = 20

-- ensure that syntax highlighting is enabled
vim.opt.syntax = "enable"

-- turn off syntax coloring after 300 symbols in one line
vim.opt.synmaxcol = 300

-- enable intendation based on filetype plugins
vim.cmd("filetype plugin indent on")

-- do not fold first 20 levels when open a file
vim.opt.foldlevel = 20

-- do folding based on syntax
vim.opt.foldmethod = "syntax"

-- vertical split focus on the right pane
vim.opt.splitright = true

-- horisontal split focus on the bottom pane
vim.opt.splitbelow = true

-- automaticaly indent based of filetype
vim.opt.autoindent = true

vim.o.more = true

vim.o.number = true
vim.o.relativenumber = true

-- workaround to not loose window position on buffer switch
vim.cmd([[
  au BufLeave * let b:winview = winsaveview()
  au BufEnter * if(exists('b:winview')) | call winrestview(b:winview) | endif
]])

vim.o.conceallevel = 2

-- do not display intro message and jump straight to editing
-- for more info see `:h shortmess` and `:intro`
vim.o.shortmess = vim.o.shortmess .. 'I'

-- show current line
vim.o.cursorline = true

-- check if we have pyenv
if vim.fn.executable('pyenv') == 1 then
  -- assuming that we setted everything up using
  -- our dotfiles, so path would be predictable.
  -- TODO: make automatic discovery to be independent from dotfiles
  vim.g.python3_host_prog = vim.fn.expand("~/.pyenv/versions/neovim/bin/python")
end

require("user.lsp")
require("user.lazy")
require("user.colors").setup()
require("user.keybindings")
