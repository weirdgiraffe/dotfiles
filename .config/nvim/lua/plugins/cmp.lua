return {
  "hrsh7th/nvim-cmp",
  event = "BufWinEnter",
  dependencies = {
    { "hrsh7th/cmp-nvim-lsp" }, -- Required
    {
      "L3MON4D3/LuaSnip",
      lazy = false,
      build = "make install_jsregexp",
      config = function()
        local path = require("config.stdpath").config .. "/snippets/vscode"
        require("luasnip.loaders.from_vscode").lazy_load({
          paths = { path },
        })
      end,
    }, -- Required
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "saadparwaiz1/cmp_luasnip" },
  },
  config = function(_, opts)
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local custom = require("customize.cmp")

    cmp.setup.buffer({
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
          keyword_length = 2,
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
      mapping = custom.mapping.insert,
      sorting = custom.sorting,
      preselect = cmp.PreselectMode.None,
      completion = { autocomplete = false },
    })

    cmp.setup.cmdline("/", {
      mapping = custom.mapping.cmdline,
      sources = {
        { name = "buffer" },
      },
    })

    cmp.setup.cmdline(":", {
      completion = {
        autocomplete = {
          -- require('cmp.types').cmp.TriggerEvent.TextChanged,
          cmp.TriggerEvent.TextChanged,
        },
      },
      mapping = custom.mapping.cmdline,
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        {
          name = "cmdline",
          option = {
            ignore_cmds = { "Man", "!" },
          },
          keyword_length = 4,
        },
      }),
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
