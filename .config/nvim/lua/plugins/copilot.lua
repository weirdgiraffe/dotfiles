local stdpath = require("config.stdpath")
-- NOTE: I would like to somehow disable the telemetry
return {
  "zbirenbaum/copilot.lua",
  event = "InsertEnter",
  config = function()
    require("copilot").setup({
      -- copilot_node_command = { "node", "--trace-warnings" },
      -- server_opts_overrides = {
      --   capabilities = {
      --     general = {
      --       positionEncodings = { "utf-16" }
      --     }
      --   }
      --   -- settings = {
      --   --   telemetry = {
      --   --     telemetryLevel = "off"
      --   --   }
      --   -- }
      -- },
      logger = {
        file = stdpath.log .. "/copilot-lua.log",
        file_log_level = vim.log.levels.WARN,
        log_lsp_messages = true,
        trace_lsp = "verbose",
      },
      panel = { enabled = false },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
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
