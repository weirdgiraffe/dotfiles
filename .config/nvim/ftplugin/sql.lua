vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.expandtab = true

local function alternate_migration()
  local path = vim.fn.expand('%:p') -- get current file path
  local fname = vim.fs.basename(path):lower()
  local target_path
  if fname:sub(-7) == ".up.sql" then
    target_path = path:sub(1, -7) .. "down.sql"
  end
  if fname:sub(-9) == ".down.sql" then
    target_path = path:sub(1, -9) .. "up.sql"
  end
  if target_path then
    vim.cmd.edit(vim.fn.fnameescape(target_path))
  end
end

vim.keymap.set("n", "<leader>a", alternate_migration, {
  buffer = 0,
  silent = true,
  noremap = true,
  desc = "alternates between sql migrations",
})
