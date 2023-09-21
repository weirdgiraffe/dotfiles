return {
	{
		"ray-x/go.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"ray-x/guihua.lua",
		},
		event = { "CmdlineEnter" },
		ft = { "go", "gomod" },
		build = ':lua require("go.install").update_all_sync()',
		priority = 1000,
		config = function()
			require("go").setup({
        -- <logging>
				verbose = false,
				log_path = "/tmp/nvimgo.log",
        -- </logging>
        -- <lsp>
				lsp_cfg = true, -- let nvim.go to configure gopls
				lsp_keymaps = false, -- disable default lsp keymaps
        lsp_codelens = true,
				lsp_inlay_hints = {
					enable = true,
				},
        -- </lsp>
				comment_placeholder = "", -- let coments be clean initially
				run_in_floaterm = false,
				trouble = false,
				auto_lint = false,
				auto_format = false,
			})
		end
	}
}
