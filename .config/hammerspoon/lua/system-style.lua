local cmd = require("lua.utils").cmd

---get current system style
---@return string system style (dark orlight)
local function get_system_style()
  local dark_mode = cmd([[osascript -e '
  tell application "System Events"
    tell appearance preferences
      return dark mode
    end tell
  end tell']])
  if dark_mode == "true\n" then
    return "dark"
  else
    return "light"
  end
end

local M = {
  style = get_system_style(),
  interval = 5, -- 5 seconds
  on_style_change = nil,
}

function M.check_style()
  local style = get_system_style()
  if style ~= M.style then
    M.style = style
    if M.on_style_change then
      M.on_style_change(style)
    end
  end
end

local timer = nil
return {
  config = function(opts)
    if opts.on_style_change then
      if timer then
        timer:stop()
      else
        local check = function()
          local ok, err = pcall(M.check_style)
          if not ok then
            print("failed to check system style: " .. err)
          end
        end
        timer = hs.timer.new(M.interval, check)
      end
      M.on_style_change = opts.on_style_change
      timer:start()
    end
  end
}
