local log = require("util.log").new({
  name = "jupytext.lua",
  log_level = vim.log.levels.INFO,
})
return {
  "GCBallesteros/jupytext.nvim",
  ft = { "ipnb" },
  lazy = false,
  init = function()
    local command = [[pip install jupytext]]
    local output = {}
    local job = vim.fn.jobstart(command, {
      on_stdout = function(_, data, _)
        table.insert(output, data[1])
      end,
      on_stderr = function(_, data, _)
        table.insert(output, data[1])
      end,
      on_exit = function(_, exitCode, _)
        if exitCode == 0 then
          log.debug("jupytext installed")
        else
          log.error(table.concat(output, "\n"))
          log.error("failed to install jupytext")
        end
      end
    })
  end,
  config = function()
    require("jupytext").setup({
      style = "hydrogen"
    })
  end
  -- Depending on your nvim distro or config you may need to make the loading not lazy
  -- lazy=false,
}
