return {
  "iamcco/markdown-preview.nvim",
  ft = { "markdown" },
  cmd = {
    "MarkdownPreviewToggle",
    "MarkdownPreview",
    "MarkdownPreviewStop"
  },
  build = function(plugin)
    if vim.fn.executable "npx" then
      vim.cmd("!cd " .. plugin.dir .. " && cd app && npx --yes yarn install")
    else
      vim.cmd [[Lazy load markdown-preview.nvim]]
      vim.fn["mkdp#util#install"]()
    end
  end,
  init = function()
    vim.g.mkdp_theme = "dark"
    if vim.fn.executable "npx" then vim.g.mkdp_filetypes = { "markdown" } end
  end,
}
