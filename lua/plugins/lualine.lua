local function theme()
  local auto = require("lualine.utils.loader").load_theme("auto")
  if vim.g.colors_name == "everforest" then
    -- prevent constant background changes
    auto.insert.b.bg = auto.normal.b.bg
  end
  return auto
end

local function section_b_color()
  local mode_suffix = require("lualine.highlight").get_mode_suffix()
  local hl = vim.api.nvim_get_hl(0, {
    name = "lualine_b" .. mode_suffix,
    create = false,
  })
  local format = function(c)
    if c then
      return c < 256 and c or ("#%06x"):format(c)
    end
  end
  return {
    fg = format(hl.fg),
    bg = format(hl.bg),
  }
end

return {
  "nvim-lualine/lualine.nvim",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons"
  },
  config = function()
    require('lualine').setup({
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
            color = section_b_color,
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
        lualine_y = { 'encoding', 'fileformat', 'filetype', 'progress' },
        -- lualine_z = { 'location' },
        lualine_z = {
          { 'location', color = section_b_color },
        },
      },
    })
  end,
}
