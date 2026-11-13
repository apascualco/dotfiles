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
	"proto",
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
	"latex",
	"typst",
	"svelte",
	"vue",
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local installing = false
			local function install_missing()
				if installing then
					return
				end
				local ok, config = pcall(require, "nvim-treesitter.config")
				if not ok then
					return
				end
				local installed = config.get_installed() or {}
				local missing = vim.tbl_filter(function(lang)
					return not vim.list_contains(installed, lang)
				end, ensure_installed)
				if #missing == 0 then
					return
				end
				installing = true
				require("nvim-treesitter").install(missing)
				installing = false
			end

			vim.api.nvim_create_autocmd("User", { pattern = "TSUpdate", callback = install_missing })
			install_missing()

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("TreesitterStart", { clear = true }),
				callback = function(args)
					local ft = vim.bo[args.buf].filetype
					if ft == "" or ft == "NvimTree" then
						return
					end
					local lang = vim.treesitter.language.get_lang(ft)
					if not lang or not pcall(vim.treesitter.language.add, lang) then
						return
					end
					pcall(vim.treesitter.start, args.buf, lang)
					pcall(function()
						vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end)
				end,
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = { lookahead = true },
				move = { set_jumps = true },
			})
			local select = require("nvim-treesitter-textobjects.select")
			local move = require("nvim-treesitter-textobjects.move")
			for lhs, capture in pairs({
				af = "@function.outer",
				["if"] = "@function.inner",
				ac = "@class.outer",
				ic = "@class.inner",
				aa = "@parameter.outer",
				ia = "@parameter.inner",
			}) do
				vim.keymap.set({ "x", "o" }, lhs, function()
					select.select_textobject(capture, "textobjects")
				end, { desc = (capture:match("outer$") and "Around " or "Inside ") .. capture:match("^@(%a+)") })
			end
			local function mv(lhs, fn, desc)
				vim.keymap.set({ "n", "x", "o" }, lhs, function()
					move[fn]("@function.outer", "textobjects")
				end, { desc = desc })
			end
			mv("]f", "goto_next_start", "Next function start")
			mv("[f", "goto_previous_start", "Previous function start")
			mv("]F", "goto_next_end", "Next function end")
			mv("[F", "goto_previous_end", "Previous function end")
		end,
	},
}
