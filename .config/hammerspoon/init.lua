hs.autoLaunch(true)
hs.menuIcon(false)
hs.automaticallyCheckForUpdates(true)

-- to reload the config, one should use
-- open -a HammerSpoon

require("lua.system-style").config({
  on_style_change = function(style)
    hs.alert.show("changing style to " .. style)
    require("lua.auto-style").set_kitty_style(style)
    require("lua.auto-style").set_fzf_style(style)
    require("lua.auto-style").set_nvim_style(style)
  end
})
