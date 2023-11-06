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
        require("lualine.components.buffers").buffer_jump(i, "<bang>")
      end,
    })
  end
end

return M
