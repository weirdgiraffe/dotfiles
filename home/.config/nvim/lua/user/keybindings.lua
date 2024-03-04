local having = require("util.modules").having

having("nvim-tmux-navigation", function(tmux)
  local opts = { silent = true, noremap = true }
  vim.keymap.set("n", "<M-h>", tmux.NvimTmuxNavigateLeft, opts)
  vim.keymap.set("n", "<M-j>", tmux.NvimTmuxNavigateDown, opts)
  vim.keymap.set("n", "<M-k>", tmux.NvimTmuxNavigateUp, opts)
  vim.keymap.set("n", "<M-l>", tmux.NvimTmuxNavigateRight, opts)
end)


-- close_all_buffers will close all the buffers but the current one
-- NOTE: if buffers have some unsaved changes it will not be deleted
local function close_other_buffers()
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
end

vim.keymap.set("n", "<leader>v", "<cmd>bp<CR>", {
  silent = true,
  noremap = true,
  desc = "Switch to previous buffer",
})
vim.keymap.set("n", "<leader>b", close_other_buffers, {
  silent = true,
  noremap = true,
  desc = "Close all buffers but the current one",
})
vim.keymap.set("n", "<leader>n", "<cmd>bn<CR>", {
  silent = true,
  noremap = true,
  desc = "Switch to next buffer",
})

having("lualine.components.buffers", function(lualine_buffers)
  -- configure mapping for buffers: <Leader>1 will switch to buffer 1,
  -- <Leader>2 to buffer 2 and so on up to buffer 9
  for i = 1, 9, 1 do
    local jump = function()
      -- we need to pass "!" instead of "<bang>" here to actually
      -- pass the bang sign to the underlying function, otherwise
      -- it will panic if we would try to switch to the buffer
      -- which not exists
      lualine_buffers.buffer_jump(i, '!')
    end
    vim.keymap.set("n", "<leader>" .. i, jump, { silent = true, noremap = true })
  end
end)

having("fzf-lua", function(fzf)
  -- files will search for files in the current git repository_url
  -- or in a current dir if current path is not within a git
  -- repository
  local files = function()
    local opts = {
      fd_opts = table.concat({
        "--hidden",
        "--type=f",
      }, " "),
      cwd = fzf.path.git_root({}, true),
    }
    return fzf.files(opts)
  end

  vim.keymap.set("n", "<leader>l", files, {
    silent = true,
    noremap = true,
    desc = "files for the current project dir",
  })
  vim.keymap.set("n", "<leader>k", fzf.buffers, {
    silent = true,
    noremap = true,
    desc = "opened buffers",
  })
  vim.keymap.set("n", "<leader>j", fzf.live_grep_glob, {
    silent = true,
    noremap = true,
    desc = "live grep over the current dir",
  })


  vim.keymap.set("n", "<leader>f", fzf.lsp_references, {
    silent = true,
    noremap = true,
    desc = "lsp document references",
  })
  vim.keymap.set("n", "<leader>d", fzf.lsp_document_symbols, {
    silent = true,
    noremap = true,
    desc = "lsp document symbols",
  })
  vim.keymap.set("n", "<leader>i", fzf.lsp_implementations, {
    silent = true,
    noremap = true,
    desc = "lsp document implementations",
  })


  vim.keymap.set({ "n", "v" }, "<leader>e", fzf.lsp_code_actions, {
    silent = true,
    noremap = true,
    desc = "lsp code actions for the line",
  })
end)


having("trouble", function(trouble)
  local opts = { silent = true, noremap = true }
  vim.keymap.set("n", "<leader>x", function()
    trouble.toggle("document_diagnostics")
  end, {
    silent = true,
    noremap = true,
    desc = "Trouble: show document diagnostics",
  })
  vim.keymap.set("n", "<leader>c", function()
    trouble.toggle("workspace_diagnostics")
  end, {
    silent = true,
    noremap = true,
    desc = "Trouble: show workspace diagnostics",
  })
end)

