return {
  "hrsh7th/vim-vsnip",
  config = function()
    vim.g.vsnip_snippet_dir = vim.fn.stdpath("config") .. "/snippets/vsnip"
  end,
}
