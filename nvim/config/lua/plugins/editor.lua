-- Disable Ex mode, i.e compatibility mode with ex editor
-- reference: https://vimdoc.sourceforge.net/htmldoc/intro.html#Ex
vim.api.nvim_set_keymap("n", "Q", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gQ", "<Nop>", { noremap = true, silent = true })

-- disable mouse in all modes
vim.opt.mouse = ""

-- disable cursor styling, i.e. always use block shaped cursor
vim.opt.guicursor = ""

-- set leader key to ,
vim.g.mapleader = ","

-- allow switch off from modified buffers. that allows to use buffers instead of tabs
vim.opt.hidden = true

-- setup tmux colors compatibility, i.e. allow 256 colors
vim.go.termguicolors = true

-- configure clipboard to not use registers but to use system clipboard instead.
-- here is the good explanation how vim/nvim clipboard works: https://stackoverflow.com/a/30691754/1208553
vim.opt_global.clipboard = { "unnamed", "unnamedplus" }

-- configure search
vim.opt.ignorecase = true -- ignore case if search with /,? etc.
vim.opt.smartcase = true -- make search case sensitive if uppercase in search pattern
vim.opt.showmatch = true -- show matching bracets
vim.opt.hlsearch = true -- highlight all search results by default (to clean use :noh)

-- configure special characters
vim.opt.listchars = {
	eol = "↴",
	tab = ">-",
	trail = ".",
	extends = ">",
	precedes = "<",
	space = "⋅",
	nbsp = "%",
}
vim.opt.showbreak = "^"

-- configure filename pattern to ignore for filename completion
vim.opt.wildignore = {
	".DS_Store",
	"*.jpg",
	"*.jpeg",
	"*.gif",
	"*.png",
	"*.psd",
	"*.o",
	"*.obj",
	"*.min.js",
	"*.pyc",
	"*/__pycache_/*",
	"*/.git/*",
	"*/.hg/*",
	"*/.svn/*",
	"*.gz",
	"*.bz",
	"*.tar",
	"*.tar.gz",
	"*.tar.bz",
	"*.tgz",
	"*.tbz",
	"*.lzma",
	"*.zip",
	"*.rar",
	"*.iso",
}

-- autocomplete full file names, don't pick anything automatically
vim.opt.wildmode = {
	"full",
	"list:full",
}

-- min number of lines to keep above/bellow current line
vim.opt.scrolloff = 20

-- ensure that syntax highlighting is enabled
vim.opt.syntax = "enable"

-- turn off syntax coloring after 300 symbols in one line
vim.opt.synmaxcol = 300

-- enable intendation based on filetype plugins
vim.cmd("filetype plugin indent on")

-- do not fold first 20 levels when open a file
vim.opt.foldlevel = 20

-- do folding based on syntax
vim.opt.foldmethod = "syntax"

-- vertical split focus on the right pane
vim.opt.splitright = true

-- horisontal split focus on the bottom pane
vim.opt.splitbelow = true

-- automaticaly indent based of filetype
vim.opt.autoindent = true

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
