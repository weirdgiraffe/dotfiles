local utils = require("utils")

local M = {}

function M.setup()
  print("settting up keymaps")

  local fzf = require("fzf-lua")

  vim.keymap.set("n", "<leader>ff", utils.git_relative_files, {}) -- list files
  vim.keymap.set("n", "<C-p>", utils.git_relative_files, {}) -- list files
  vim.keymap.set("n", "<leader>fb", fzf.buffers, {}) -- grep buffers
  vim.keymap.set("n", "<leader>fg", fzf.live_grep_glob, {}) -- live grep
  vim.keymap.set({ "n", "v" }, "<leader>ca", fzf.lsp_code_actions, {}) -- code actions

  vim.keymap.set("n", "<leader>bq", utils.close_other_buffers, {}) -- close other buffers
  for i = 1, 9, 1 do
    vim.api.nvim_set_keymap("n", "<leader>" .. i, "", {
      silent = true,
      callback = function()
          -- we need to pass "!" instead of "<bang>" here to actually
          -- pass the bang sign to the underlying function, otherwise
          -- it will panic if we would try to switch to the buffer
          -- which not exists
          require("lualine.components.buffers").buffer_jump(i, "!")
      end,
    })
  end
end

return M
