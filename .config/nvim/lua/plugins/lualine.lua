local function theme()
  return require("lualine.utils.loader").load_theme("auto")
end

return {
  "nvim-lualine/lualine.nvim",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    'milanglacier/minuet-ai.nvim',
  },
  config = function()
    require("lualine").setup({
      options = {
        theme = theme,
        icons_enabled = true,
        component_separators = "",
        -- section_separators = { left = '', right = '' },
        section_separators = "",
      },
      -- in the tabline I would like to show the list of open buffers
      -- at the same time I would like to show buffer numbers for the
      -- open buffers and enable switch between open buffers using
      -- leader + number keyboard shortcut
      tabline = {
        lualine_a = {
          { "buffers", mode = 2, },
        },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      sections = {
        lualine_a = {
          {
            function() return ' ' end,
            padding = { left = 1, right = 1 },
          },
        },
        lualine_b = {
          'branch',
          'diff',
          {
            'diagnostics',
            sources = { 'nvim_workspace_diagnostic' },
            sections = { 'error', 'warn' },
            colored = true,
            update_in_insert = false,
            symbols = { error = " ", warn = " " },
          },
        },
        lualine_c = {
          { 'filename', path = 3 },
        },
        lualine_x = {},
        lualine_y = {
          {
            require('minuet.lualine'),
            display_on_idle = true,
            display_name = "provider",
            -- the follwing is the default configuration
            -- the name displayed in the lualine. Set to "provider", "model" or "both"
            -- display_name = 'both',
            -- separator between provider and model name for option "both"
            -- provider_model_separator = ':',
            -- whether show display_name when no completion requests are active
            -- display_on_idle = false,
          },
          'encoding',
          'fileformat',
          'filetype'
        },
        -- lualine_z = { 'location' },
        lualine_z = {
          { 'selectioncount', color = 'Search' },
          { 'progress' },
          { 'location' },
        },
      },
    })
  end
}
