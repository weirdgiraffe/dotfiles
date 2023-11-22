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

  local opts = { silent = true, noremap = true }

  vim.keymap.set("n", "<leader>d", fzf.lsp_document_symbols, opts)
  vim.keymap.set("n", "<leader>r", fzf.lsp_references, opts)
  vim.keymap.set("n", "<leader>i", fzf.lsp_implementations, opts)

  vim.keymap.set("n", "<C-p>", files, opts)
  vim.keymap.set("n", "<leader>ff", files_in_current_file_dir, opts)
  vim.keymap.set("n", "<leader>fb", fzf.buffers, opts)                   -- grep buffers
  vim.keymap.set("n", "<leader>fg", fzf.live_grep_glob, opts)            -- live grep
  vim.keymap.set({ "n", "v" }, "<leader>ca", fzf.lsp_code_actions, opts) -- code actions
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "<leader>d", fzf.lsp_document_symbols, opts)
  vim.keymap.set("n", "<leader>r", fzf.lsp_references, opts)
  vim.keymap.set("n", "<leader>i", fzf.lsp_implementations, opts)
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


having("go")(function()
  local opts = { noremap = true, silent = true }
  vim.keymap.set("n", "<leader>a", function()
    require("go.alternate").switch("", "")
  end, opts)

  vim.keymap.set("n", "<Leader>t", function()
    vim.cmd("GoTest" .. vim.fn.expand('%:p:h') .. "/...")
  end, opts)
  vim.keymap.set("n", "<Leader>tf", "<cmd>GoTestFunc<cr>", opts)
  vim.keymap.set("n", "<Leader>tc", "<cmd>GoCoverage -p<cr>", opts)
  vim.keymap.set("n", "<Leader>b", "<cmd>GoBuild<cr>", opts)
  vim.keymap.set("n", "<leader>cc", require("go.comment").gen, opts)
end)

-- show diagnostics for the current line in the floating term window
vim.keymap.set("n", "<leader>sd", function()
  vim.diagnostic.open_float({
    scope = "line",
    source = "true",
    border = "rounded", -- values as for border in vim.api.nvim_open_win()
  })
end, { silent = true, noremap = true })


local function visual_selection_range()
  local unpack = unpack or table.unpack

  -- based on https://neovim.io/doc/user/builtin.html#mode()
  local function is_in_visual_mode()
    local visual_modes = {
      ["v"] = true,
      ["vs"] = true,
      ["V"] = true,
      ["Vs"] = true,
      ["CTRL-V"] = true,
      ["CTRL-Vs"] = true,
    }
    return visual_modes[vim.api.nvim_get_mode().mode] or false
  end

  if is_in_visual_mode() then
    local selection_start = { unpack(vim.fn.getpos('v'), 2, 3) }
    -- NOTE: getpos's column is 1-based, and we need 0-based
    selection_start[2] = selection_start[2] - 1

    local selection_end = vim.api.nvim_win_get_cursor(0)

    -- NOTE: handle "reverse" selection (the cursor is at the start of the
    -- selection, not the end)
    -- Flip based on lines
    if selection_start[1] > selection_end[1] then
      local temp_selection_end = selection_end
      selection_end = selection_start
      selection_start = temp_selection_end
    end

    -- Flip based on columns
    if selection_start[2] > selection_end[2] then
      local temp_selection_end = selection_end[2]
      selection_end[2] = selection_start[2]
      selection_start[2] = temp_selection_end
    end

    return { selection_start, selection_end }
  else
    error("not in the visual mode")
  end
end

-- comment out/ uncomment selected lines
vim.keymap.set({ "n", "v" }, "<leader>co", require("util.comments").toggle, { silent = true, noremap = true })
