return {
  'ruanyl/vim-gh-line',
  lazy = false,
  config = function()
    vim.g.gh_line_map_default = 1
    vim.g.gh_line_blame_map_default = 0
  end
}
