local M = {}

local function append_file(filename, text)
	local out = io.open(vim.fn.expand(filename), "a+")
	out:write(text)
	out:close()
end

local function fmt_attr_color(name, hlID, what)
	return name .. vim.fn.synIDattr(vim.fn.hlID(hlID), what)
end

function M.fzf_colors()
	return fmt_attr_color("fg:", "Normal", "fg")
		.. fmt_attr_color(",bg:", "Normal", "bg")
		.. fmt_attr_color(",hl:", "Comment", "fg")
		.. fmt_attr_color(",fg+:", "LineNr", "fg")
		.. fmt_attr_color(",bg+:", "CursorLine", "bg")
		.. fmt_attr_color(",hl+:", "Statement", "fg")
		.. fmt_attr_color(",info:", "PreProc", "fg")
		.. fmt_attr_color(",prompt:", "Conditional", "fg")
		.. fmt_attr_color(",pointer:", "Exception", "fg")
		.. fmt_attr_color(",marker:", "Keyword", "fg")
		.. fmt_attr_color(",spinner:", "Label", "fg")
		.. fmt_attr_color(",header:", "Comment", "fg")
		.. fmt_attr_color(",gutter:", "Normal", "bg")
end

function M.export_fzf_colors(filename)
	local color = M.fzf_colors()
	options = "export FZF_DEFAULT_OPTS=\"${FZF_DEFAULT_OPTS} --color='" .. color .. "'\"\n"
	print("appending fzf color options to " .. filename)
	print(options)
	append_file(filename, options)
end

function M.export_kitty_colors(filename)
	text = fmt_attr_color("background ", "Normal", "bg") .. "\n"
	text = text .. fmt_attr_color("foreground ", "Normal", "fg") .. "\n"
	text = text .. fmt_attr_color("selection_background ", "Normal", "fg") .. "\n"
	text = text .. fmt_attr_color("selection_foreground ", "Normal", "bg") .. "\n"
	text = text .. "cursor " .. vim.api.nvim_get_var("terminal_color_2") .. "\n"
	text = text .. "\n\n"

	local count = 0
	while count < 16 do
		local var = "terminal_color_" .. count
		local value = vim.api.nvim_get_var(var)
		text = text .. "color" .. count .. " " .. value .. "\n"
		count = count + 1
	end

	print("writing kitty colors to " .. filename)
	print(text)
	append_file(filename, text)
end

function M.setup()
	print("settting up colors")
	vim.api.nvim_create_user_command("ExportColorsFzf", function(opts)
		M.export_fzf_colors(opts.args)
	end, { nargs = 1, force = true })

	vim.api.nvim_create_user_command("ExportColorsKitty", function(opts)
		M.export_kitty_colors(opts.args)
	end, { nargs = 1, force = true })
end

return M
