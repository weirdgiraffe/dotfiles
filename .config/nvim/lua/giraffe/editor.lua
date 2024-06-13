-- dir to store swap files :h swapfile
vim.opt.directory = vim.fn.stdpath("state") .. "/swap"
vim.opt.swapfile = true

-- dir to store undo files :h undofile
vim.opt.undodir = vim.fn.stdpath("state") .. "/undo"
vim.opt.undofile = true

-- dir to store backup files :h backup
vim.opt.backupdir = vim.fn.stdpath("state") .. "/backup"
vim.opt.backup = false

-- configure clipboard to not use registers but to use system clipboard
-- instead. here is the good explanation how vim/nvim clipboard works:
-- https://stackoverflow.com/a/30691754/1208553
vim.opt_global.clipboard = { "unnamed", "unnamedplus" }

-- set leader key to space because it is the most ergonomic key (could be pressed by both of my thumbs)
-- NOTE: always set leader first!
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- enable mouse in all modes
vim.opt.mouse = "a"

-- disable cursor styling, i.e. always use block shaped cursor
vim.opt.guicursor = ""

-- allow switch off from modified buffers. that allows to use buffers instead of tabs
vim.opt.hidden = true

-- setup tmux colors compatibility, i.e. allow 256 colors
vim.go.termguicolors = true

-- configure search
vim.opt.ignorecase = true -- ignore case if search with /,? etc.
vim.opt.smartcase = true  -- make search case sensitive if uppercase in search pattern
vim.opt.showmatch = true  -- show matching bracets
vim.opt.hlsearch = true   -- highlight all search results by default (to clean use :noh)

-- TODO: add keymap to clear highlights like C-l for :noh

-- configure whitespace characters
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

-- enable filetype detection, plugin and indentation :h filetype
vim.cmd("filetype plugin indent on")

-- do not fold first 10 levels when open a file
vim.opt.foldlevel = 10

-- do folding based on syntax
vim.opt.foldmethod = "syntax"

-- vertical split focus on the right pane
vim.opt.splitright = true

-- horisontal split focus on the bottom pane
vim.opt.splitbelow = true

-- automaticaly indent based of filetype
vim.opt.autoindent = true

-- do not stop on the long messages, because I can always
-- grab them using :messages if I need to
vim.o.more = true

-- do not display intro message and jump straight to editing
-- for more info see `:h shortmess` and `:intro`
vim.o.shortmess = vim.o.shortmess .. 'I'

-- do not highlight current line
vim.o.cursorline = false

-- line numbers
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'auto'



local background = {
  file_path = nil,
  default = nil,
}

background.store = function()
  assert(background.file_path, "background.file_path is not set")
  local file = io.open(background.file_path, "wb")
  if file then
    file:write(vim.o.background)
    file:close()
  end
end

background.load = function()
  assert(background.file_path, "background.file_path is not set")
  assert(background.default, "background.default is not set")
  local file = io.open(background.file_path, "rb")
  if file then
    local val = file:read("*all")
    file:close()
    if val == "dark" or val == "light" then
      return val
    end
  end
  return background.default
end


background.setup = function(opts)
  background.file_path = opts.file_path or vim.fn.stdpath("state") .. "/background.conf"
  background.default = opts.default or "dark"
  local group = vim.api.nvim_create_augroup("_girafe:background", { clear = true })
  vim.api.nvim_create_autocmd("OptionSet", {
    group = group,
    pattern = "background",
    callback = background.store,
    desc = "store current background",
  })
end

background.setup({ default = "dark" })
vim.o.background = background.load()
