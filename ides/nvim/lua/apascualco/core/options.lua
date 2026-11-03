local opt, g = vim.opt, vim.g

g.mapleader = ","
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
g.loaded_node_provider = 0

opt.list = true
opt.listchars = { eol = "↲", trail = "·", tab = "→ ", nbsp = "␣", extends = "▶", precedes = "◀" }
opt.number = true
opt.relativenumber = true
opt.wrap = false
opt.splitright = true
opt.splitbelow = true
opt.termguicolors = true
opt.mouse = "a"
opt.cursorline = true
opt.cursorlineopt = "number,line"
opt.smoothscroll = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.pumheight = 15
opt.pumblend = 10
opt.winblend = 10
opt.winborder = "rounded"
opt.showmode = false
opt.showcmd = true
opt.cmdheight = 1
opt.laststatus = 3
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = false
opt.smartindent = true
opt.autoindent = true
opt.backup = false
opt.swapfile = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undo"
opt.autoread = true
opt.updatetime = 250
opt.timeoutlen = 300
opt.fillchars = {
	vert = "│",
	horiz = "─",
	horizup = "┴",
	horizdown = "┬",
	vertleft = "┤",
	vertright = "├",
	verthoriz = "┼",
	eob = " ",
	fold = " ",
	foldsep = " ",
}
opt.signcolumn = "yes"
opt.colorcolumn = "120"
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldtext = ""
opt.completeopt = { "menu", "menuone", "noselect" }

vim.filetype.add({
	extension = { gotmpl = "gotmpl", gohtml = "gotmpl", gotxt = "gotmpl" },
	filename = {
		["buf.yaml"] = "buf-config",
		["buf.gen.yaml"] = "buf-config",
		["buf.work.yaml"] = "buf-config",
		["buf.lock"] = "buf-config",
	},
})
pcall(vim.treesitter.language.register, "yaml", "buf-config")
pcall(vim.treesitter.language.register, "json", "jsonl")
