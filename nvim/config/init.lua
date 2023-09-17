-- configure lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	-- TODO: ensure that ssh is installed. Otherwise
	-- error about module 'lazy' not found may appear
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

-- plugins are now defined inside of lua/plugins.lua
-- or inside of lua/plugins folder
require("lazy").setup("plugins", {
	git = {
		-- lazy.nvim uses tons of calls to github to check all kind of plugins which
		-- results into plenty of rate limit errors. To avoid that, we configure lazy
		-- to use git protocol (which will use ssh key) so it will act as an authenticated
		-- user with increased rate limit.
		url_format = "git@github.com:%s.git",
	},
	checker = {
		enabled = true,
		frequency = 86400, -- check for updates every day
		concurrency = 4, -- check at most 4 plugins concurrently
		notify = true, -- notify about plugin updates
	},
	change_detection = {
		enabled = true, -- automatically check for config file changes and reload the ui
		notify = true, -- get a notification when changes are found
	},
	defaults = { lazy = true },
	install = { missing = true },
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})

require("config").setup()
