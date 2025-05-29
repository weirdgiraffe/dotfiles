return {
  "stevearc/oil.nvim",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    skip_confirm_for_simple_edits = true,
    win_options = { wrap = true },
    view_options = {
      -- Show files and directories that start with "."
      show_hidden = true,
      -- This function defines what is considered a "hidden" file
      is_always_hidden = function(name)
        local hidden = {
          [".git"] = true,
        }
        return hidden[name] or false
      end,
    },
    columns = {
      "icon",
      -- "permissions",
      -- "size",
      -- "mtime",
    },
  },
}
