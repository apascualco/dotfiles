local wo = vim.wo
local opt = vim.opt
local g = vim.g


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

opt.guicursor = 'i:block,i:blinkon1'

-- Avoid last \n on nvim
opt.fixendofline = false
opt.wrap = false
opt.backup = false

-- TABS/SPACES
opt.expandtab = true
opt.autoindent = true
opt.tabstop = 2 
opt.shiftwidth = 2

require("apascualco.packer")

require("apascualco.nvim-tree")
require("apascualco.catppuccin")
require("apascualco.treesitter")
require("apascualco.telescope")

require("apascualco.custom-config-lsp")
require("apascualco.set")
require("apascualco.dap")

g.mapleader = ","

g.gitgutter_map_keys = 0
g.gitgutter_enable = 1
g.gitgutter_highlight_linenrs = 1
g.gitgutter_set_sign_backgrounds = 1
g.gitgutter_highlight_lines = 1
g.gitgutter_highlight_linenrs = 0

g.loaded_perl_provider = 0

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
