local M = {}

--- Converts symbols to quickfix list items.
---
---@param ctx lsp.HandlerContext context of lsp.Handler
---@param symbols lsp.DocumentSymbol[]|lsp.SymbolInformation[] list of symbols
---@param bufnr? integer buffer handle or 0 for current, defaults to current
function M.symbols_to_items(ctx, symbols, bufnr)
  if vim.fn.has "nvim-0.11" == 1 then
    local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
    return vim.lsp.util.symbols_to_items(symbols or {}, bufnr, client.offset_encoding) or {}
  end
  return vim.lsp.util.symbols_to_items(symbols or {}, bufnr) or {}
end

return M
