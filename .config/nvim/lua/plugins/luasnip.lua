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
  end,
}
