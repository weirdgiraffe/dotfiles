return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    -- add any options here
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    { "MunifTanjim/nui.nvim" },
    {
      "rcarriga/nvim-notify",
      opts = {
        render = "compact",
        style = "fade",
      }
    },
  },
  config = function()
    require("noice").setup({
      presets = {
        bottom_search         = true, -- use a classic bottom cmdline for search
        inc_rename            = true, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border        = true, -- add a border to hover docs and signature help
        long_message_to_split = true, -- long messages will be sent to a split
      },
    })
  end,
}
