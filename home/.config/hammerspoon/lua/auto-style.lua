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
  local nvim_command = ([[<cmd>set background=%s<CR>]]):format(background)
  for _, pipe in pairs(pipes) do
    local command = ([[nvim --server "%s" --remote-send "%s"]]):format(pipe, nvim_command)
    pcall(function() cmd(command) end)
  end
end

--- set background for all existing nvim instances
---@param background string style "light" or "dark"
function M.set_kitty_style(background)
  local command = [[kitty +kitten themes --reload-in=all Rosé Pine Dawn]]
  if background == "dark" then
    command = [[kitty +kitten themes --reload-in=all Rosé Pine]]
  end
  pcall(function() cmd(command) end)
end

--- set background for all existing fzf instances
--- NOTE: it heavily depends on the way I wrap fzf
---@param background string style "light" or "dark"
function M.set_fzf_style(background)
  local conf = os.getenv("XDG_CONFIG_HOME") or os.getenv("HOME") .. "/.config/fzf"
  local theme = "themes/rose-pine-dawn.sh"
  if background == "dark" then
    theme = "themes/rose-pine.sh"
  end
  pcall(function()
    cmd("cd " .. conf .. " && ln -sf " .. theme .. " current-theme.zsh")
  end)
end

--- set background for FZF
---@param background string style "light" or "dark"
function M.set_kitty_style(background)
  local command = [[kitty +kitten themes --reload-in=all Rosé Pine Dawn]]
  if background == "dark" then
    command = [[kitty +kitten themes --reload-in=all Rosé Pine]]
  end
  pcall(function() cmd(command) end)
end

return M
