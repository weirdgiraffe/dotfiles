local stdpath = require("config.stdpath")
return {
  "zbirenbaum/copilot.lua",
  event = "InsertEnter",
  config = function()
    require("copilot").setup({
      -- server_opts_overrides = {
      --   settings = {
      --     telemetry = {
      --       telemetryLevel = "off",
      --     },
      --   },
      -- },
      logger = {
        file = stdpath.log .. "/copilot-lua.log",
        file_log_level = vim.log.levels.WARN,
        log_lsp_messages = true,
        trace_lsp = "off",
      },
      panel = { enabled = true },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 200,
        keymap = {
          accept = "<C-l>",
          accept_word = false,
          accept_line = false,
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      filetypes = {
        go = true,
        lua = true,
        gomod = true,
        gowork = true,
        gotmpl = true,
        markdown = false,
        yaml = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["*"] = false,
      },
    })
  end
}
