-- this file contains everything related to the colorscheme setup of nvim
-- ideally just one single colorscheme. It may be more than one, but the
-- default one should be defined with lazy=false and priority=1000, so it
-- will load on editor start.
return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
  },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      contrast = "hard",
      italic = {
        strings = false,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
      },
      overrides = {
        SignColumn = { bg = "none" } -- remove annoying highlighting for git gutter
        -- TODO: nice to change the default magenta like color for values
        -- and comments to something nicer like orange
      },
    },
  },
}
