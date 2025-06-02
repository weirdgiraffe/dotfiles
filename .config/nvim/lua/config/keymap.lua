local utils = require("utils")
local telescope_builtin = require("telescope.builtin")
local telescope = require("customize.telescope")
local tmux = require("nvim-tmux-navigation")
local fzf = require("fzf-lua")

local nnoremap = utils.nnoremap
local vnoremap = utils.vnoremap

nnoremap("<M-h>", tmux.NvimTmuxNavigateLeft, "navigate to the left window or tmux pane")
nnoremap("<M-j>", tmux.NvimTmuxNavigateDown, "navigate to the window or tmux pane below")
nnoremap("<M-k>", tmux.NvimTmuxNavigateUp, "navigate to the window or tmux pane on top")
nnoremap("<M-l>", tmux.NvimTmuxNavigateRight, "navigate to the right window or tmux pane")

nnoremap("-", "<CMD>Oil<CR>", "open parent directory using oil")

-- configure mapping for buffers: <Leader>1 will switch to buffer 1, <Leader>2
-- to buffer 2 and so on up to buffer 9
for i = 1, 9, 1 do
  nnoremap("<leader>" .. i, function() utils.switch_focus_to_buffer(i) end, "switch to buffer " .. i)
end

nnoremap("<leader>y", utils.close_other_buffers, "close all but the current buffer")

nnoremap("gd", telescope.lsp_goto_definition, "LSP: go to definition")
nnoremap("<leader>d", telescope.lsp_document_symbols, "LSP: document symbols")
nnoremap("<leader>j", telescope.list_project_files, "List files in the current git repository")
nnoremap("<leader>k", telescope.buffers, "List opened buffers")
nnoremap("<leader>r", telescope.lsp_references, "LSP: references")
vnoremap("<leader>i", telescope.lsp_implementations, "LSP: implementations")
vnoremap("<leader>q", fzf.lsp_code_actions, "LSP: code actions")
nnoremap("<leader>x", telescope_builtin.diagnostics, "Display diagnostics")

nnoremap("<leader>g", function()
  local cwd = vim.fn.expand("%:p:h")
  return fzf.live_grep({
    winopts = { preview = { layout = "vertical" } },
    fzf_opts = { ["--tiebreak"] = "end,length" },
    cwd = cwd
  })
end, "live grep with respect to the current file dir")

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

nnoremap("<leader>cw", ":IncRename ", "LSP: rename")
nnoremap("<leader>gh", "<CMD>GH<CR>", "Open github")
