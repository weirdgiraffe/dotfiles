return {
  "L3MON4D3/LuaSnip",
  lazy = false,
  version = "v2.*",
  build = "make install_jsregexp",
  config = function()
    local snippet_dir = vim.fn.stdpath("config") .. "/snippets/vscode"
    require("luasnip.loaders.from_vscode").lazy_load({ paths = snippet_dir })
  end,
}
