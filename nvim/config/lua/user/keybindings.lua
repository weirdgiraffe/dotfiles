local prequire = require("util.prequire")

local function having(module)
  local has_module = require(module) ~= nil
  return function(fn)
    if has_module then
      fn()
    end
  end
end


having("nvim-tmux-navigation")(function()
  local tmux = require("nvim-tmux-navigation")
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

vim.keymap.set("n", "<leader>bq", close_other_buffers, { silent = true, noremap = true })

having("lualine.components.buffers")(function()
  local lualine_buffers = require("lualine.components.buffers")
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

having("fzf-lua")(function()
  local fzf = require("fzf-lua")

  local files = function()
    local git_root = fzf.path.git_root({}, true)
    if not git_root then
      return fzf.files()
    end
    local relative = fzf.path.relative(vim.loop.cwd(), git_root)
    local opts = {
      fd_opts = table.concat({
        "--type=f",
        "--exclude={.git,vendor,node_modules}",
      }, " "),
      fzf_opts = {
        ["--query"] = git_root ~= relative and relative or nil,
      },
      cwd = git_root,
    }
    return fzf.files(opts)
  end

  local files_in_current_file_dir = function()
    local dir = fzf.path.basename(vim.api.nvim_buf_get_name(0))
    local opts = {
      fd_opts = table.concat({
        "--type=f",
      }, " "),
      cwd = dir,
    }
    return fzf.files(opts)
  end

  vim.keymap.set("n", "<C-p>", files, {})
  vim.keymap.set("n", "<leader>ff", files_in_current_file_dir, {})
  vim.keymap.set("n", "<leader>fb", fzf.buffers, {})                   -- grep buffers
  vim.keymap.set("n", "<leader>fg", fzf.live_grep_glob, {})            -- live grep
  vim.keymap.set({ "n", "v" }, "<leader>ca", fzf.lsp_code_actions, {}) -- code actions
end)


having("trouble")(function()
  local trouble = require("trouble")
  local opts = { silent = true, noremap = true }
  vim.keymap.set("n", "<leader>xx", function() trouble.toggle() end, opts)
  vim.keymap.set("n", "<leader>xw", function() trouble.toggle("workspace_diagnostics") end, opts)
  vim.keymap.set("n", "<leader>xd", function() trouble.toggle("document_diagnostics") end, opts)
end)

having("oil")(function()
  local oil = require("oil")
  vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
end)
