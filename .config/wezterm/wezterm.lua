-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- config.font = wezterm.font("Iosevka Nerd Font")
config.font = wezterm.font("IosevkaTerm Nerd Font")
-- config.font = wezterm.font("IosevkaTermSlab Nerd Font")
-- config.font = wezterm.font("Hack Nerd Font")
-- config.font = wezterm.font("Monofur Nerd Font")
-- config.font = wezterm.font("Source Code Pro")
-- config.font = wezterm.font("0xProto Nerd Font")
-- config.font = wezterm.font("Hasklug Nerd Font")
-- config.font = wezterm.font("EnvyCodeR Nerd Font")
-- config.font = wezterm.font("GeistMono Nerd Font")
config.font_size = 14.0

-- This is where you actually apply your config choices
local function scheme_for_appearance(appearance)
  if appearance:find("Dark") then
    return "Everforest Dark (Gogh)"
    -- return "Rosé Pine Moon (Gogh)"
  else
    return "Everforest Light (Gogh)"
    -- return "Rosé Pine Dawn (Gogh)"
  end
end

config.color_scheme                               = scheme_for_appearance(wezterm.gui.get_appearance())
config.colors                                     = { cursor_bg = '#dbbc7f' }

config.window_padding                             = {
  left = 10,
  right = 10,
  top = 10,
  bottom = 10,
}

config.window_decorations                         = "TITLE | RESIZE"
-- config.window_decorations                         = "RESIZE"
-- config.enable_tab_bar = false
config.hide_tab_bar_if_only_one_tab               = true
config.max_fps                                    = 120

config.adjust_window_size_when_changing_font_size = false
config.hide_mouse_cursor_when_typing              = true
config.exit_behavior                              = "Close"

-- configure opacity and gpu
config.front_end                                  = "WebGpu"
config.window_background_opacity                  = 0.99
config.macos_window_background_blur               = 50
config.mouse_bindings                             = {
  { -- Disable the default click behavior
    event = { Up = { streak = 1, button = "Left" } },
    mods = "NONE",
    action = wezterm.action.DisableDefaultAssignment,
  },
  { -- Cmd-click will open the link under the mouse cursor
    event = { Up = { streak = 1, button = "Left" } },
    mods = "CMD",
    action = wezterm.action.OpenLinkAtMouseCursor,
  },
  { -- Disable the Cmd-click down event to stop programs from seeing it when a URL is clicked
    event = { Down = { streak = 1, button = "Left" } },
    mods = "CMD",
    action = wezterm.action.Nop,
  },
}

config.hyperlink_rules                            = wezterm.default_hyperlink_rules()
table.insert(config.hyperlink_rules, {
  regex = "\\b(0x[0-9a-fA-F]{64})\\b",
  format = "https://etherscan.io/tx/$1",
  highlight = 1,
})
table.insert(config.hyperlink_rules, {
  regex = "\\b(0x[0-9a-fA-F]{40})\\b",
  format = "https://etherscan.io/address/$1",
  highlight = 1,
})

-- and finally, return the configuration to wezterm
return config
