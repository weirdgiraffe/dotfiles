local having = require("util.modules").having

local function append_file(filename, text)
  local out, err = io.open(vim.fn.expand(filename), "a+")
  if out then
    out:write(text)
    out:close()
  else
    error("failed to open file " .. filename .. " for writing: " .. err)
  end
end

local function fmt_attr_color(name, hlID, what)
  return name .. vim.fn.synIDattr(vim.fn.hlID(hlID), what)
end

local function fzf_colors()
  local colors = {
    fmt_attr_color("fg:", "Normal", "fg"),
    fmt_attr_color("bg:", "Normal", "bg"),
    fmt_attr_color("hl:", "Comment", "fg"),
    fmt_attr_color("fg+:", "LineNr", "fg"),
    fmt_attr_color("bg+:", "CursorLine", "bg"),
    fmt_attr_color("hl+:", "Statement", "fg"),
    fmt_attr_color("info:", "PreProc", "fg"),
    fmt_attr_color("prompt:", "Conditional", "fg"),
    fmt_attr_color("pointer:", "Exception", "fg"),
    fmt_attr_color("marker:", "Keyword", "fg"),
    fmt_attr_color("spinner:", "Label", "fg"),
    fmt_attr_color("header:", "Comment", "fg"),
    fmt_attr_color("gutter:", "Normal", "bg"),
  }
  return table.concat(colors, ",")
end

local function export_fzf_colors(filename)
  local color = fzf_colors()
  local options = "export FZF_DEFAULT_OPTS=\"${FZF_DEFAULT_OPTS} --color='" .. color .. "'\"\n"
  print("writing fzf colors to " .. filename)
  append_file(filename, options)
end

local function kitty_colors()
  local base = {
    fmt_attr_color("background ", "Normal", "bg"),
    fmt_attr_color("foreground ", "Normal", "fg"),
    fmt_attr_color("selection_background ", "Normal", "fg"),
    fmt_attr_color("selection_foreground ", "Normal", "bg"),
    fmt_attr_color("cursor ", "Cursor", "bg"),
    fmt_attr_color("cursor_text_color ", "Cursor", "fg"),
  }

  local count = 0
  local colors = {}
  while count < 16 do
    local value = vim.api.nvim_get_var(("terminal_color_%d"):format(count))
    table.insert(colors, ("color%d %s"):format(count, value))
    count = count + 1
  end

  return "# basic colors\n\n" ..
      table.concat(base, "\n") ..
      "\n\n# base16 colors\n\n" ..
      table.concat(colors, "\n")
end


local function export_kitty_colors(filename)
  local colors = kitty_colors()
  print("writing kitty colors to " .. filename)
  append_file(filename, colors)
end

local M = {}

function M.fzf()
  return fzf_colors()
end

-- sets vim colorscheme and background
---@param background string dark|light
local function set_colorscheme(background)
  if background == "dark" then
    vim.cmd([[set background=dark]])
  else
    vim.cmd([[set background=light]])
  end
  vim.cmd([[colorscheme gruvbox]])

  -- regenerate colors for fzf
  having("fzf-lua", function(fzf)
    fzf.setup({
      fzf_opts = {
        ["--color"] = fzf_colors(),
      },
    })
  end)

  -- to ensure the focus switch I need to drop the
  -- background color for the normal and float windows
  -- and rely on the terminal colors
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

-- sets colorscheme based on system appearance
local function set_system_colorscheme()
  local defaultBackground = "light"
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
  local status = vim.fn.jobwait({ job }, timeoutMs)
  if status[1] ~= 0 and systemBackground == "" then
    set_colorscheme(defaultBackground)
  end
end



function M.setup()
  if vim.fn.has('macunix') then
    set_system_colorscheme()
  else
    set_colorscheme("light")
  end

  vim.api.nvim_create_user_command("SetColorscheme", function(opts)
    set_colorscheme(opts.args)
  end, { nargs = 1, force = true })
  vim.api.nvim_create_user_command("ExportColorsFzf", function(opts)
    export_fzf_colors(opts.args)
  end, { nargs = 1, force = true })
  vim.api.nvim_create_user_command("ExportColorsKitty", function(opts)
    export_kitty_colors(opts.args)
  end, { nargs = 1, force = true })
end

return M
