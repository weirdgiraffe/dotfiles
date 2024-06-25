local nnoremap = require("utils").nnoremap
local vnoremap = require("utils").vnoremap

local tmux = require("nvim-tmux-navigation")
local fzf = require("fzf-lua")

nnoremap("-", "<CMD>Oil<CR>", "open parent directory using oil")

nnoremap("<M-h>", tmux.NvimTmuxNavigateLeft, "navigate to the left window or tmux pane")
nnoremap("<M-j>", tmux.NvimTmuxNavigateDown, "navigate to the window or tmux pane below")
nnoremap("<M-k>", tmux.NvimTmuxNavigateUp, "navigate to the window or tmux pane on top")
nnoremap("<M-l>", tmux.NvimTmuxNavigateRight, "navigate to the right window or tmux pane")


nnoremap("<leader>J", function()
  return fzf.files({
    winopts = { preview = { layout = "vertical" } },
    fd_opts = table.concat({
      "--hidden",
      "--type=f",
    }, " "),
    cwd = fzf.path.git_root({}, true)
  })
end, "find files with respect to current git repo")

nnoremap("<leader>j", function()
  return fzf.files({
    fd_opts = table.concat({
      "--hidden",
      "--type=f",
    }, " "),
    cwd = vim.fn.expand("%:h"),
  })
end, "find files with respect to the current file dir")

nnoremap("<leader>g", function()
  return fzf.live_grep({
    cwd = vim.fn.expand("%:h"),
  })
end, "live grep with respect to the current file dir")

nnoremap("<leader>G", function()
  return fzf.live_grep({
    winopts = { preview = { layout = "vertical" } },
    cwd     = fzf.path.git_root({}, true)
  })
end, "live grep with respect to current git repo")

nnoremap("<leader>k", function()
  local opts = require("telescope.themes").get_dropdown()
  return require("telescope.builtin").buffers(opts)
end, "LSP: document symbols")

nnoremap("<leader>x", function()
  local api = require("trouble.api")
  if api.is_open() then
    api.close()
  else
    vim.cmd([[Trouble diagnostics]])
  end
end, "show diagnostics")

nnoremap("gd", function()
  local opts = require("telescope.themes").get_dropdown()
  opts.show_line = false
  return require("telescope.builtin").lsp_definitions(opts)
end, "LSP go to definition")

nnoremap("<leader>d", fzf.lsp_document_symbols, "LSP: document symbols")
nnoremap("<leader>D", function()
  local opts = require("telescope.themes").get_dropdown()
  return require("telescope.builtin").lsp_document_symbols(opts)
end, "LSP: document symbols")

nnoremap("<leader>r", fzf.lsp_references, "LSP: references")
nnoremap("<leader>i", fzf.lsp_implementations, "LSP: implementations")


vnoremap("<leader>q", fzf.lsp_code_actions, "LSP: code actions")

-- this is a version of code actions with a native ui-select
-- in my case ui-select is wrapped with telescope
vnoremap("<leader>Q", vim.lsp.buf.code_action, "LSP: code actions")


nnoremap("<leader>cw", ":IncRename ", "LSP: rename")

vnoremap("<leader>co", require("utils.comments").toggle, "comment/uncomment selection")
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

-- configure mapping for buffers: <Leader>1 will switch to buffer 1,
-- <Leader>2 to buffer 2 and so on up to buffer 9
for i = 1, 9, 1 do
  local jump = function()
    -- we need to pass "!" instead of "<bang>" here to actually
    -- pass the bang sign to the underlying function, otherwise
    -- it will panic if we would try to switch to the buffer
    -- which not exists
    require("lualine.components.buffers").buffer_jump(i, '!')
  end
  nnoremap("<leader>" .. i, jump, "switch to buffer " .. i)
end

-- NOTE: if buffers have some unsaved changes it will not be deleted
nnoremap("<leader>y", function()
  local buffers = vim.api.nvim_list_bufs()
  local current_buffer = vim.api.nvim_get_current_buf()
  for _, bufnr in ipairs(buffers) do
    local listed = vim.api.nvim_get_option_value("buflisted", { buf = bufnr })
    local modified = vim.api.nvim_get_option_value("modified", { buf = bufnr })
    local current = current_buffer == bufnr
    if not current and listed and not modified then
      vim.api.nvim_buf_delete(bufnr, {})
    end
  end
end, "close all but the current buffer")


nnoremap("<leader>o", "<cmd>ObsidianQuickSwitch<cr>", "obsidian: quick switch")
nnoremap("<leader>on", function()
  local title = vim.fn.input("Title: ")
  vim.cmd("ObsidianNew " .. title)
end, "obsidian: new note")
nnoremap("<leader>ot", "<cmd>ObsidianToday<cr>", "obsidian: today note")

nnoremap("<leader>;", require("giraffe.harpoon").add_mark, "add item to harpoon")
nnoremap("<leader>h", require("giraffe.harpoon").telescope, "open harpoon window")

vim.api.nvim_create_user_command("Harpoon", function(opts)
  if opts.args == "clear" then
    vim.notify("harpoon: clear marks")
    require("giraffe.harpoon").clear()
  end
end, {
  nargs = 1,
  ---@diagnostic disable-next-line: unused-local
  complete = function(lead, cmdline, cursor)
    if ("clear"):sub(1, #lead) == lead then
      return { "clear" }
    end
    if lead == "" then
      return { "clear" }
    end
    return {}
  end,
  desc = "run harpoon commands",
})

vim.api.nvim_create_user_command("CopyPath", function()
  local s = vim.fn.expand("%:p")
  if s ~= "" then
    local path = require("plenary.path"):new(s)
    s = path:normalize(path.home)
    vim.fn.setreg("+", s)
    vim.notify('Copied "' .. s .. '" to the clipboard!')
  end
end, {})

nnoremap("<leader>cp", "<cmd>CopyPath<cr>", "coppy current buffer path to clipboard")

nnoremap("<leader>gb", "<cmd>Gitsigns blame_line<cr>", "git blame current line")
