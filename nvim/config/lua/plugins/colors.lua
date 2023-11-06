-- this file contains everything related to the colorscheme setup of nvim
-- ideally just one single colorscheme. It may be more than one, but the
-- default one should be defined with lazy=false and priority=1000, so it
-- will load on editor start.
return {
	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd([[set background=light]])
			vim.cmd([[colorscheme rose-pine]])
		end,
	},
}
