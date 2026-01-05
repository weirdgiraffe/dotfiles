return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    { "MunifTanjim/nui.nvim" },
    {
      "rcarriga/nvim-notify",
      opts = {
        render = "compact",
        style = "fade",
        background_colour = "#000000",
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
    local macro_group = vim.api.nvim_create_augroup("MacroRecording", { clear = true })
    vim.api.nvim_create_autocmd("RecordingEnter", {
      group = macro_group,
      callback = function()
        vim.notify("Recording to @" .. vim.fn.reg_recording(), vim.log.levels.INFO, { title = "Macro" })
      end,
    })
    vim.api.nvim_create_autocmd("RecordingLeave", {
      group = macro_group,
      callback = function()
        vim.notify("Recording stopped", vim.log.levels.INFO, { title = "Macro" })
      end,
    })
  end
}
