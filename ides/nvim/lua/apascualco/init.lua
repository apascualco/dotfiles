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

-- Folding via Treesitter (supports imports, functions, methods, blocks)
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldtext = ""

-- Auto-close import folds when opening a file
vim.api.nvim_create_autocmd("BufWinEnter", {
	callback = function()
		-- Wait for treesitter folds to be computed
		vim.defer_fn(function()
			if not vim.api.nvim_buf_is_valid(vim.api.nvim_get_current_buf()) then return end
			local ft = vim.bo.filetype
			local patterns = {
				go = "^import",
				java = "^import%s",
				typescript = "^import%s",
				javascript = "^import%s",
				typescriptreact = "^import%s",
				javascriptreact = "^import%s",
				python = "^import%s",
				rust = "^use%s",
			}
			-- Also match "from" for python
			local pattern = patterns[ft]
			if not pattern then return end

			local total = vim.api.nvim_buf_line_count(0)
			for lnum = 1, math.min(total, 100) do
				local line = vim.fn.getline(lnum)
				local is_import = line:match(pattern)
				if not is_import and ft == "python" then
					is_import = line:match("^from%s")
				end
				if is_import then
					-- Close the fold on this line
					pcall(vim.cmd, lnum .. "foldclose")
				end
			end
		end, 150)
	end,
})


require("apascualco.lazy")

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
