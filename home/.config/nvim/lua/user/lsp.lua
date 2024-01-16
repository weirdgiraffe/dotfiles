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

local function go_codel_lens(bufnr)
  -- gopls provides codelens only for the 0,0 cursor position and to invoke
  -- them from the random line we would need to change position first, then
  -- invoke, and then jump back where we were
  vim.keymap.set("n", "<leader>cl", function()
    local lens = vim.lsp.codelens.get(0)
    vim.print("lens=" .. vim.inspect(lens))
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
    desc = "run lsp codelens for go this file",
    silent = true,
    noremap = true
  })
end

local function go_inlay_hints(bufnr)
  -- gopls provides codelens only for the 0,0 cursor position and to invoke
  -- them from the random line we would need to change position first, then
  -- invoke, and then jump back where we were
  vim.keymap.set("n", "<leader>ci", function()
    require('go.inlay').toggle_inlay_hints()
  end, {
    buffer = bufnr,
    desc = "toggle lsp inlay hints for this go file",
    silent = true,
    noremap = true
  })
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
        if client.name == "gopls" then
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

  if client.name == "gopls" then
    go_codel_lens(bufnr)
    go_inlay_hints(bufnr)
  end

  set_lsp_on_save(client, bufnr)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
end

return M
