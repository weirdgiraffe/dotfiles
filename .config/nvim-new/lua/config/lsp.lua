vim.lsp.set_log_level("warn")


-- ensure that all lsp servers will receive correct capabilities
local capabilities = vim.tbl_deep_extend("force", {},
  vim.lsp.protocol.make_client_capabilities(),
  require("cmp_nvim_lsp").default_capabilities()
)
vim.lsp.config('*', { capabilities = capabilities, })

---gopls_organize_imports will organize imports for the provided buffer
---@param client vim.lsp.Client gopls instance
---@param bufnr number buffer to organize imports for
local function gopls_organize_imports(client, bufnr)
  if client.name ~= "gopls" then
    vim.notify("Organize imports is only supported for gopls", vim.log.levels.WARN)
    return
  end
  local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
  params.context = {
    only = {
      "source.organizeImports"
    }
  }
  -- buf_request_sync defaults to a 1000ms timeout. Depending on your
  -- machine and codebase, you may want longer. Add an additional
  -- argument after params if you find that you have to write the file
  -- twice for changes to be saved.
  -- E.g., vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 3000)
  local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params)
  for _, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit, client.offset_encoding or "utf-16")
      end
    end
  end
end


---lsp_format_buffer will format the buffer using the provided lsp client
---@param client vim.lsp.Client gopls instance
---@param bufnr number buffer to lsp format
local function lsp_format_buffer(client, bufnr)
  if not client.supports_method("textDocument/formatting") then
    vim.notify("Client doesn't support textDocument/formatting", vim.log.levels.WARN)
    return
  end
  vim.cmd(":%s/\\s\\+$//ge")                                           -- remove trailing whitespaces
  vim.lsp.buf.format({ id = client.id, bufnr = bufnr, async = false }) -- format the code using lsp client
end


vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    assert(event, "LspAttach event shall not be nil")
    local bufnr = event.buf or error("LspAttach event shall have a buffer")
    local client = vim.lsp.get_client_by_id(event.data.client_id) or error("LspAttach event shall have an lsp client")

    if client:supports_method("textDocument/formatting") then
      local callback = function() lsp_format_buffer(client, bufnr) end
      if client.name == "gopls" then
        callback = function()
          gopls_organize_imports(client, bufnr)
          lsp_format_buffer(client, bufnr)
        end
      end
      local group_name = string.format("__giraffe:on_save:%s:%d", client.name, bufnr)
      local group = vim.api.nvim_create_augroup(group_name, { clear = true })
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        group = group,
        callback = callback,
        desc = "format document using LSP",
      })
    end
  end,
  desc = "user specific lsp on_attach callback",
})
