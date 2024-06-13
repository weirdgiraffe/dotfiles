local cfcd = require("utils").cfcd

local function keymap(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, {
    buffer = 0,
    silent = true,
    noremap = true,
    desc = desc,
  })
end

vim.o.shiftwidth = 4
vim.o.tabstop = 4

keymap("<leader>a", function()
  require("go.alternate").switch("", "")
end, "go alternate")

keymap("<leader>b", cfcd(function()
  vim.cmd([[Trouble close]]) -- close trobule window if was opened
  vim.cmd([[GoBuild]])
end), "go build")

keymap("<leader>t", cfcd(function()
  vim.cmd([[Trouble close]])
  vim.notify("RUN: go test", vim.log.levels.INFO)
  vim.cmd([[GoTestPkg]])
end), "go test")

keymap("<leader>c", cfcd(function()
  vim.cmd([[Trouble close]])
  vim.notify("RUN: go test -cover", vim.log.levels.INFO)
  vim.cmd([[GoCoverage -p]])
end), "go coverage")

keymap("<leader>cc", require("go.comment").gen, "go: add comment")

keymap("<leader>m", cfcd(function()
  vim.cmd([[GoModTidy]])
end), "go mod tidy")

keymap("<leader>tc", cfcd(function()
  vim.cmd([[GoCoverage -t]])
  vim.notify("toggle coverage", vim.log.levels.INFO)
end), "toggle coverage")

keymap("<leader>ti", function()
  require('go.inlay').toggle_inlay_hints()
  vim.notify("toggle inlay hints", vim.log.levels.INFO)
end, "toggle inlay hints")

keymap("<leader>tgc", function()
  local lens = vim.lsp.codelens.get(0)
  if #lens == 1 then
    local lens_range = lens[1].range
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_win_set_cursor(0, {
      lens_range["start"].line + 1,
      lens_range["start"].character,
    })
    vim.lsp.codelens.run()
    vim.api.nvim_win_set_cursor(0, pos)
  end
  vim.notify("toggle gc details", vim.log.levels.INFO)
end, "toggle gc details")


-- local function organize_imports(client, bufnr)
--   local params = vim.lsp.util.make_range_params()
--   params.context = {
--     only = {
--       "source.organizeImports"
--     }
--   }
--   -- buf_request_sync defaults to a 1000ms timeout. Depending on your
--   -- machine and codebase, you may want longer. Add an additional
--   -- argument after params if you find that you have to write the file
--   -- twice for changes to be saved.
--   -- E.g., vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 3000)
--   local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params)
--   for _, res in pairs(result or {}) do
--     for _, r in pairs(res.result or {}) do
--       if r.edit then
--         vim.lsp.util.apply_workspace_edit(r.edit, client.offset_encoding or "utf-16")
--       end
--     end
--   end
-- end
--
-- local group = "_user:buf_on_save:" .. bufnr
-- vim.api.nvim_create_augroup(group, { clear = true })
-- vim.print("set format on save for buffer "..bufnr.." using client "..client.id)
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   buffer = bufnr,
--   group = group,
--   callback = function()
--     vim.print("formattig buffer "..bufnr.." using client " .. client.id)
--     format(client, bufnr)
--   end,
--   desc = "format document using LSP on save",
-- })
--
