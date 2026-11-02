local ok_bl, bufferline = pcall(require, "bufferline")
if not ok_bl then return end

local highlights = {}
local ok_cat, cat = pcall(require, "catppuccin.special.bufferline")
if ok_cat and cat and type(cat.get_theme) == "function" then
	highlights = cat.get_theme()
end

bufferline.setup({
	highlights = highlights,
	options = {
		mode = "buffers",
		diagnostics = "nvim_lsp",
		separator_style = "slope",
		show_buffer_close_icons = true,
		show_close_icon = true,
		always_show_bufferline = true,
		color_icons = true,
		offsets = {
			{ filetype = "NvimTree", text = "File Explorer", highlight = "Directory", separator = true },
		},
	},
})