local log = require("utils.log")
vim.lsp.set_log_level("WARN")

local capabilities = vim.lsp.protocol.make_client_capabilities()

-- generic lsp configuration
vim.lsp.config('*', { capabilities = capabilities, })

-- configure gopls specifically to avoid workspaces errors
vim.lsp.config('gopls', (function()
  local cfg = require('go.lsp').config() or {}
  cfg.workspace = vim.tbl_deep_extend("force", cfg.workspace or {}, {
    didChangeWatchedFiles = {
      dynamicRegistration = false,
      relativePatternSupport = false,
    }
  })
  cfg.settings.gopls = vim.tbl_deep_extend("force", cfg.settings.gopls or {}, {
    analyses = {
      -- disable annoying "at least one file in a package should have a package comment" warning
      ST1000 = false,
    },
  })
  vim.tbl_deep_extend("force", cfg, { capabilities = capabilities })
  return cfg
end)())


vim.lsp.config('rust-analyzer', {
  settings = {
    ['rust-analyzer'] = {
      inlayHints = {
        typeHints = { enable = true },
        parameterHints = { enable = true },
        chainingHints = { enable = true },
        renderColons = true,
      },
    }
  }
})


---Format the provided bufnr using the the provided lsp client
---
---@param client vim.lsp.Client gopls instance
---@param bufnr number buffer to lsp format
local function lsp_format_buffer(client, bufnr)
  vim.cmd(":%s/\\s\\+$//ge")                                           -- remove trailing whitespaces
  log.debug("formatting %d buffer using %s", bufnr or 0, client.name)
  vim.lsp.buf.format({ id = client.id, bufnr = bufnr, async = false }) -- format the code using lsp client
end


---gopls_organize_imports will organize imports for the provided buffer
---@param client vim.lsp.Client gopls instance
---@param bufnr number buffer to organize imports for
local function gopls_organize_imports(client, bufnr)
  if client.name ~= "gopls" then
    vim.notify("Organize imports is only supported for gopls", vim.log.levels.WARN)
    return
  end
  local params = vim.tbl_deep_extend("keep",
    {
      context = {
        only = { "source.organizeImports" }
      },
    },
    vim.lsp.util.make_range_params(0, client.offset_encoding)
  )
  -- buf_request_sync defaults to a 1000ms timeout. Depending on your
  -- machine and codebase, you may want longer. Add an additional
  -- argument after params if you find that you have to write the file
  -- twice for changes to be saved.
  -- E.g., vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 3000)
  local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 1000)
  -- local result = client:request_sync("textDocument/codeAction", params, 1000, bufnr)
  for _, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit, client.offset_encoding or "utf-16")
      end
    end
  end
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
      if client.name == "gopls" then
        callback = function()
          gopls_organize_imports(client, bufnr)
          lsp_format_buffer(client, bufnr)
        end
      end

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
