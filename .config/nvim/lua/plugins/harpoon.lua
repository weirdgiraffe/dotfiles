return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup({
      default = {
        equals = function(list_item_a, list_item_b)
          local dumpa = vim.inspect(list_item_a)
          local dumpb = vim.inspect(list_item_b)
          return dumpa == dumpb
        end,
        autocmds = {},
      },
    })
  end
}
