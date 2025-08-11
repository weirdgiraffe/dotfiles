return {
  "hrsh7th/nvim-cmp",
  lazy = false,
  -- event = "BufWinEnter",
  dependencies = {
    { "hrsh7th/cmp-nvim-lsp" }, -- Required
    { "L3MON4D3/LuaSnip" },     -- Required
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "saadparwaiz1/cmp_luasnip" },
  },
  config = function(_, opts)
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local custom = require("customize.cmp")

    cmp.setup.global({
      ---@diagnostic disable-next-line: missing-fields
      performance = {
        debounce = 60,           -- Wait 60ms before sending requests
        throttle = 30,           -- Wait 30ms between suggestios update.
        fetching_timeout = 1000, -- Give up if a source takes 1s
      }
    })

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      sources = cmp.config.sources({
        -- look for the snippets first
        { name = "luasnip", keyword_length = 1 },
      }, {
        -- if no snippets found, look for the LSP completions
        {
          name = "nvim_lsp",
          -- ingnore lsp snippets
          entry_filter = function(entry, _)
            local kind = entry:get_kind()
            return kind ~= require("cmp.types").lsp.CompletionItemKind.Snippet
          end,
        },
      }, {
        -- if neither is available, look for the buffer and path completions
        { name = "buffer" },
        { name = "path" },
      }),
      completion = { autocomplete = false },
      mapping = custom.mapping.buffer,
      sorting = custom.sorting,
      preselect = cmp.PreselectMode.None,
    })

    cmp.setup.cmdline(":", {
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        {
          name = "cmdline",
          option = {
            ignore_cmds = { "Man", "!" },
          },
          entry_filter = function(entry, _)
            local ignore_completions = {
              "edit",
              "write", "wall",
              "quit", "qall", "quitall",
              "wq", "wqall",
              "bd", "bdelete",
              "bn", "bnext",
              "bp", "bprevious",
            }
            return not vim.tbl_contains(ignore_completions, entry.word)
          end,
          keyword_length = 1,
        },
      }),
      completion = { autocomplete = { cmp.TriggerEvent.TextChanged } },
      mapping = custom.mapping.cmdline,
    })

    local copilot_available, suggestion = pcall(require, 'copilot.suggestion')
    if copilot_available then
      cmp.event:on("menu_opened", function()
        suggestion.dismiss()
        vim.b.copilot_suggestion_hidden = true
      end)
      cmp.event:on("menu_closed", function()
        vim.b.copilot_suggestion_hidden = false
      end)
    end
  end,
}
