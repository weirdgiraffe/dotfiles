local nnoremap = require("utils.keymaps").nnoremap
local vnoremap = require("utils.keymaps").vnoremap
local log = require("utils.log")
local telescope = require("custom.telescope")

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

-- telescope bindings
nnoremap("gd", telescope.lsp_goto_definition, "LSP: go to definition")
nnoremap("<leader>d", telescope.lsp_document_symbols, "LSP: document symbols")
nnoremap("<leader>j", telescope.project_files, "List files in the current git repository")
nnoremap("<leader>k", telescope.buffers, "List opened buffers")
nnoremap("<leader>r", telescope.lsp_references, "LSP: references")
nnoremap("<leader>i", telescope.lsp_implementations, "LSP: implementations")
nnoremap("<leader>x", telescope.diagnostics, "Display diagnostics")
nnoremap("<leader>g", telescope.live_grep, "Live grep")
vim.keymap.set({ "n", "x" }, "<leader>q",
  require("tiny-code-action").code_action,
  {
    noremap = true,
    silent = true,
    desc = "LSP: code actions",
  })

nnoremap("<leader>cw", ":IncRename ", "LSP: rename")


nnoremap("<leader>sd", function()
  vim.diagnostic.open_float({
    layout = 'vertical',
    layout_config = {
      prompt_position = "top",
    },
    scope = "line",
    source = true,
    border = "rounded",
  })
end, "show diagnostics for the current line")


-- for current file page
vim.api.nvim_set_keymap("n", "<Leader>gh", ":OpenInGHFile <CR>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("v", "<Leader>gh", ":OpenInGHFileLines <CR>", { silent = true, noremap = true })

nnoremap("L", function()
  if vim.lsp.inlay_hint.is_enabled() then
    vim.lsp.inlay_hint.enable(false, { 0 })
  else
    vim.lsp.inlay_hint.enable(true, { 0 })
  end
end, "Toggle Inlay Hints")


nnoremap("<leader>z", function()
  require("zen-mode").toggle({
    window = {
      width = .6 -- width will be 85% of the editor width
    }
  })
end, "Toggle zen mode")

-- if I am in the Zen mode and window shrinks, like I'm getting out of zoom in tmux
-- I would like to exit zen mode
; (function()
  local width = vim.api.nvim_win_get_width(0)
  local height = vim.api.nvim_win_get_height(0)

  vim.api.nvim_create_autocmd("VimResized", {
    callback = function()
      local w = vim.api.nvim_win_get_width(0)
      local h = vim.api.nvim_win_get_height(0)
      if w < width or h < height then
        require("zen-mode").close()
      end
      width = w
      height = h
    end,
  })
end)()


vim.api.nvim_set_keymap("i", "jj", "<Esc>", { noremap = false })
