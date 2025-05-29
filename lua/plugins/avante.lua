return {
  "yetone/avante.nvim",
  dependencies = {
    { "nvim-treesitter/nvim-treesitter" },
    { "stevearc/dressing.nvim" },
    { "nvim-lua/plenary.nvim" },
    { "MunifTanjim/nui.nvim" },
    { "nvim-tree/nvim-web-devicons" },
    { "zbirenbaum/copilot.lua" },
    {
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          use_absolute_path = true,
        },
      },
    },
    {
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { "Avante" },
        bullet = { right_pad = 1 },
      },
      ft = { "markdown", "Avante" },
    },
  },
  event = "VeryLazy",
  build = "make",
  opts = {
    provider = "copilot",
    mappings = {
      submit = {
        normal = "<CR>",
        insert = "<C-l>",
      },
    }
  },
  init = function()
    vim.opt.laststatus = 3
  end,
}
