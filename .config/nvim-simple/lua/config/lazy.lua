local stdpath = require("config.stdpath")
local lazypath = stdpath.data .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  print("lazy.nvim does not exists yet. trying to git clone")
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "git@github.com:folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- check: https://lazy.folke.io/configuration
require("lazy").setup({
  root = stdpath.data .. "/lazy", -- directory where plugins will be installed
  defaults = { lazy = true },
  spec = "plugins",
  lockfile = stdpath.config .. "/lazy-lock.json",
  git = {
    --[[
    lazy.nvim uses tons of calls to github to check all kind of plugins which
    results into plenty of rate limit errors. To avoid that, we configure lazy
    to use git protocol (which will use ssh key) so it will act as an authenticated
    user with increased rate limit.
    --]]
    url_format = "git@github.com:%s.git",
  },
  pkg = {
    cache = stdpath.state .. "/lazy/pkg-cache.lua",
  },
  rocks = {
    root = stdpath.data .. "/lazy-rocks",
  },
  install = {
    missing = true,
  },
  checker = {
    enabled = true,
    frequency = 86400, -- check for updates every day
    concurrency = 4,   -- check at most 4 plugins concurrently
    notify = false,    -- notify about plugin updates
  },
  change_detection = {
    enabled = true, -- automatically check for config file changes and reload the ui
    notify = false, -- get a notification when changes are found
  },
  readme = {
    root = stdpath.state .. "/lazy/readme",
  },
  state = stdpath.state .. "/lazy/state.json",
})
