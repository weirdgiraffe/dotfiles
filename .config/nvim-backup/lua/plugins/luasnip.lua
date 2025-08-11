return {
  "L3MON4D3/LuaSnip",
  lazy = false,
  build = "make install_jsregexp",
  config = function()
    local path = require("config.stdpath").config .. "/snippets/vscode"
    require("luasnip.loaders.from_vscode").lazy_load({
      paths = { path },
    })

    local luasnip = require("luasnip")
    luasnip.config.set_config({
      history = true, -- keep around last snippet
      region_check_events = "InsertEnter",
      delete_check_events = "TextChanged,TextChangedI",
    })

    --
    -- -- unlink if we are not completing snippet parameters
    -- vim.api.nvim_create_autocmd("ModeChanged", {
    --   pattern = { "s:n", "i:*" },
    --   callback = function()
    --     local has_nodes = luasnip.session.current_nodes[vim.api.nvim_get_current_buf()]
    --     if has_nodes and not luasnip.session.jump_active then
    --       luasnip.unlink_current()
    --     end
    --   end,
    -- })
    --
    -- -- force unlink on <Esc> in insert mode
    -- vim.keymap.set("i", "<Esc>", function()
    --   local has_nodes = luasnip.session.current_nodes[vim.api.nvim_get_current_buf()]
    --   if has_nodes then
    --     luasnip.unlink_current()
    --   end
    --   return "<Esc>"
    -- end, { expr = true })
  end,
}
