local opt = vim.opt
local wo = vim.wo
local g = vim.g

-- spaces, tabs, dif symbols


opt.list = true
opt.listchars = {
	eol = '↲', -- End of line
	trail = '·', -- Trailing whitespace
	tab = '→ ', -- Tabs
	nbsp = '␣', -- Non-breaking spaces
	extends = '▶', -- Line continues to the right
	precedes = '◀', -- Line continues to the left
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
vim.opt.mouse = 'a' -- Enable mouse in all modes

-- ============================================================================
-- JetBrains/Ghostty-like visual style
-- ============================================================================

-- Cursor and current line
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number,line"

-- Smooth scrolling
vim.opt.smoothscroll = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Better UI
vim.opt.pumheight = 15   -- Popup menu height
vim.opt.pumblend = 10    -- Popup menu transparency
vim.opt.winblend = 10    -- Floating window transparency
vim.opt.showmode = false -- Don't show mode (lualine shows it)
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.laststatus = 3 -- Global statusline

-- Better search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = false -- Use tabs (change to true for spaces)
vim.opt.smartindent = true
vim.opt.autoindent = true

-- File handling
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"

-- Performance
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Window borders (rounded style like Ghostty)
vim.opt.fillchars = {
	vert = '│',
	horiz = '─',
	horizup = '┴',
	horizdown = '┬',
	vertleft = '┤',
	vertright = '├',
	verthoriz = '┼',
	eob = ' ', -- Hide ~ at end of buffer
	fold = ' ',
	foldsep = ' ',
}

-- Sign column always visible (prevents text shift)
vim.opt.signcolumn = "yes"

-- Color column for code width guide
vim.opt.colorcolumn = "120"

-- Apply highlights after colorscheme loads
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		-- Window separator (subtle but visible)
		vim.api.nvim_set_hl(0, 'WinSeparator', { fg = '#45475a', bold = false })

		-- Cursor line (subtle highlight)
		vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#313244' })
		vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#cba6f7', bold = true })

		-- Floating windows with border
		vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#1e1e2e' })
		vim.api.nvim_set_hl(0, 'FloatBorder', { fg = '#89b4fa', bg = '#1e1e2e' })

		-- Popup menu
		vim.api.nvim_set_hl(0, 'Pmenu', { bg = '#1e1e2e' })
		vim.api.nvim_set_hl(0, 'PmenuSel', { bg = '#45475a', bold = true })

		-- Color column (subtle)
		vim.api.nvim_set_hl(0, 'ColorColumn', { bg = '#181825' })

		-- Inlay hints (subtle, like JetBrains)
		vim.api.nvim_set_hl(0, 'LspInlayHint', { fg = '#6c7086', italic = true })
	end,
})

-- Trigger for initial load
vim.api.nvim_set_hl(0, 'WinSeparator', { fg = '#45475a', bold = false })

require("apascualco.lazy")

require("apascualco.plugins.catppuccin")
require("apascualco.plugins.nvim-tree")
require("apascualco.plugins.treesitter")
require("apascualco.plugins.lualine")

require("apascualco.plugins.lsp.mason")
require("apascualco.plugins.lsp.autocompletion")

require("apascualco.plugins.lsp.tsserver")

require("apascualco.plugins.lsp.rust")

require("apascualco.plugins.dap")
require("apascualco.plugins.bufferline")

require("apascualco.keybinding")
require("apascualco.diagnostics")

require("apascualco.onsave")
