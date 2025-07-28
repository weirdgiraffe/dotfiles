-- list of file paths to be hidden
local hidden = {
  [".git"] = true,
}

return {
  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      skip_confirm_for_simple_edits = true,
      win_options = {
        wrap = true,
        signcolumn = "yes:2",
      },
      view_options = {
        -- Show files and directories that start with "."
        show_hidden = true,
        -- This function defines what is considered a "hidden" file
        is_always_hidden = function(name) return hidden[name] or false end,
      },
      columns = { "icon" },
    },
  },
  {
    "refractalize/oil-git-status.nvim",
    dependencies = { "stevearc/oil.nvim" },
    lazy = false,
    config = true,
  },
}
