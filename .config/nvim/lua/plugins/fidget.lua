local function truncate(msg, additional)
  local win_line_len = vim.api.nvim_win_get_width(0)
  local max_line_len = (win_line_len * 0.3) - additional
  return require("plenary.strings").truncate(msg, max_line_len, "...", 0)
end

local function truncate_roots_scanned(item)
  if not item then
    return
  end
  assert(item.key == "rustAnalyzer/Roots Scanned", "item.key is not rustAnalyzer/Roots Scanned")
  assert(item.annote, "item.annote is nil")
  assert(item.message, "item.message is nil")
  item.message = item.message:gsub(
    "(%d+/%d+:) (.+) (%(.+)$",
    function(prefix, message, suffix)
      local additional = item.annote:len() + suffix:len()
      local p = require("plenary.path"):new(message):normalize()
      local truncated = truncate(p, additional)
      return string.format("%s %s", truncated, suffix)
    end)
end

local function truncate_indexing(item)
  if not item then
    return
  end
  assert(item.key == "rustAnalyzer/Indexing", "item.key is not rustAnalyzer/Indexing")
  assert(item.annote, "item.annote is nil")
  assert(item.message, "item.message is nil")
  item.message = item.message:gsub(
    "(%d+/%d+) (.+) (%(.+)$",
    function(_, message, suffix)
      return string.format("%s %s", message, suffix)
    end)
end


return {
  "j-hui/fidget.nvim",
  version = "1.4.5",
  event = "LspAttach",
  config = function()
    require("fidget").setup({
      progress = {
        display = {
          progress_icon = {
            pattern = "meter",
            period = 1,
          },
          overrides = { -- Override options from the default notification config
            ["rust-analyzer"] = {
              update_hook = function(item)
                if item.key == "rustAnalyzer/Roots Scanned" then
                  truncate_roots_scanned(item)
                end
                if item.key == "rustAnalyzer/Indexing" then
                  truncate_indexing(item)
                end
                require("fidget.notification").set_content_key(item)
              end,
            },
          },
        },
      },
      notification = {
        override_vim_notify = true, -- use fidget as vim.notify
        window = {
          winblend = 0,             -- make notifications background transparent
          align = "top",            -- show notifications in the top right corner
        },
        view = {
          stack_upwards = false, -- show notifications from top to bottom
        }
      },
    })
    vim.api.nvim_create_user_command("Notifications", function(arg)
      require("fidget.notification").show_history()
    end, {
      desc = "Show notification history",
    })
  end,
}
