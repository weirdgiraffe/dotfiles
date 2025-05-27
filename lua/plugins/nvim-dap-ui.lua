return {
  {
    "folke/lazydev.nvim",
    opts = function(_, opts)
      vim.print("nvim-dap-ui: extending lazydev")
      opts.library = opts.library or {}
      table.insert(opts.library, "nvim-dap-ui")
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "folke/lazydev.nvim",
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    }
  },
}
