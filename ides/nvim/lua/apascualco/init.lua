local opt = vim.opt
local wo = vim.wo
local g = vim.g

g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

opt.list = true
opt.listchars = {
	eol = '↲',
	trail = '·',
	tab = '→ ',
	nbsp = '␣',
	extends = '▶',
	precedes = '◀',
}

wo.relativenumber = true
wo.number = true

g.mapleader = ","

g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
g.loaded_node_provider = 0

vim.filetype.add({
	extension = {
		gotmpl = "gotmpl",
		gohtml = "gotmpl",
		gotxt = "gotmpl",
	},
})

vim.opt.wrap = false
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.termguicolors = true
vim.opt.mouse = 'a'

vim.opt.cursorline = true
vim.opt.cursorlineopt = "number,line"

vim.opt.smoothscroll = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

vim.opt.pumheight = 15
vim.opt.pumblend = 10
vim.opt.winblend = 10
vim.opt.showmode = false
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.laststatus = 3

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = false
vim.opt.smartindent = true
vim.opt.autoindent = true

vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"
vim.opt.autoread = true

local refresh_external_changes_group = vim.api.nvim_create_augroup("RefreshExternalChanges", { clear = true })
local uv = vim.uv or vim.loop
local last_external_refresh = 0

local function refresh_external_changes(args)
	if vim.fn.mode() ~= "n" then return end

	if args and args.event == "BufEnter" then
		pcall(vim.cmd, "silent! checktime")
		return
	end

	if uv and uv.now then
		local now = uv.now()
		if (now - last_external_refresh) < 400 then return end
		last_external_refresh = now
	end

	vim.schedule(function()
		if vim.fn.mode() ~= "n" then return end

		pcall(vim.cmd, "silent! checktime")

		local ok_gitsigns, gitsigns = pcall(require, "gitsigns")
		if ok_gitsigns then pcall(gitsigns.refresh) end

		local ok_tree, api = pcall(require, "nvim-tree.api")
		if ok_tree and api.tree.is_visible() then
			pcall(api.tree.reload)
		end
	end)
end

vim.api.nvim_create_user_command("RefreshExternalChanges", function() refresh_external_changes() end, {
	desc = "Refresh files and git UI after external changes",
})

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "TermClose", "TermLeave", "ShellCmdPost" }, {
	group = refresh_external_changes_group,
	callback = refresh_external_changes,
})

vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

vim.opt.fillchars = {
	vert = '│',
	horiz = '─',
	horizup = '┴',
	horizdown = '┬',
	vertleft = '┤',
	vertright = '├',
	verthoriz = '┼',
	eob = ' ',
	fold = ' ',
	foldsep = ' ',
}

vim.opt.signcolumn = "yes"

vim.opt.colorcolumn = "120"

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldtext = ""

vim.api.nvim_create_autocmd("BufWinEnter", {
	callback = function(args)
		local buf = args.buf
		if vim.b[buf].import_folds_done then return end
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
		local ft = vim.bo[buf].filetype
		local pattern = patterns[ft]
		if not pattern then return end
		vim.b[buf].import_folds_done = true

		vim.defer_fn(function()
			if not vim.api.nvim_buf_is_valid(buf) then return end
			local total = vim.api.nvim_buf_line_count(buf)
			for lnum = 1, math.min(total, 100) do
				local line = vim.fn.getline(lnum)
				local is_import = line:match(pattern)
				if not is_import and ft == "python" then
					is_import = line:match("^from%s")
				end
				if is_import then
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
require("apascualco.plugins.lsp.go")
require("apascualco.plugins.lsp.proto")
require("apascualco.plugins.lsp.python")
require("apascualco.plugins.lsp.java")

require("apascualco.plugins.bufferline")

require("apascualco.keybinding")
require("apascualco.diagnostics")

require("apascualco.onsave")

require("apascualco.jsonl")
