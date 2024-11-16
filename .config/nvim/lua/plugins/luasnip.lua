return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  build = "make install_jsregexp",
  config = function()
    local luasnip = require("luasnip")

    vim.snippet.expand = luasnip.lsp_expand

    ---@diagnostic disable-next-line: duplicate-set-field
    vim.snippet.active = function(filter)
      filter = filter or {}
      filter.direction = filter.direction or 1

      if filter.direction == 1 then
        return luasnip.expand_or_jumpable()
      else
        return luasnip.jumpable(filter.direction)
      end
    end

    ---@diagnostic disable-next-line: duplicate-set-field
    vim.snippet.jump = function(direction)
      if direction == 1 then
        if luasnip.expandable() then
          return luasnip.expand_or_jump()
        else
          return luasnip.jumpable(1) and luasnip.jump(1)
        end
      else
        return luasnip.jumpable(-1) and luasnip.jump(-1)
      end
    end

    vim.snippet.stop = luasnip.unlink_current

    luasnip.config.set_config {
      history = true,
      updateevents = "TextChanged,TextChangedI",
      override_builtin = true,
      region_check_events = "InsertEnter",
      delete_check_events = "TextChanged,InsertLeave",
    }

    local snippet_dir = vim.fn.stdpath("config") .. "/snippets/vscode"
    require("luasnip.loaders.from_vscode").lazy_load({ paths = snippet_dir })
  end,
}
