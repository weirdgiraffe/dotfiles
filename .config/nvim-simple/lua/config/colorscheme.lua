local background = {
  file_path = nil,
  default = nil,
}

background.store = function()
  assert(background.file_path, "background.file_path is not set")
  local file = io.open(background.file_path, "wb")
  if file then
    file:write(vim.o.background)
    file:close()
  end
end

background.load = function()
  assert(background.file_path, "background.file_path is not set")
  assert(background.default, "background.default is not set")
  local file = io.open(background.file_path, "rb")
  if file then
    local val = file:read("*all")
    file:close()
    if val == "dark" or val == "light" then
      return val
    end
  end
  return background.default
end

background.setup = function(opts)
  background.file_path = opts.file_path or vim.fn.stdpath("state") .. "/background.conf"
  background.default = opts.default or "dark"
  local group = vim.api.nvim_create_augroup("_girafe:background", { clear = true })
  vim.api.nvim_create_autocmd("OptionSet", {
    group = group,
    pattern = "background",
    callback = background.store,
    desc = "store current background",
  })
end

background.setup({ default = "dark" })

-- sets vim colorscheme and background
---@param bg string? dark|light
local function set_colorscheme(bg)
  if bg == "dark" then
    -- need to ensure that everforest dark hard
    if vim.g.colors_name == "everforest" then
      vim.g.everforest_background = "hard"
    end
    vim.cmd("set background=dark")
  else
    -- need to ensure that everforest light medium
    if vim.g.colors_name == "everforest" then
      vim.g.everforest_background = "medium"
    end
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

vim.o.background = background.load()
set_colorscheme(vim.o.background)
set_system_colorscheme()

vim.api.nvim_create_user_command("SetColorscheme", function(opts)
  set_colorscheme(opts.args)
end, { nargs = 1, force = true, desc = "set colorscheme" })

vim.cmd([[colorscheme everforest]])
