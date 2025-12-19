local opt = vim.opt
local wo = vim.wo
local g = vim.g

-- spaces, tabs, dif symbols


opt.list = true
opt.listchars = {
	eol = '↲',          -- Salto de línea
	trail = '·',        -- Espacios al final de línea (trailing whitespace)
	tab = '→ ',         -- Tabulaciones
	nbsp = '␣',         -- Non-breaking spaces
	extends = '▶',      -- Línea continúa a la derecha
	precedes = '◀',     -- Línea continúa a la izquierda
}

wo.relativenumber = true
wo.number = true

g.mapleader = ","

-- Disable unused providers to avoid warnings
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
g.loaded_node_provider = 0

vim.opt.wrap = false
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.termguicolors = true
vim.opt.mouse = 'a'  -- Enable mouse in all modes

require("apascualco.lazy")

require("apascualco.plugins.catppuccin")
require("apascualco.plugins.nvim-tree")
require("apascualco.plugins.treesitter")
require("apascualco.plugins.lualine")

require("apascualco.plugins.lsp.mason")
require("apascualco.plugins.lsp.autocompletion")

require("apascualco.plugins.lsp.go")
require("apascualco.plugins.lsp.tsserver")

require("apascualco.plugins.dap")
require("apascualco.plugins.bufferline")

require("apascualco.keybinding")
require("apascualco.console")
require("apascualco.diagnostics")

require("apascualco.onsave")
require("apascualco.test")
