-- I don't like telescope because it feels buggy to me, so I stick with my favorite FZF
-- NOTE: need ripgrep installed
-- NOTE: need fd installed
return {
	{
		"ibhagwan/fzf-lua",
		lazy = false,
		requires = {
			"junegunn/fzf",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			local fzf = require("fzf-lua")
			fzf.setup({
				fzf_opts = {
					["--color"] = require("config.colors").fzf_colors(),
				},
			})
		end,
	},
	{
		"junegunn/fzf",
		build = "./install --bin",
		lazy = false,
	},
}
