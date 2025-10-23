vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.textwidth = 110
vim.o.colorcolumn = "+1"

local function keymap(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, {
    buffer = 0,
    silent = true,
    noremap = true,
    desc = desc,
  })
end

keymap("<leader>oc", "<cmd>RustLsp openCargo<cr>", "open Cargo.toml")
keymap("<leader>em", "<cmd>RustLsp expandMacro<cr>", "expand Macro")

-- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
vim.keymap.set("n", "K", function()
  vim.cmd.RustLsp({ 'hover', 'actions' })
end, { silent = true })
