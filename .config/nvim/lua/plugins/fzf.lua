local function attr_color(what, hlID)
  if type(hlID) == "table" then
    for _, id in ipairs(hlID) do
      local val = vim.fn.synIDattr(vim.fn.hlID(id), what)
      if val then return val end
    end
  else
    return vim.fn.synIDattr(vim.fn.hlID(hlID), what)
  end
end

local function fzf_colors(opts)
  local colors = {
    "fg:" .. attr_color("fg", "Normal"),
    "bg:" .. attr_color("bg", "Normal"),
    "hl:" .. attr_color("fg", "Comment"),
    "fg+:" .. attr_color("fg", { "CursorLine", "CursorColumn", "Normal" }),
    "bg+:" .. attr_color("bg", { "Normal", "CursorLine", "CursorColumn" }),
    "hl+:" .. attr_color("fg", "Statement"),
    "info:" .. attr_color("fg", "PreProc"),
    "border:" .. attr_color("fg", "Ignore"),
    "prompt:" .. attr_color("fg", "Conditional"),
    "pointer:" .. attr_color("fg", "Exception"),
    "marker:" .. attr_color("fg", "Keyword"),
    "spinner:" .. attr_color("fg", "Label"),
    "header:" .. attr_color("fg", "Comment"),
  }
  return vim.o.background .. "," .. table.concat(colors, ",")
end

vim.api.nvim_create_user_command("FzfColors", function()
  vim.print([[export FZF_DEFAULT_OPTS="]])
  vim.print("--color=" .. fzf_colors())
  vim.print([["]])
end, { nargs = 0, force = true })

-- NOTE: needs ripgrep
-- NOTE: needs fd
return {
  "ibhagwan/fzf-lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local fzf = require("fzf-lua")

    local opts = {
      -- fixup file icon padding for kitty
      -- https://github.com/ibhagwan/fzf-lua/wiki#icon-padding-for-terminals-with-double-width-icon-support
      file_icon_padding = " ",
      fzf_opts = {
        ["--color"] = fzf_colors(),
      },
      keymap = {
        builtin = {
          ["<S-j>"]   = "preview-page-down",
          ["<S-k>"]   = "preview-page-up",
          ["<M-S-j>"] = "preview-down",
          ["<M-S-k>"] = "preview-up",
        },
      }
    }
    fzf.setup(opts)

    local reload_colors = function()
      fzf.setup({
        fzf_opts = {
          ["--color"] = fzf_colors()
        }
      })
    end

    local group = vim.api.nvim_create_augroup("_fzf-lua:reload-colors", { clear = true })
    vim.api.nvim_create_autocmd("OptionSet", {
      group = group,
      pattern = "background",
      callback = reload_colors,
      desc = "change fzf-lua colors on background change",
    })
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = group,
      callback = reload_colors,
      desc = "change fzf-lua colors on colorscheme change",
    })
  end,
}
