-- sets vim colorscheme and background
---@param background string? dark|light
local function set_colorscheme(background)
  if background == "dark" then
    vim.cmd("set background=dark")
  else
    vim.cmd("set background=light")
  end
  -- to ensure the focus switch I need to drop the
  -- background color for the normal and float windows
  -- and rely on the terminal colors
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end


-- sets colorscheme based on system appearance
local function set_system_colorscheme()
  local command = [[osascript -e '
  tell application "System Events"
    tell appearance preferences
      return dark mode
    end tell
  end tell']]
  local systemBackground = ""
  local job = vim.fn.jobstart(command, {
    on_stdout = function(_, data, _)
      if systemBackground == "" then
        systemBackground = data[1] == "true" and "dark" or "light"
        set_colorscheme(systemBackground)
      end
    end
  })
  local timeoutMs = 300
  vim.fn.jobwait({ job }, timeoutMs)
end


set_colorscheme(vim.o.background)
set_system_colorscheme()

vim.api.nvim_create_user_command("SetColorscheme", function(opts)
  set_colorscheme(opts.args)
end, { nargs = 1, force = true, desc = "set colorscheme" })
