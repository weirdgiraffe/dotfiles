-- all of the installed colorschemes
return {
  {
    'neanias/everforest-nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require("everforest").setup({
        background = "hard",
        transparent_background_level = 2,
      })
    end
  }
}
