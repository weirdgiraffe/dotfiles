local prequire = require("util.prequire")

local function not_empty_augroup(groupname, bufnr)
  local cmds = vim.api.nvim_get_autocmds({
    group = groupname,
    bugger = bufnr,
  })
  return next(cmds) == nil
end

local function go_orgnize_imports()
  local params = vim.lsp.util.make_range_params()
  params.context = { only = { "source.organizeImports" } }
  -- buf_request_sync defaults to a 1000ms timeout. Depending on your
  -- machine and codebase, you may want longer. Add an additional
  -- argument after params if you find that you have to write the file
  -- twice for changes to be saved.
  -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
  for cid, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
        vim.lsp.util.apply_workspace_edit(r.edit, enc)
      end
    end
  end
end

local function set_lsp_on_save(client, bufnr)
  if client.supports_method("textDocument/formatting") then
    local group_name = "lsp_on_save_" .. bufnr
    local augroup = vim.api.nvim_create_augroup(group_name, {})

    -- organize imports (also adds missing imports, at least for stdlib)
    -- based on https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim-imports
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        if vim.bo.filetype == "go" then
          go_orgnize_imports()
        end
        -- remove trailing whitespaces
        vim.cmd(":%s/\\s\\+$//ge")
        -- format the code using lsp
        vim.lsp.buf.format({ async = false })
      end,
    })
  end
end

local M = {}

function M.on_attach(client, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }

  set_lsp_on_save(client, bufnr)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)

  local fzf = prequire("fzf-lua")
  if fzf then
    vim.keymap.set("n", "<leader>d", fzf.lsp_document_symbols, bufopts)
    vim.keymap.set("n", "<leader>r", fzf.lsp_references, bufopts)
    vim.keymap.set("n", "<leader>i", fzf.lsp_implementations, bufopts)
  end
end

return M
