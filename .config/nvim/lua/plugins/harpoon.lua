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
        -- by default, harpoon tries to update the item
        -- in the list when you leave the buffer. As I'm
        -- using harpoon like a global bookmarks and not
        -- as a file/buffer navigator, I dont want to
        -- update saved items ever.
        ---@diagnostic disable-next-line: unused-local
        BufLeave = function(arg, list) end,
        equals = function(list_item_a, list_item_b)
          local dumpa = vim.inspect(list_item_a)
          local dumpb = vim.inspect(list_item_b)
          return dumpa == dumpb
        end,
      },
    })
  end
}
