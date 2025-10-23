-- all of the installed colorschemes
return {
  {
    "neanias/everforest-nvim",
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("everforest").setup({
        background = "hard",
        transparent_background_level = 2,
      })
    end
  },
  { "nyoom-engineering/oxocarbon.nvim" }
}
