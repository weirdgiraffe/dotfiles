return {
	{
		"nvim-lualine/lualine.nvim",
		lazy = false,
		priority = 999,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = "rose-pine",
				},
				-- in the tabline I would like to show the list of open buffers
				-- at the same time I would like to show buffer numbers for the
				-- open buffers and enable switch between open buffers using
				-- leader + number keyboard shortcut
				tabline = {
					lualine_a = { { "buffers", mode = 2 } },
					lualine_b = {},
					lualine_c = {},
					lualine_x = {},
				lualine_y = {},
					lualine_z = {},
				},
			})
		end,
	},
	{
		-- NOTE: require ripgrep
		-- NOTE: require fd
		"ibhagwan/fzf-lua",
		lazy = false,
		requires = {
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
		"nvim-tree/nvim-web-devicons",
		event = "VeryLazy",
	},
}
