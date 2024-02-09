return {
  "epwalsh/obsidian.nvim",
  version = "2.10.0", -- note: fixed version, no upgrades
  lazy = false,
  ft = "markdown",
  event = {
    "BufReadPre " .. vim.fn.expand("~") .. "/Library/CloudStorage/SynologyDrive-Obsidian/**.md",
    "BufNewFile " .. vim.fn.expand("~") .. "/Library/CloudStorage/SynologyDrive-Obsidian/**.md",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- see below for full list of optional dependencies 👇
  },
  opts = {
    workspaces = {
      {
        name = "shared",
        path = "~/Library/CloudStorage/SynologyDrive-Obsidian/",
      },
    },

    log_level = vim.log.levels.INFO,

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
      return tostring(os.time()) .. "-" .. suffix
    end,

    -- customize the default name or prefix when pasting images via `:ObsidianPasteImg`.
    image_name_func = function()
      -- Prefix image names with timestamp.
      return string.format("%s-", os.time())
    end,

    ui = {
      enable = false, -- disable advanced ui features
    },
  },
}
