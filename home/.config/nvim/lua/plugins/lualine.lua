return {
  "nvim-lualine/lualine.nvim",
  lazy = false,
  priority = 999,
  dependencies = {
    "nvim-tree/nvim-web-devicons"
  },
  config = function()
    require('lualine').setup({
      options = {
        icons_enabled = true,
        theme = 'auto',
      },
      -- in the tabline I would like to show the list of open buffers
      -- at the same time I would like to show buffer numbers for the
      -- open buffers and enable switch between open buffers using
      -- leader + number keyboard shortcut
      tabline = {
        lualine_a = { { "buffers", mode = 2 } },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = {
          'branch', 'diff',
          {
            'diagnostics',
            sources = { 'nvim_workspace_diagnostic' },
            sections = { 'error', 'warn' },
            colored = true,
            update_in_insert = false,
            symbols = { error = '🔴 ', warn = '🟡 ' },
          }
        },
        lualine_c = {
          {
            'filename',
            path = 1, --[[ 0: Just the filename
                         1: Relative path
                         2: Absolute path
                         3: Absolute path, with tilde as the home directory
                         4: Filename and parent dir, with tilde as the home
                            directory
                      ]] --
          },
        },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
      },
    })
  end,
}
