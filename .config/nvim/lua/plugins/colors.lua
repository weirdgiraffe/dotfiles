-- all of the installed colorschemes
return {
  {
    'sainnhe/everforest',
    lazy = true,
    config = function()
      vim.g.everforest_background = "hard"
      vim.g.everforest_better_performance = 1
    end,
  }
}
