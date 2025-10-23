return {
  'milanglacier/minuet-ai.nvim',
  dependencies = {
    { "nvim-lua/plenary.nvim" },
  },
  config = function()
    require("minuet").setup({
      cmp = { enable_auto_complete = false },
      blink = { enable_auto_complete = true },
      provider = 'openai_fim_compatible',
      notify = 'warn',
      context_window = 512,
      n_completions = 2,
      add_single_line_entry = true, -- ensures a single-line option is always present
      throttle = 500,               -- ms; minimum gap between requests (increase if needed)
      debounce = 500,               -- ms; wait after you stop typing before sending
      provider_options = {
        openai_fim_compatible = {
          api_key = 'TERM',
          name = 'Ollama',
          end_point = 'http://localhost:11434/v1/completions',
          model = 'qwen2.5-coder:7b',
          optional = {
            max_tokens = 56,
            top_p = 0.9,
          },
        },
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
        claude = {
          max_tokens = 512,
          model = 'claude-3-5-haiku-20241022',
          stream = true,
          api_key = 'ANTHROPIC_API_KEY',
          end_point = 'https://api.anthropic.com/v1/messages',
          optional = {
            max_tokens = 256,
            top_p = 0.9,
          },
        },
      },
      virtualtext = {
        auto_trigger_ft = { 'go' },
        keymap = {
          accept = '<M-l>',
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
      -- Make requests infrequently
      request_timeout = 3.0, -- seconds
    })
  end
}
