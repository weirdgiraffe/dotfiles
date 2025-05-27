local nnoremap = require("utils").nnoremap
local tmux = require("nvim-tmux-navigation")

nnoremap("<M-h>", tmux.NvimTmuxNavigateLeft, "navigate to the left window or tmux pane")
nnoremap("<M-j>", tmux.NvimTmuxNavigateDown, "navigate to the window or tmux pane below")
nnoremap("<M-k>", tmux.NvimTmuxNavigateUp, "navigate to the window or tmux pane on top")
nnoremap("<M-l>", tmux.NvimTmuxNavigateRight, "navigate to the right window or tmux pane")
