local wo = vim.wo
local opt = vim.opt
local g = vim.g

g.coc_global_config = "$HOME/.config/coc/coc-settings.json"
g.gitgutter_map_keys = 0
g.gitgutter_enable = 1
g.gitgutter_highlight_linenrs = 1
g.gitgutter_set_sign_backgrounds = 1
g.gitgutter_highlight_lines = 1
g.gitgutter_highlight_linenrs = 0

wo.relativenumber = true
wo.number = true

opt.colorcolumn = "120"

-- spaces, tabs, dif symbols
opt.list = true
opt.listchars = {
	eol = '⤶',
	space = '.',
	trail = '~',
	precedes = '◀',
	extends = '▶',
	tab = '>>'
}
-- set list listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:.

opt.guicursor = 'i:block,i:blinkon1'

-- Avoid last \n on nvim
opt.fixendofline = false
opt.wrap = false
opt.backup = false

require("apascualco.packer")
require("apascualco.nvim-tree")
require("apascualco.coc")
require("apascualco.catppuccin")
require("apascualco.airline")
require("apascualco.treesitter")
-- require("apascualco.plug")
require("apascualco.set")

local api = vim.api
local augroup = api.nvim_create_augroup
local autocmd = api.nvim_create_autocmd
local highlight = vim.highlight

autocmd('TextYankPost', {
	group = augroup('HighlightYank', {}),
	pattern = '*',
	callback = function()
		highlight.on_yank({
			higroup = 'IncSearch',
			timeout = 700,
		})
	end,
})
