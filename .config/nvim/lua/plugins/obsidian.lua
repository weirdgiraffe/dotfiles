local Path = require("plenary.path")

---@type table
local workspaces = {
  {
    name = "default",
    path = Path:new("~/Obsidian/unsorted"):expand(),
  },
  {
    name = "crypto",
    path = Path:new("~/Obsidian/crypto"):expand(),
  },
  {
    name = "chronicle",
    path = Path:new("~/Obsidian/chronicle"):expand(),
  },
}

local function workspaces_paths()
  local l = {}
  for _, workspace in ipairs(workspaces) do
    table.insert(l, workspace.path)
  end
  return l
end

return {
  "epwalsh/obsidian.nvim",
  version = "2.10.0", -- note: fixed version, no upgrades
  lazy = false,
  event = {
    "BufReadPre " .. table.concat(workspaces_paths(), ","),
    "BufNewFile " .. table.concat(workspaces_paths(), ","),
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    -- TODO: maybe somehow set conceallevel only for the windows with
    -- obsidian documents.
    vim.o.conceallevel = 2 -- required for the obsidian ui
    --lint:ignore
    require("obsidian").setup({
      workspaces = workspaces,
      log_level = vim.log.levels.INFO,
      notes_subdir = "notes", -- where to store the notes

      -- customize how names/IDs for new notes are created.
      note_id_func = function(title)
        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
        -- In this case a note with the title 'My new note' will be given an ID that looks
        -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
        local suffix = ""
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return os.date("%Y%m%d") .. "-" .. suffix
      end,

      -- customize the default name or prefix when pasting images via `:ObsidianPasteImg`.
      image_name_func = function()
        -- Prefix image names with timestamp.
        return string.format("%s-", os.date("%Y%m%d"))
      end,

      attachments = {
        img_folder = "assets", -- This is the default
      },

      ui = {
        enable = true,         -- set to false to disable all additional syntax features
        update_debounce = 200, -- update delay after a text change (in milliseconds)
        -- Define how various check-boxes are displayed
        checkboxes = {
          -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
          [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
          ["x"] = { char = "", hl_group = "ObsidianDone" },
          [">"] = { char = "", hl_group = "ObsidianRightArrow" },
          ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
          -- Replace the above with this if you don't have a patched font:
          -- [" "] = { char = "☐", hl_group = "ObsidianTodo" },
          -- ["x"] = { char = "✔", hl_group = "ObsidianDone" },

          -- You can also add more custom ones...
        },
        -- Use bullet marks for non-checkbox lists.
        bullets = { char = "•", hl_group = "ObsidianBullet" },
        external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
        -- Replace the above with this if you don't have a patched font:
        -- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
        reference_text = { hl_group = "ObsidianRefText" },
        highlight_text = { hl_group = "ObsidianHighlightText" },
        tags = { hl_group = "ObsidianTag" },
        hl_groups = {
          -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
          ObsidianTodo = { bold = true, fg = "#f78c6c" },
          ObsidianDone = { bold = true, fg = "#89ddff" },
          ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
          ObsidianTilde = { bold = true, fg = "#ff5370" },
          ObsidianBullet = { bold = true, fg = "#89ddff" },
          ObsidianRefText = { underline = true, fg = "#c792ea" },
          ObsidianExtLinkIcon = { fg = "#c792ea" },
          ObsidianTag = { italic = true, fg = "#89ddff" },
          ObsidianHighlightText = { bg = "#75662e" },
        },
      },
    })
  end,
}
