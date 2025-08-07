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



local M = {
}

function M.gitsigns_on_attach(bufnr)
  local gs = require("gitsigns")
  local wk = require("which-key")
  local function map(mode, lhs, desc, rhs, opts)
    local spec = { lhs, rhs }
    for k, v in pairs(opts or {}) do spec[k] = v end
    spec.mode = mode
    spec.desc = desc
    spec.buffer = bufnr
    wk.add(spec)
  end

  -- Navigation
  map('n', ']c', 'Go to next hunk', function()
    if vim.wo.diff then
      vim.cmd.normal({ '[c', bang = true })
    else
      gs.nav_hunk('next')
    end
  end, { expr = true })

  map('n', '[c', 'Go to next hunk', function()
    if vim.wo.diff then
      vim.cmd.normal({ '[c', bang = true })
    else
      gs.nav_hunk('prev')
    end
  end, { expr = true })

  -- Actions
  map('n', '<leader>hs', "Stage hunk", function() gs.stage_hunk() end)
  map('n', '<leader>hu', "Undo stage hunk", function() gs.stage_hunk() end)
  map('n', '<leader>hr', "Reset hunk", function() gs.reset_hunk() end)
  map('v', '<leader>hs', "Stage hunk", function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end)



  map('v', '<leader>hr', "Reset hunk", function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end)
  map('n', '<leader>hS', "Stage buffer", function() gs.stage_buffer() end)
  map('n', '<leader>hR', "Reset buffer", function() gs.reset_buffer() end)
  map('n', '<leader>hp', "Preview hunk", function() gs.preview_hunk() end)
  map('n', '<leader>hb', "Blame line", function() gs.blame_line({ full = true }) end)
  map('n', '<leader>tb', "Toggle current line blame", function() gs.toggle_current_line_blame() end)
  map('n', '<leader>hd', "Diff this", function() gs.diffthis() end)
  map('n', '<leader>hD', "Diff this file", function() gs.diffthis() end)
  map('n', '<leader>td', "Toggle deleted", function() gs.preview_hunk_inline() end)

  -- Text object
  map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', "Select hunk")
end

return M
