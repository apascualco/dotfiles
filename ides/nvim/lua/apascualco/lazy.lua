local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	'nvim-tree/nvim-tree.lua',

	'nvim-tree/nvim-web-devicons',
	{
		'catppuccin/nvim',
		name = 'catppuccin',
		priority = 1000,
		lazy = false,
		config = function()
			require("apascualco.plugins.catppuccin")
		end,
	},

	{ "nvim-treesitter/nvim-treesitter", branch = 'main',   lazy = false,   build = ":TSUpdate" },
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
				af = "@function.outer", ["if"] = "@function.inner",
				ac = "@class.outer", ic = "@class.inner",
				aa = "@parameter.outer", ia = "@parameter.inner",
			}) do
				vim.keymap.set({ "x", "o" }, lhs, function() select.select_textobject(capture, "textobjects") end,
					{ desc = (capture:match("outer$") and "Around " or "Inside ") .. capture:match("^@(%a+)") })
			end
			local function mv(lhs, fn, desc)
				vim.keymap.set({ "n", "x", "o" }, lhs, function() move[fn]("@function.outer", "textobjects") end,
					{ desc = desc })
			end
			mv("]f", "goto_next_start", "Next function start")
			mv("[f", "goto_previous_start", "Previous function start")
			mv("]F", "goto_next_end", "Next function end")
			mv("[F", "goto_previous_end", "Previous function end")
		end,
	},

	{
		'nvim-telescope/telescope.nvim',
		dependencies = {
			{ 'nvim-lua/plenary.nvim' },
			{ 'benfowler/telescope-luasnip.nvim' },
			{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
		},
		config = function()
			require('telescope').setup({
				defaults = {
					layout_strategy = 'horizontal',
					layout_config = {
						horizontal = {
							preview_width = 0.6,
							results_width = 0.4,
						},
						width = 0.9,
						height = 0.85,
					},
				},
			})
			require('telescope').load_extension('luasnip')
			require('telescope').load_extension('fzf')
		end
	},

	{
		'preservim/tagbar',
		init = function()
			vim.g.tagbar_type_go = {
				ctagstype = 'go',
				kinds = {
					'p:package',
					'c:constants',
					'v:variables',
					't:types',
					's:structs',
					'i:interfaces',
					'm:struct members',
					'n:interface methods',
					'a:type aliases',
					'f:functions',
				},
				sro = '.',
				kind2scope = {
					s = 'struct',
					i = 'interface',
					t = 'type',
				},
				scope2kind = {
					struct    = 's',
					interface = 'i',
					type      = 't',
				},
				}
		end,
	},

	{
		"neovim/nvim-lspconfig",
	},
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {},
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
	},

	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},

	{ "b0o/SchemaStore.nvim", lazy = true, ft = { "json", "jsonc", "yaml" } },

	{
		"saecki/crates.nvim",
		tag = "stable",
		event = { "BufRead Cargo.toml" },
		config = function()
			local crates = require("crates")
			crates.setup({
				completion = {
					cmp = { enabled = true },
					crates = { enabled = true },
				},
				lsp = {
					enabled = true,
					actions = true,
					completion = false,
					hover = true,
				},
			})

			local function set_keymaps(buf)
				local function m(lhs, fn, desc)
					vim.keymap.set("n", lhs, fn, { buffer = buf, silent = true, desc = desc })
				end
				m("<leader>Ct", crates.toggle,                  "Toggle inline info")
				m("<leader>Cr", crates.reload,                  "Reload")
				m("<leader>Cv", crates.show_versions_popup,     "Versions")
				m("<leader>Cf", crates.show_features_popup,     "Features")
				m("<leader>Cd", crates.show_dependencies_popup, "Dependencies")
				m("<leader>Cu", crates.update_crate,            "Update crate")
				m("<leader>Ca", crates.update_all_crates,       "Update all")
				m("<leader>CU", crates.upgrade_crate,           "Upgrade crate")
				m("<leader>CA", crates.upgrade_all_crates,      "Upgrade all")
				m("<leader>Co", crates.open_crates_io,          "Open on crates.io")
				m("<leader>CD", crates.open_documentation,      "Open docs.rs")
			end

			local cur = vim.api.nvim_get_current_buf()
			if vim.fn.fnamemodify(vim.api.nvim_buf_get_name(cur), ":t") == "Cargo.toml" then
				set_keymaps(cur)
			end
			vim.api.nvim_create_autocmd("BufRead", {
				pattern = "Cargo.toml",
				callback = function(ev) set_keymaps(ev.buf) end,
			})
		end,
	},

	{ "hrsh7th/nvim-cmp" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-nvim-lsp-signature-help" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-path" },

	{ 'onsails/lspkind.nvim' },

	{
		"milanglacier/minuet-ai.nvim",
		enabled = false,
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("apascualco.plugins.minuet")
		end,
	},

	{
		"johnseth97/codex.nvim",
		cmd = { "Codex", "CodexToggle" },
		keys = {
			{ "<leader>cx", function() require("codex").toggle() end, desc = "Toggle Codex" },
		},
		opts = {
			keymaps = { toggle = nil },
			border = "rounded",
			width = 0.4,
			autoinstall = false,
			panel = true,
		},
		config = function(_, opts)
			require("codex").setup(opts)

			local group = vim.api.nvim_create_augroup("CodexPanelRight", { clear = true })
			local function move_panel_right()
				for _, win in ipairs(vim.api.nvim_list_wins()) do
					if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "codex" then
						vim.api.nvim_win_call(win, function() vim.cmd("wincmd L") end)
						return
					end
				end
			end

			vim.api.nvim_create_autocmd({ "BufWinEnter", "WinNew" }, {
				group = group,
				callback = function()
					vim.schedule(move_panel_right)
				end,
			})
		end,
	},

	{
		'L3MON4D3/LuaSnip',
		build = 'make install_jsregexp'
	},
	{ 'saadparwaiz1/cmp_luasnip' },

	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
			}

		end,
	},
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			formatters_by_ft = {
				go = function(bufnr) return require("apascualco.goproject").go_formatters(bufnr) end,
				javascript = { "prettier" },
				javascriptreact = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				json = { "prettier" },
				jsonc = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				scss = { "prettier" },
				lua = { "stylua" },
				python = { "ruff_organize_imports", "ruff_format" },
				rust = { "rustfmt" },
				proto = { "buf" },
					["buf-config"] = { "prettier" },
			},
			format_on_save = function(bufnr)
				local ignore_filetypes = { "sql", "java" }
				if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
					return
				end
				return { lsp_format = "fallback", timeout_ms = 2000 }
			end,
		},
	},

	{
		'folke/trouble.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		opts = {},
	},

	{
		"mfussenegger/nvim-dap",
		lazy = true,
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"jay-babu/mason-nvim-dap.nvim",
			"mason-org/mason.nvim",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio"
		},
		config = function()
			require("apascualco.plugins.dap")
		end,
	},
	{
		"leoluz/nvim-dap-go",
		ft = "go",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function(_, opts)
			require("dap-go").setup(opts)
			local dap = require("dap")
			for _, config in ipairs(dap.configurations.go or {}) do
				if config.request == "launch" and not config.console then
					config.console = "integratedTerminal"
				end
				if config.mode == "auto" then
					config.mode = "debug"
				end
			end
			table.insert(dap.configurations.go, {
				type = "go_remote",
				name = "Attach: Delve en Docker (:2345, make dev-debug)",
				request = "attach",
				mode = "remote",
				port = 2345,
				substitutePath = function()
					local root = vim.fs.root(0, "go.mod") or vim.fn.getcwd()
					return { { from = root, to = "/app" } }
				end,
			})
		end,
	},
	{
		"mfussenegger/nvim-dap-python",
		ft = "python",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			local debugpy = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
			require("dap-python").setup(debugpy)
		end,
	},
	{
		"LiadOz/nvim-dap-repl-highlights",
		config = function()
			require("nvim-dap-repl-highlights").setup()
		end,
	},

	{
		'nvim-lualine/lualine.nvim',
		dependencies = {
			'arkav/lualine-lsp-progress',
			'nvim-tree/nvim-web-devicons'
		},
	},

	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin/nvim" }
	},

	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
		},
		opts = {
			integrations = { diffview = true },
			graph_style = "unicode",
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("gitsigns").setup({ attach_to_untracked = true })
		end,
	},
	{
		"sindrets/diffview.nvim",
		opts = {
			hg_cmd = nil,
		},
	},

	{
		"CoreyKaylor/diffbandit.nvim",
		cmd = {
			"DiffBanditGit", "DiffBanditGitCurrent", "DiffBanditGitMenu",
			"DiffBanditGitLog", "DiffBanditGitCompare", "DiffBanditCommitPanel",
		},
		keys = {
			{ "<leader>gzm", "<cmd>DiffBanditGitMenu<CR>",                    desc = "Git menu" },
			{ "<leader>gzg", "<cmd>DiffBanditGit<CR>",                        desc = "Working tree changes" },
			{ "<leader>gzc", "<cmd>DiffBanditGitCurrent<CR>",                 desc = "Diff current file" },
			{ "<leader>gzr", "<cmd>DiffBanditGitCompare origin/main HEAD<CR>", desc = "Review branch vs main" },
			{ "<leader>gzl", "<cmd>DiffBanditGitLog<CR>",                     desc = "Commit log" },
			{ "<leader>gzp", "<cmd>DiffBanditCommitPanel<CR>",                desc = "Commit panel" },
		},
		opts = {},
		config = function(_, opts)
			require("diffbandit").setup(opts)
		end,
	},

	{
		"akinsho/git-conflict.nvim",
		version = "*",
		event = "BufReadPre",
		opts = {
			default_mappings = true,
			disable_diagnostics = true,
		},
	},

	{
		"pwntester/octo.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		cmd = "Octo",
		keys = {
			{ "<leader>Oo", "<cmd>Octo<cr>",              desc = "Octo menu" },
			{ "<leader>Op", "<cmd>Octo pr list<cr>",      desc = "Pull requests" },
			{ "<leader>OP", "<cmd>Octo pr search<cr>",    desc = "Search PRs" },
			{ "<leader>Oi", "<cmd>Octo issue list<cr>",   desc = "Issues" },
			{ "<leader>Or", "<cmd>Octo review start<cr>", desc = "Start review" },
		},
		opts = {
			picker = "telescope",
		},
	},

	{
		"numToStr/Comment.nvim",
		event = "VeryLazy",
		opts = {
			mappings = { basic = false, extra = false },
		},
		config = function(_, opts)
			require("Comment").setup(opts)
		end,
	},

	{
		"NvChad/nvim-colorizer.lua",
		event = "VeryLazy",
		opts = {
			filetypes = { "*" },
			user_default_options = {
				RGB = true,
				RRGGBB = true,
				names = true,
				RRGGBBAA = true,
				AARRGGBB = true,
				rgb_fn = true,
				hsl_fn = true,
				css = true,
				css_fn = true,
				mode = "background",
				tailwind = true,
				always_update = true,
			},
			buftypes = {},
		},
		config = function(_, opts)
			require("colorizer").setup(opts)
		end,
	},
	{
		"lewis6991/satellite.nvim",
		event = "BufReadPost",
		config = function()
			require("satellite").setup({
				current_only = false,
				winblend = 50,
				zindex = 40,
				handlers = {
					cursor = { enable = true },
					search = { enable = true },
					diagnostic = { enable = true },
					gitsigns = { enable = true },
					marks = { enable = true },
				},
			})
			local util = require("satellite.util")
			local orig_row_to_barpos = util.row_to_barpos
			util.row_to_barpos = function(winid, row)
				local pos, f = orig_row_to_barpos(winid, row)
				if pos ~= pos then return 0, 0 end
				return pos, f
			end
			local orig_height_to_virtual = util.height_to_virtual
			util.height_to_virtual = function(winid, row, row2)
				local h = orig_height_to_virtual(winid, row, row2)
				if h ~= h then return 1 end
				return h
			end
		end,
	},

	{ "ThePrimeagen/harpoon", branch = "harpoon2", dependencies = { "nvim-lua/plenary.nvim" } },
	{ "christoomey/vim-tmux-navigator", lazy = false },

	{
		"Wansmer/symbol-usage.nvim",
		event = "LspAttach",
		config = function()
			require("symbol-usage").setup({
				vt_position = "above",
				references = { enabled = true, include_declaration = false },
				definition = { enabled = false },
				implementation = { enabled = true },
			})
		end,
	},

	{
		"folke/snacks.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			notifier = { enabled = true },
			words = { enabled = true },
			input = { enabled = true },
			picker = { enabled = true },
			scroll = { enabled = true },
			dim = { enabled = true },
			zen = { enabled = true },
			image = { enabled = true },
		},
		keys = {
			{ "<leader>gy", function() Snacks.gitbrowse({ open = function(url) vim.fn.setreg("+", url); vim.notify("Permalink copiado al portapapeles") end }) end, desc = "Copy GitHub permalink" },
			{ "<leader>tz", function() Snacks.zen() end, desc = "Zen mode" },
		},
	},

	{
		"coder/claudecode.nvim",
		cmd = {
			"ClaudeCode",
			"ClaudeCodeFocus",
			"ClaudeCodeSelectModel",
			"ClaudeCodeAdd",
			"ClaudeCodeSend",
			"ClaudeCodeTreeAdd",
			"ClaudeCodeDiffAccept",
			"ClaudeCodeDiffDeny",
			"ClaudeCodeStatus",
		},
		opts = (function()
			local local_bin = vim.fn.expand("~/.claude/local/claude")
			local terminal_cmd = vim.fn.filereadable(local_bin) == 1 and local_bin or "claude"
			return {
				log_level = "info",
				terminal_cmd = terminal_cmd,
				cwd = vim.fn.getcwd(),
				git_repo_cwd = true,
				terminal = {
					split_side = "right",
					provider = "auto",
					auto_close = true,
					snacks_win_opts = {},
				},
				diff_opts = {
					auto_close_on_accept = true,
					vertical_split = true,
					open_in_current_tab = true,
					keep_terminal_focus = false,
				},
				focus_after_send = false,
				track_selection = true,
				visual_demotion_delay_ms = 50,
			}
		end)(),
		config = true,
	},

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			plugins = { spelling = true },
			spec = {
				mode = { "n", "v" },
				{ "g",          group = "goto" },
				{ "]",          group = "next" },
				{ "[",          group = "previous" },
				{ "<leader>a",  group = "claude: send, diffs, sessions" },
				{ "<leader>b",  group = "buffers: close, move, pick, sort" },
				{ "<leader>bs", group = "sort buffers" },
				{ "<leader>c",  group = "code: format, docstring, quickfix, codex" },
				{ "<leader>C",  group = "crates: versions, update (Cargo.toml)" },
				{ "<leader>D",  group = "database: drawer, connections, queries" },
				{ "<leader>d",  group = "debug: breakpoints, step, UI, REPL" },
				{ "<leader>dg", group = "debug go test" },
				{ "<leader>dp", group = "debug python" },
				{ "<leader>E",  group = "explorer: focus, reveal, collapse" },
				{ "<leader>f",  group = "find: files, grep, buffers, history" },
				{ "<leader>g",  group = "git: status, diff, history, branches, go" },
				{ "<leader>go", group = "go: test, run, debug, tags, fill" },
				{ "<leader>gm", group = "go modules: tidy, get, vendor" },
				{ "<leader>gz", group = "diffbandit: diff, log, commit panel" },
				{ "<leader>h",  group = "hunks: stage, reset, preview, blame" },
				{ "<leader>j",  group = "jupyter: run, kernel, output" },
				{ "<leader>l",  group = "lsp: goto, rename, symbols, format" },
				{ "<leader>L",  group = "location list: open, close" },
				{ "<leader>m",  group = "harpoon: marked files 1-5" },
				{ "<leader>n",  group = "tests: run, watch, debug, summary" },
				{ "<leader>O",  group = "github: PRs, issues, review" },
				{ "<leader>q",  group = "quit, sessions" },
				{ "<leader>r",  group = "run: tasks, shell, lazydocker" },
				{ "<leader>s",  group = "splits, search & replace, snippets" },
				{ "<leader>t",  group = "terminals 1-9, outline, inspect, zen" },
				{ "<leader>u",  group = "toggle: numbers, spell, wrap, indent" },
				{ "<leader>w",  group = "wrap width: 80, 100, 120" },
				{ "<leader>x",  group = "trouble: diagnostics, refs, symbols" },
				{ "<leader>z",  group = "syntax tree: move, swap" },
			},
		},
	},

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {
			check_ts = true,
			ts_config = {
				lua = { "string", "source" },
				javascript = { "string", "template_string" },
			},
			disable_filetype = { "TelescopePrompt" },
			fast_wrap = {
				map = '<M-e>',
				chars = { '{', '[', '(', '"', "'" },
				pattern = [=[[%'%"%>%]%)%}%,]]=],
				end_key = '$',
				keys = 'qwertyuiopzxcvbnmasdfghjkl',
				check_comma = true,
				highlight = 'Search',
				highlight_grey = 'Comment'
			},
		},
		config = function(_, opts)
			require("nvim-autopairs").setup(opts)
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPost", "BufNewFile" },
		main = "ibl",
		opts = {
			indent = {
				char = "│",
				tab_char = "│",
			},
			scope = { enabled = false },
			exclude = {
				filetypes = {
					"help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy",
					"mason", "notify", "toggleterm", "lazyterm", "NvimTree",
				},
			},
		},
	},

	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({})
		end,
	},

	{
		"Wansmer/treesj",
		keys = {
			{ "<leader>J", function() require("treesj").toggle() end, desc = "Split / join block" },
		},
		opts = { use_default_keymaps = false },
	},

	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
	},

	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = { "BufReadPost", "BufNewFile" },
		opts = {},
	},

	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = {
			options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" }
		},
	},

	{
		"ray-x/go.nvim",
		dependencies = {
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			local gopath = vim.fn.trim(vim.fn.system('go env GOPATH'))
			local gobin = gopath .. '/bin'

			vim.env.GOPATH = gopath
			vim.env.GOBIN = gobin

			local current_path = vim.env.PATH or ''
			if not string.find(current_path, gobin, 1, true) then
				vim.env.PATH = gobin .. ':' .. current_path
			end

			require("go").setup({
			lsp_cfg = false,
				lsp_on_attach = false,
				lsp_keymaps = false,
				lsp_inlay_hints = { enable = false },
				diagnostic = false,
				go = "go",
				gopath = gopath,
				gobin = gobin,
				lsp_gofumpt = true,
				luasnip = true,
			})
		end,
		ft = { "go", 'gomod' },
		cmd = { "GoInstallBinaries", "GoUpdateBinaries", "GoTagAdd", "GoTagRm", "GoImpl", "GoCoverage" },
		build = ':lua require("go.install").update_all_sync()'
	},

	{ "mfussenegger/nvim-jdtls", ft = "java" },

	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {
			size = 10,
			open_mapping = [[<c-\>]],
			direction = "horizontal",
			shade_terminals = true,
			start_in_insert = true,
			persist_mode = false,
			persist_size = true,
			close_on_exit = true,
			float_opts = {
				border = "curved",
			},
		},
	},

	{
		"mbbill/undotree",
		cmd = { "UndotreeToggle", "UndotreeShow" },
		keys = {
			{ "<leader>U", "<cmd>UndotreeToggle<cr>", desc = "Undo tree" },
		},
		init = function()
			vim.g.undotree_SetFocusWhenToggle = 1
			vim.g.undotree_WindowLayout = 2
		end,
	},

	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "LspAttach",
		priority = 1000,
		config = function()
			require("tiny-inline-diagnostic").setup()
		end,
	},

	{
		"stevearc/quicker.nvim",
		ft = "qf",
		keys = {
			{ "<leader>cq", function() require("quicker").toggle() end, desc = "Toggle quickfix" },
		},
		opts = {
			keys = {
				{ ">", function() require("quicker").expand({ before = 2, after = 2, add_to_existing = true }) end, desc = "Expand qf context" },
				{ "<", function() require("quicker").collapse() end, desc = "Collapse qf context" },
			},
		},
	},

	{
		"OXY2DEV/markview.nvim",
		lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
	},

	{
		"gbprod/yanky.nvim",
		event = "VeryLazy",
		keys = {
			{ "p", "<Plug>(YankyPutAfter)", mode = "n", desc = "Put after" },
			{ "P", "<Plug>(YankyPutBefore)", mode = "n", desc = "Put before" },
			{ "<C-n>", "<Plug>(YankyNextEntry)", desc = "Next yank (after put)" },
			{ "<C-p>", "<Plug>(YankyPreviousEntry)", desc = "Previous yank (after put)" },
			{ "<leader>fy", function() require("telescope").extensions.yank_history.yank_history() end, desc = "Yank history" },
		},
		opts = { ring = { storage = "shada" } },
		config = function(_, opts)
			require("yanky").setup(opts)
			require("telescope").load_extension("yank_history")
		end,
	},

	{
		"aaronik/treewalker.nvim",
		cmd = "Treewalker",
		opts = { highlight = true },
		keys = {
			{ "<leader>zj", "<cmd>Treewalker Down<cr>",  mode = { "n", "v" }, desc = "Next sibling" },
			{ "<leader>zk", "<cmd>Treewalker Up<cr>",    mode = { "n", "v" }, desc = "Previous sibling" },
			{ "<leader>zh", "<cmd>Treewalker Left<cr>",  mode = { "n", "v" }, desc = "Go to parent" },
			{ "<leader>zl", "<cmd>Treewalker Right<cr>", mode = { "n", "v" }, desc = "Go to child" },
			{ "<leader>zJ", "<cmd>Treewalker SwapDown<cr>",  desc = "Swap down" },
			{ "<leader>zK", "<cmd>Treewalker SwapUp<cr>",    desc = "Swap up" },
			{ "<leader>zH", "<cmd>Treewalker SwapLeft<cr>",  desc = "Swap left" },
			{ "<leader>zL", "<cmd>Treewalker SwapRight<cr>", desc = "Swap right" },
		},
	},

	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"fredrikaverpil/neotest-golang",
			"nvim-neotest/neotest-python",
		},
		keys = {
			{ "<leader>nn", function()
				local args = require("apascualco.goproject").neotest_args(vim.api.nvim_buf_get_name(0))
				if args then require("neotest").run.run(args) end
			end, desc = "Run nearest" },
			{ "<leader>nf", function()
				local file = vim.fn.expand("%:p")
				local args = require("apascualco.goproject").neotest_args(file, { file })
				if args then require("neotest").run.run(args) end
			end, desc = "Run file" },
			{ "<leader>nl", function() require("neotest").run.run_last() end, desc = "Run last" },
			{ "<leader>ns", function() require("neotest").summary.toggle() end, desc = "Toggle summary" },
			{ "<leader>no", function() require("neotest").output.open({ enter = true }) end, desc = "Show output" },
			{ "<leader>nw", function()
				local file = vim.fn.expand("%:p")
				local args = require("apascualco.goproject").neotest_args(file, { file })
				if args then require("neotest").watch.toggle(args) end
			end, desc = "Toggle watch" },
			{ "<leader>nd", function()
				local args = require("apascualco.goproject").neotest_args(vim.api.nvim_buf_get_name(0), { strategy = "dap" })
				if args then require("neotest").run.run(args) end
			end, desc = "Debug nearest" },
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-golang")({
						dap_mode = "dap-go",
						runner = "gotestsum",
						env = function() return require("apascualco.goproject").test_env(vim.uv.cwd()) end,
						go_test_args = function() return require("apascualco.goproject").go_test_args() end,
						go_list_args = function() return require("apascualco.goproject").go_list_args() end,
						dap_go_opts = require("apascualco.goproject").dap_go_opts,
					}),
					require("neotest-python")({ dap = { justMyCode = false } }),
				},
			})
		end,
	},

	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dadbod", lazy = true },
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
		},
		cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
		keys = {
			{ "<leader>Du", "<cmd>DBUIToggle<cr>", desc = "Toggle drawer" },
			{ "<leader>Da", "<cmd>DBUIAddConnection<cr>", desc = "Add connection" },
			{ "<leader>Df", "<cmd>DBUIFindBuffer<cr>", desc = "Reveal buffer in drawer" },
		},
		init = function()
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.db_ui_disable_mappings_sql = 1
			vim.g.db_ui_disable_mappings_javascript = 1
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("DbuiQueryKeymaps", { clear = true }),
				pattern = { "sql", "mysql", "plsql", "javascript" },
				callback = function(ev)
					if not vim.b[ev.buf].dbui_db_key_name then return end
					local function m(mode, lhs, plug, desc)
						vim.keymap.set(mode, lhs, plug, { buffer = ev.buf, remap = true, silent = true, desc = desc })
					end
					m({ "n", "x" }, "<leader>Dr", "<Plug>(DBUI_ExecuteQuery)", "Run query")
					m("n", "<leader>Dw", "<Plug>(DBUI_SaveQuery)", "Save query")
					m("n", "<leader>Db", "<Plug>(DBUI_EditBindParameters)", "Edit bind parameters")
				end,
			})
		end,
	},

	{
		"stevearc/overseer.nvim",
		cmd = { "OverseerRun", "OverseerToggle", "OverseerQuickAction", "OverseerRunCmd" },
		keys = {
			{ "<leader>rr", "<cmd>OverseerRun<cr>", desc = "Run task" },
			{ "<leader>rt", "<cmd>OverseerToggle<cr>", desc = "Task list" },
			{ "<leader>ra", "<cmd>OverseerQuickAction<cr>", desc = "Task actions" },
			{ "<leader>rc", "<cmd>OverseerRunCmd<cr>", desc = "Run shell command" },
		},
		opts = {},
	},

	{
		"danymat/neogen",
		cmd = "Neogen",
		keys = {
			{ "<leader>cd", function() require("neogen").generate() end, desc = "Generate docstring" },
		},
		opts = { snippet_engine = "luasnip" },
	},

	{
		"aaronhallaert/advanced-git-search.nvim",
		cmd = "AdvancedGitSearch",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"tpope/vim-fugitive",
		},
		keys = {
			{ "<leader>gA", "<cmd>AdvancedGitSearch<cr>", desc = "Advanced search" },
		},
		config = function()
			require("telescope").load_extension("advanced_git_search")
		end,
	},

	{
		"artemave/workspace-diagnostics.nvim",
		keys = {
			{ "<leader>lw", function()
				local bufnr = vim.api.nvim_get_current_buf()
				for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
					require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
				end
			end, desc = "Load workspace diagnostics" },
		},
	},

	{
		"MagicDuck/grug-far.nvim",
		cmd = "GrugFar",
		keys = {
			{ "<leader>sr", function() require("grug-far").open() end, mode = { "n", "x" }, desc = "Search & replace" },
			{ "<leader>S", function() require("grug-far").open() end, mode = { "n", "x" }, desc = "Search & replace" },
			{ "<leader>sf", function() require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } }) end, desc = "Search & replace in file" },
			{ "<leader>sR", function() require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } }) end, desc = "Replace word under cursor" },
		},
		opts = {},
	},

	{
		"Zeioth/garbage-day.nvim",
		dependencies = { "neovim/nvim-lspconfig" },
		event = "VeryLazy",
		opts = {},
	},

	{
		"Bekaboo/dropbar.nvim",
		dependencies = { "nvim-telescope/telescope-fzf-native.nvim" },
		event = { "BufReadPost", "BufNewFile" },
		keys = {
			{ "<leader>lb", function() require("dropbar.api").pick() end, desc = "Breadcrumbs" },
		},
		opts = {},
	},

	{
		"3rd/image.nvim",
		lazy = true,
		build = false,
		opts = {
			backend = "kitty",
			processor = "magick_cli",
			integrations = {
				markdown = { enabled = false },
				neorg = { enabled = false },
				typst = { enabled = false },
				html = { enabled = false },
				css = { enabled = false },
			},
			max_width_window_percentage = 80,
			window_overlap_clear_enabled = true,
		},
	},
	{
		"benlubas/molten-nvim",
		version = "^1.0.0",
		build = ":UpdateRemotePlugins",
		dependencies = { "3rd/image.nvim" },
		cmd = {
			"MoltenInit", "MoltenEvaluateLine", "MoltenEvaluateVisual",
			"MoltenEvaluateOperator", "MoltenReevaluateCell", "MoltenDelete",
			"MoltenShowOutput", "MoltenHideOutput", "MoltenInterrupt",
			"MoltenRestart", "MoltenNext", "MoltenPrev",
		},
		init = function()
			vim.g.molten_image_provider = "image.nvim"
			vim.g.molten_output_win_max_height = 20
			vim.g.molten_virt_text_output = true
			vim.g.molten_virt_lines_off_by_1 = true
			vim.g.molten_auto_open_output = false
			vim.g.molten_wrap_output = true
		end,
	},
	{
		"GCBallesteros/jupytext.nvim",
		event = "BufReadPre *.ipynb",
		opts = {
			style = "hydrogen",
			output_extension = "auto",
			force_ft = nil,
		},
	},

}, {
	rocks = {
		enabled = false,
	},
	performance = {
		rtp = {
			disabled_plugins = { "gzip", "netrwPlugin", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
		},
	},
})
