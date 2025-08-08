local nnoremap = require("utils.keymaps").nnoremap
local vnoremap = require("utils.keymaps").vnoremap
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

vim.keymap.set({ "n", "x" }, "<leader>q", function()
  require("tiny-code-action").code_action()
end, { noremap = true, silent = true })


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
nnoremap("<leader>gh", "<CMD>GH<CR>", "Open github")


-- for current file page
vim.api.nvim_set_keymap("n", "<Leader>gh", ":OpenInGHFile <CR>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("v", "<Leader>gh", ":OpenInGHFileLines <CR>", { silent = true, noremap = true })
