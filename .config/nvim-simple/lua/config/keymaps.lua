local nnoremap = require("utils.keymaps").nnoremap

-- oil.nvim
nnoremap("-", "<CMD>Oil<CR>", "Open parent directory")

-- tmux-navigation.nvim
local tmux = require("nvim-tmux-navigation")
nnoremap("<M-h>", tmux.NvimTmuxNavigateLeft, "Navigate to the left window or tmux pane")
nnoremap("<M-j>", tmux.NvimTmuxNavigateDown, "Navigate to the window or tmux pane below")
nnoremap("<M-k>", tmux.NvimTmuxNavigateUp, "Navigate to the window or tmux pane on top")
nnoremap("<M-l>", tmux.NvimTmuxNavigateRight, "Navigate to the right window or tmux pane")

-- lualine.nvim
nnoremap("<M-n>", require("utils.buffers").next_buffer, "Switch to next buffer")
nnoremap("<M-p>", require("utils.buffers").prev_buffer, "Switch to prev buffer")
nnoremap("<leader>y", require("utils.buffers").close_other_buffers, "Close all buffers but the current one")
-- configure mapping for buffers: <Leader>bufnr for buffers up to 9
for i = 1, 9, 1 do
  nnoremap("<leader>" .. i, function()
    require("utils.buffers").switch_to_buffer(i)
  end, "switch to buffer " .. i)
end
