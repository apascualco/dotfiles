require("nvim-treesitter").setup({})

local ensure_installed = {
	"bash",
	"c",
	"cmake",
	"css",
	"cpp",
	"comment",
	"dap_repl",
	"diff",
	"dockerfile",
	"gitignore",
	"git_rebase",
	"go",
	"gomod",
	"gowork",
	"gosum",
	"gotmpl",
	"html",
	"java",
	"json",
	"json5",
	"kotlin",
	"lua",
	"make",
	"markdown",
	"markdown_inline",
	"python",
	"regex",
	"ruby",
	"rust",
	"scala",
	"scss",
	"slint",
	"tsx",
	"toml",
	"sql",
	"vim",
	"vimdoc",
	"yaml",
	"terraform",
	"javascript",
	"typescript",
}

local installing = false
local function install_missing()
	if installing then return end
	local ok, config = pcall(require, "nvim-treesitter.config")
	if not ok then return end
	local installed = config.get_installed() or {}
	local to_install = vim.tbl_filter(function(lang)
		return not vim.list_contains(installed, lang)
	end, ensure_installed)
	if #to_install == 0 then return end
	installing = true
	require("nvim-treesitter").install(to_install)
	installing = false
end

vim.api.nvim_create_autocmd("User", {
	pattern = "TSUpdate",
	callback = install_missing,
})

install_missing()

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local ft = vim.bo[args.buf].filetype
		if ft == "" or ft == "NvimTree" then return end
		local lang = vim.treesitter.language.get_lang(ft)
		if not lang then return end
		if not pcall(vim.treesitter.language.add, lang) then return end
		pcall(vim.treesitter.start, args.buf, lang)
	end,
})
