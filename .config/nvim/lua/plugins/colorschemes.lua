-- all of the installed colorschemes
return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    config = function()
      require('kanagawa').setup({
        compile = false,  -- enable compiling the colorscheme
        undercurl = true, -- enable undercurls
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = false },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = false,   -- do not set background color
        dimInactive = false,   -- dim inactive window `:h hl-NormalNC`
        terminalColors = true, -- define vim.g.terminal_color_{0,17}
        colors = {             -- add/modify theme and palette colors
          palette = {},
          theme = {
            wave = {},
            lotus = {},
            dragon = {},
            all = {
              ui = {
                bg_gutter = "none",
              }
            },
          },
        },
        overrides = function(colors) -- add/modify highlights
          return {}
        end,
        theme = "wave",  -- Load "wave" theme when 'background' option is not set
        background = {   -- map the value of 'background' option to a theme
          dark = "wave", -- try "dragon" !
          light = "lotus"
        },
      })
    end,
  },
  {
    'sainnhe/everforest',
    priority = 999,
    config = function()
      vim.g.everforest_background = "hard"
      vim.g.everforest_better_performance = 1
      vim.cmd([[colorscheme everforest]])
    end,
  }
}
