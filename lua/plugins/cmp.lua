return {
  "hrsh7th/nvim-cmp",
  event = "BufWinEnter",
  dependencies = {
    { "hrsh7th/cmp-nvim-lsp" }, -- Required
    {
      "L3MON4D3/LuaSnip",
      build = "make install_jsregexp"
    }, -- Required
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "saadparwaiz1/cmp_luasnip" },
  },
  config = function(_, opts)
    local cmp = require("cmp")

    local snipppets_path = require("stdpath").config .. "/snippets/vscode"
    require("luasnip.loaders.from_vscode").lazy_load(snipppets_path)

    cmp.setup({
      completion = { autocomplete = false },
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      sources = cmp.config.sources({
        -- primary source
        { name = "nvim_lsp", priority = 10, keyword_length = 1 },
        { name = "luasnip",  priority = 5,  keyword_length = 2 },
      }, {
        -- fallback sources
        { name = "buffer", keyword_length = 3, max_item_count = 5 },
        { name = "path" },
      }),
      preselect = cmp.PreselectMode.None,
      mapping = require("customize").cmp.mapping.insert,
      sorting = require("customize").cmp.sorting,
    })

    cmp.setup.cmdline("/", {
      mapping = require("customize").cmp.mapping.cmdline,
      sources = {
        { name = "buffer" },
      },
    })

    cmp.setup.cmdline(":", {
      completion = {
        autocomplete = {
          require('cmp.types').cmp.TriggerEvent.TextChanged,
        },
      },
      mapping = require("customize").cmp.mapping.cmdline,
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
