local cmd = require("lua.utils").cmd

local tmpdir = os.tmpname():gsub("(.*)/.*$", "%1")

--- get name of nvim server pipe
---@return table filename for nvim server pipe
local function nvim_server_pipe()
  -- quite a tricky way to enumerate all running nvim
  -- server instances. but it should be portable
  local s = cmd([[fd -t s "nvim.*.0" "$(mktemp -u| sed 's#[^/]*$##')"| grep $(whoami)]])
  local t = {}
  for token in string.gmatch(s, "([^\n]+)") do
    table.insert(t, token)
  end
  return t
end

local M = {}

--- set background for all existing nvim instances
---@param background string style "light" or "dark"
function M.set_nvim_style(background)
  local pipes = nvim_server_pipe()
  local nvim_command = ([[<cmd>SetColorscheme %s<CR>]]):format(background)
  print("command: " .. nvim_command)
  for _, pipe in pairs(pipes) do
    local command = ([[nvim --server "%s" --remote-send "%s"]]):format(pipe, nvim_command)
    pcall(function() cmd(command) end)
  end
end

local fzf_theme = {
  --  dark = [[themes/gruvbox-dark-hard.sh]],
  --  light = [[themes/gruvbox-light-hard.sh]],
  --
  --  dark = [[themes/rose-pine.sh]],
  --  light = [[themes/rose-pine-dawn.sh]],
  --
  --   dark = [[themes/kanagawa-wave.sh]],
  --   light = [[themes/kanagawa-lotus.sh]],
  dark = [[themes/everforest-dark-hard.sh]],
  light = [[themes/everforest-light-medium.sh]],
}

--- set background for all existing fzf instances
--- NOTE: it heavily depends on the way I wrap fzf
---@param background string style "light" or "dark"
function M.set_fzf_style(background)
  local conf = os.getenv("XDG_CONFIG_HOME") or os.getenv("HOME") .. "/.config/fzf"
  local theme = fzf_theme[background] or fzf_theme.light
  pcall(function()
    cmd("cd " .. conf .. " && ln -sf " .. theme .. " current-theme.zsh")
  end)
end

local kitty_theme = {
  --   dark = [[Gruvbox Dark Hard]],
  --   light = [[Gruvbox Light Hard]],
  --
  --   dark = [[Rosé Pine]],
  --   light = [[Rosé Pine Dawn]],
  --
  --   dark = [[Kanagawa-wave]],
  --   light = [[Kanagawa-lotus]],
  --
  dark = [[Everforest Dark Hard]],
  light = [[Everforest Light Medium]],
}

--- set background for FZF
---@param background string style "light" or "dark"
function M.set_kitty_style(background)
  local theme = kitty_theme[background] or kitty_theme.light
  local command = ([[kitty +kitten themes --config-file-name=themes.conf --reload-in=all %s]]):format(theme)
  pcall(function() cmd(command) end)
end

return M
