require("lua.system-style").config({
  on_style_change = function(style)
    hs.alert.show("changing style to " .. style)
    require("lua.auto-style").set_kitty_style(style)
    require("lua.auto-style").set_fzf_style(style)
    require("lua.auto-style").set_nvim_style(style)
  end
})

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "W", function()
  hs.alert.show("Hello World!")
end)