having("oil", function()
  vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
end)

-- show diagnostics for the current line in the floating term window
vim.keymap.set("n", "<leader>a", function()
  vim.diagnostic.open_float({
    scope = "line",
    source = "true",
    border = "rounded", -- values as for border in vim.api.nvim_open_win()
  })
end, {
  silent = true,
  noremap = true,
  desc = "Show diagnostics for the current line",
})

-- comment out/ uncomment selected lines
vim.keymap.set({ "n", "v" }, "<leader>co", require("util.comments").toggle, { silent = true, noremap = true })


vim.api.nvim_create_user_command("Sh", function(opts)
  if #opts.args == 0 then
    error("no command provided")
  end
  local cmd = "split term://sh -c '" .. opts.args .. "'"
  vim.print("cmd=" .. cmd)

  local height = math.max(3, math.floor(vim.api.nvim_win_get_height(0) * 0.3))
  vim.cmd(cmd)
  local win = vim.api.nvim_get_current_win() -- should be a terminal now
  vim.api.nvim_win_set_height(win, height)
  local bufnr = vim.api.nvim_win_get_buf(win)
  -- delete this buffer if it's hidden, i.e. when window is closed
  vim.api.nvim_buf_set_option(bufnr, "bufhidden", "delete") -- delete this buffer if it's hidden
end, {
  desc = "quickly run a shell command is a split",
  nargs = "*",
})


having("obsidian", function()
  vim.api.nvim_set_keymap("n", "<leader>fk",
    "<cmd>ObsidianQuickSwitch<CR>",
    {
      silent = true,
      noremap = true,
      desc = "Obsidian quick switch",
    })

  vim.api.nvim_set_keymap("n", "<leader>fl", "",
    {
      silent = true,
      noremap = true,
      callback = function()
        local title = vim.fn.input("Title: ")
        vim.cmd("ObsidianNew " .. title)
      end,
      desc = "Create new note in Obsidian",
    })
  vim.api.nvim_set_keymap("n", "<leader>fj",
    "<cmd>ObsidianToday<cr>",
    {
      silent = true,
      noremap = true,
      desc = "Daily Obsidian node",
    })
end)

having("CopilotChat", function()
  vim.keymap.set("x", "<leader>ccv", function()
    local ss = vim.fn.getpos("'<")
    local se = vim.fn.getpos("'>")
    local prompt = vim.fn.input("Prompt: ")
    vim.print(vim.inspect(ss))
    vim.print(vim.inspect(vim.fn.getpos("'<")))
    vim.print(vim.inspect(se))
    vim.print(vim.inspect(vim.fn.getpos("'>")))
    -- vim.fn.setpos("'<", ss)
    -- vim.fn.setpos("'>", se)
    -- vim.cmd("CopilotChatVisual " .. prompt)
  end, {
    silent = true,
    noremap = true,
    desc = "CopilotChat - Ask about visual selection",
  })
  vim.api.nvim_set_keymap("x", "<leader>ccc", "",
    {
      silent = true,
      noremap = true,
      callback = function()
        local prompt = "Please rewrite the following text to make it more concise."
        vim.cmd("CopilotChatVisual " .. prompt)
      end,
      desc = "CopilotChat - Rewrite the selection to be more concise",
    })
  vim.api.nvim_set_keymap("x", "<leader>cct", "",
    {
      silent = true,
      noremap = true,
      callback = function()
        local prompt = "Please explain how the selected code works, then generate unit tests for it."
        vim.cmd("CopilotChatVisual " .. prompt)
      end,
      desc = "CopilotChat - Write unit tests for the selection",
    })
  vim.api.nvim_set_keymap("x", "<leader>ccr", "",
    {
      silent = true,
      noremap = true,
      callback = function()
        local prompt = "Please review the following code and provide suggestions for improvement."
        vim.cmd("CopilotChatVisual " .. prompt)
      end,
      desc = "CopilotChat - Review the selection",
    })
  -- CopilotChatInPlace is not working
end)
