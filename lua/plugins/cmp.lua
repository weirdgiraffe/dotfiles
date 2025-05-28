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

    -- TODO: figure out how to load snippers
    require("luasnip.loaders.from_vscode").lazy_load(require("stdpath").config .. "/snippets/vscode")

    cmp.setup.cmdline("/", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        {
          name = "cmdline",
          option = {
            ignore_cmds = { "Man", "!" },
          },
        },
      }),
    })

    cmp.setup({
      completion = { autocomplete = false },
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      sources = {
        { name = "nvim_lsp", priority = 400 },
        { name = "luasnip",  priority = 30, keyword_length = 2 },
        { name = "buffer",   priority = 2,  keyword_length = 3, max_item_count = 5 },
        { name = "path",     priority = 1 },
      },
      preselect = cmp.PreselectMode.None,
      mapping = require("customize").cmp.mapping,
      sorting = require("customize").cmp.sorting,
    })
  end,
}
