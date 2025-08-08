local log = require("utils.log")
vim.lsp.set_log_level("WARN")

local capabilities = vim.lsp.protocol.make_client_capabilities()
vim.lsp.config('*', { capabilities = capabilities, })


---Format the provided bufnr using the the provided lsp client
---
---@param client vim.lsp.Client gopls instance
---@param bufnr number buffer to lsp format
local function lsp_format_buffer(client, bufnr)
  vim.cmd(":%s/\\s\\+$//ge")                                           -- remove trailing whitespaces
  log.debug("formatting %d buffer using %s", bufnr or 0, client.name)
  vim.lsp.buf.format({ id = client.id, bufnr = bufnr, async = false }) -- format the code using lsp client
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    assert(event, "LspAttach event must not be nil")
    local bufnr = event.buf
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    assert(bufnr, "LspAttach event must have a buffer")
    assert(client, "LspAttach event shall have an lsp client")

    if client:supports_method("textDocument/formatting") then
      local group_name = string.format("__lsp:on_save:%s:%d", client.name, bufnr)
      local group = vim.api.nvim_create_augroup(group_name, { clear = true })
      local callback = function() return lsp_format_buffer(client, bufnr) end
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        group = group,
        callback = callback,
        desc = string.format("format buffer using %s lsp client", client.name),
      })
    end
  end,
  desc = "custom lsp on_attach callback",
})
