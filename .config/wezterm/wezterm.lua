-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

config.font = wezterm.font("Iosevka Nerd Font Mono")
config.font_size = 14.0

-- This is where you actually apply your config choices
local function scheme_for_appearance(appearance)
  if appearance:find("Dark") then
    return "Everforest Dark (Gogh)"
  else
    return "Everforest Light (Gogh)"
  end
end
config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())

config.window_padding = {
  left = 20,
  right = 20,
  top = 10,
  bottom = 10,
}

config.enable_tab_bar = false
config.window_decorations = 'RESIZE'

config.adjust_window_size_when_changing_font_size = false
config.automatically_reload_config = true

-- and finally, return the configuration to wezterm
return config
