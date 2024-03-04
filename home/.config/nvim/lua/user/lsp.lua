local function set_gopls_toggle_gc_details(bufnr)
  -- gopls provides codelens only for the 0,0 cursor position and to invoke
  -- them from the random line we would need to change position first, then
  -- invoke, and then jump back where we were
  vim.keymap.set("n", "<leader>w", function()
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
  end, {
    buffer = bufnr,
    silent = true,
    noremap = true,
    desc = "LSP toggle gc details",
  })
end

local function set_gopls_inlay_hints(bufnr)
  vim.keymap.set("n", "<leader>q", function()
    -- generic inlay_hints are still experimental in nvim
    -- so need to rely on the plugin.
    -- NOTE: this is async operation and it takes some time
    require('go.inlay').toggle_inlay_hints()
  end, {
    buffer = bufnr,
    desc = "LSP toggle inlay hints for this go file",
    silent = true,
    noremap = true
  })
end

local function gopls_organize_imports(client, bufnr)
  local params = vim.lsp.util.make_range_params()
  params.context = { only = { "source.organizeImports" } }
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


local function lsp_format_on_save(client, bufnr)
  -- remove trailing whitespaces
  vim.cmd(":%s/\\s\\+$//ge")
  -- format the code using lsp
  vim.lsp.buf.format({ bufnr = bufnr, async = false })
end

local function gopls_format_on_save(client, bufnr)
  gopls_organize_imports(client, bufnr)
  lsp_format_on_save(bufnr)
end

local function set_lsp_format_on_save(client, bufnr)
  if client.supports_method("textDocument/formatting") then
    local format = lsp_format_on_save
    if client.name == "gopls" then
      format = gopls_format_on_save
    end
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function() format(client, bufnr) end,
      desc = "format document using LSP on save",
    })
  end
end


local function on_attach(client, bufnr)
  -- vim.print("attached to " .. bufnr .. ":" .. client.name .. " client: " .. client.id)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  if client.name == "gopls" then
    set_gopls_toggle_gc_details(bufnr)
    set_gopls_inlay_hints(bufnr)
  end

  set_lsp_format_on_save(client, bufnr)

  vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
    noremap = true,
    silent = true,
    buffer = bufnr,
    desc = "LSP go to definition",
  })

  vim.keymap.set("n", "<leader>r", ":IncRename ", {
    noremap = true,
    silent = true,
    buffer = bufnr,
    desc = "LSP rename",
  })
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    assert(event, "LspAttach event shall not be nil")
    local bufnr = event.buf
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    on_attach(client, bufnr)
  end,
  desc = "user specific lsp callback",
})
