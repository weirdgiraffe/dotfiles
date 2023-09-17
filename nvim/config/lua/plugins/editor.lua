return {
	{
		"nvim-tree/nvim-web-devicons",
		event = "VeryLazy",
	},
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

			-- close all buffers but current by <leader>bq
			vim.keymap.set("n", "<leader>bq", function()
				local this_buffer = vim.fn.bufnr("%")
				local last_buffer = vim.fn.bufnr("$")

				local curr_buffer = 1
				while curr_buffer <= last_buffer do
					if curr_buffer == this_buffer then
						goto continue
					end

					-- skip all kind of special buffers
					if vim.fn.buflisted(curr_buffer) == 0 then
						goto continue
					end

					if vim.fn.getbufvar(curr_buffer, "&modified") == 0 then
						vim.cmd.bdel(curr_buffer)
						print("deleted buffer #", curr_buffer)
					else
						print("modified buffer #", curr_buffer)
					end

					::continue::
					curr_buffer = curr_buffer + 1
				end
			end, { silent = true, noremap = true })

			-- configure mapping for buffers: <Leader>1 will switch to buffer 1,
			-- <Leader>2 to buffer 2 and so on up to buffer 9
			for i = 1, 9, 1 do
				vim.api.nvim_set_keymap("n", "<Leader>" .. i, "", {
					silent = true,
					callback = function()
						require("lualine.components.buffers").buffer_jump(i, "<bang>")
					end,
				})
			end
		end,
	},
}
