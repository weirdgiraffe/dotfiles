return {
  'milanglacier/minuet-ai.nvim',
  dependencies = {
    { "nvim-lua/plenary.nvim" },
  },
  config = function()
    require("minuet").setup({
      cmp = { enable_auto_complete = false },
      blink = { enable_auto_complete = true },
      provider = 'codestral',
      notify = 'warn',
      provider_options = {
        codestral = {
          model = 'codestral-latest',
          end_point = 'https://codestral.mistral.ai/v1/fim/completions',
          api_key = 'CODESTRAL_API_KEY',
          stream = true,
          optional = {
            max_tokens = 256,
            stop = { '\n\n' },
          },
        },
      },
      virtualtext = {
        auto_trigger_ft = { 'go' },
        keymap = {
          accept = '<C-l>',
          accept_line = nil,
          accept_n_lines = nil,
          prev = '<M-[>',
          next = '<M-]>',
          dismiss = '<C-e>',
        },
        show_on_completion_menu = false,
      },
      -- Make the ghost text disappear quickly if it doesn't match what you type
      after_cursor_filter_length = 15,
      before_cursor_filter_length = 1,
      debounce = 400,
      throttle = 800,
      request_timeout = 3,
    })
  end
}
