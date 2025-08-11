return {
  "lewis6991/gitsigns.nvim",
  dependencies = { "folke/which-key.nvim" },
  event = "BufWinEnter",
  opts = {
    on_attach = function(bufnr)
      local gs = require("gitsigns")
      local wk = require("which-key")
      local function map(mode, lhs, desc, rhs, opts)
        local spec = { lhs, rhs }
        for k, v in pairs(opts or {}) do spec[k] = v end
        spec.mode = mode
        spec.desc = desc
        spec.buffer = bufnr
        wk.add(spec)
      end

      -- Navigation
      map('n', ']c', 'Go to next hunk', function()
        if vim.wo.diff then
          vim.cmd.normal({ '[c', bang = true })
        else
          gs.nav_hunk('next')
        end
      end, { expr = true })

      map('n', '[c', 'Go to next hunk', function()
        if vim.wo.diff then
          vim.cmd.normal({ '[c', bang = true })
        else
          gs.nav_hunk('prev')
        end
      end, { expr = true })

      -- Actions
      map('n', '<leader>hs', "Stage hunk", gs.stage_hunk)
      map('v', '<leader>hs', "Stage hunk", function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end)
      map('n', '<leader>hr', "Reset hunk", gs.reset_hunk)
      map('v', '<leader>hr', "Reset hunk", function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end)

      map('n', '<leader>hS', "Stage buffer", function() gs.stage_buffer() end)
      map('n', '<leader>hR', "Reset buffer", function() gs.reset_buffer() end)

      map('n', '<leader>hp', "Preview hunk", gs.preview_hunk)
      map('n', '<leader>hi', "Preview hunk inline", gs.preview_hunk_inline)

      map('n', '<leader>hb', "Blame line", function() gs.blame_line({ full = true }) end)
      map('n', '<leader>hd', "Diff this", gs.diffthis)
      map('n', '<leader>hD', "Diff buffer", function() gs.diffthis("~") end)

      -- Toggles
      map('n', '<leader>tb', "Toggle current line blame", gs.toggle_current_line_blame)
      map('n', '<leader>tw', "Toggle word diff", gs.toggle_word_diff)

      -- Text object
      map({ 'o', 'x' }, 'ih', "Select hunk", gs.select_hunk)
    end,
  }
}
