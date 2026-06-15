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
	-- Directory manager
	'nvim-tree/nvim-tree.lua',

	-- Theme appearance
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

	-- Highlighting of code
	{ "nvim-treesitter/nvim-treesitter", branch = 'main',   lazy = false,   build = ":TSUpdate" },

	-- Search and find dirs, snips, mappers, etc...
	{
		'nvim-telescope/telescope.nvim',
		dependencies = {
			{ 'nvim-lua/plenary.nvim' },
			{ 'benfowler/telescope-luasnip.nvim' },
			{ 'lazytanuki/nvim-mapper' },
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
			require('telescope').load_extension('mapper')
			require('telescope').load_extension('luasnip')
			require('telescope').load_extension('fzf')
		end
	},

	-- browse the tags
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

	-- LSP installer
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

	-- Lua LS aware of Neovim runtime + plugin sources (for editing this config)
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Carga tipos de luv cuando se referencia vim.uv
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},

	-- JSON/YAML schemas for jsonls (package.json, tsconfig, eslint, GH Actions, ...)
	{ "b0o/SchemaStore.nvim", lazy = true, ft = { "json", "jsonc", "yaml" } },

	-- Autocomplete
	{ "hrsh7th/nvim-cmp" }, -- config en plugins/lsp/autocompletion.lua
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-nvim-lsp-signature-help" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-path" },

	-- Vscode-like pictograms
	{ 'onsails/lspkind.nvim' },

	-- AI code completion (free)
	{
		"supermaven-inc/supermaven-nvim",
		event = "InsertEnter",
		config = function()
			require("supermaven-nvim").setup({
				keymaps = {
					accept_suggestion = "<C-l>",
					clear_suggestion = "<C-]>",
					accept_word = "<C-Right>",
				},
				color = {
					suggestion_color = "#585b70",
				},
				log_level = "off",
			})
			-- Auto-activar free tier sin prompt
			vim.defer_fn(function()
				local ok, api = pcall(require, "supermaven-nvim.api")
				if ok and not api.is_running() then
					vim.cmd("SupermavenUseFree")
				end
			end, 1000)
		end,
	},

	-- Snippers
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
				-- go = { "golangcilint" },  -- Disabled due to errors
			}

			-- Don't run automatically, only when called manually with ,ll
			-- This avoids annoying errors in files outside Go projects
		end,
	},
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			formatters_by_ft = {
				go = { "gofumpt", "goimports" },
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
				python = { "black", "isort" },
				rust = { "rustfmt" },
			},
			format_on_save = function(bufnr)
				-- Disable for certain filetypes
				local ignore_filetypes = { "sql", "java" }
				if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
					return
				end
				return { lsp_fallback = true, timeout_ms = 2000 }
			end,
		},
	},

	-- Diagnostics
	{
		'folke/trouble.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		opts = {},
	},

	-- Debug adapter protocol
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"jay-babu/mason-nvim-dap.nvim",
			"williamboman/mason.nvim",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio"
		},
	},
	{
		"leoluz/nvim-dap-go",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function(_, opts)
			require("dap-go").setup(opts)
			local dap = require("dap")
			for _, config in ipairs(dap.configurations.go or {}) do
				if not config.console then
					config.console = "integratedTerminal"
				end
				if config.mode == "auto" then
					config.mode = "debug"
				end
			end
		end,
	},
	{
		"LiadOz/nvim-dap-repl-highlights",
		config = function()
			require("nvim-dap-repl-highlights").setup()
		end,
	},

	-- Botton line
	{
		'nvim-lualine/lualine.nvim',
		dependencies = {
			'arkav/lualine-lsp-progress',
			'nvim-tree/nvim-web-devicons'
		},
	},

	-- Top line
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin/nvim" }
	},

	-- Git
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
			require("gitsigns").setup()
		end,
	},
	{
		"sindrets/diffview.nvim",
		opts = {
			hg_cmd = nil, -- Desactiva Mercurial
		},
	},
	{
		"akinsho/git-conflict.nvim",
		version = "*",
		event = "BufReadPre",
		opts = {
			default_mappings = true, -- co, ct, cb, c0, ]x, [x
			disable_diagnostics = true, -- Desactiva diagnostics en conflictos
		},
	},

	-- GitHub PR/issue review inside nvim (activa la integración octo de catppuccin)
	{
		"pwntester/octo.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		cmd = "Octo",
		keys = {
			{ "<leader>Oo", "<cmd>Octo<cr>",              desc = "Octo — Command menu" },
			{ "<leader>Op", "<cmd>Octo pr list<cr>",      desc = "Octo — List PRs" },
			{ "<leader>OP", "<cmd>Octo pr search<cr>",    desc = "Octo — Search PRs" },
			{ "<leader>Oi", "<cmd>Octo issue list<cr>",   desc = "Octo — List issues" },
			{ "<leader>Or", "<cmd>Octo review start<cr>", desc = "Octo — Start PR review" },
		},
		opts = {
			picker = "telescope",
		},
	},

	-- Comment
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

	-- Color codes
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
	-- Scrollbar (minimap-style like IntelliJ)
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
			-- Fix: guard against NaN when vlinecount0=0 (e.g. 2-line buffer with wrap)
			-- Without this, the cursor handler passes NaN as extmark id and spams errors.
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

	-- Movement plugin
	{ "ThePrimeagen/harpoon", branch = "harpoon2", dependencies = { "nvim-lua/plenary.nvim" } },
	{ "christoomey/vim-tmux-navigator", lazy = false },

	-- Symbol usage: muestra references/implementations encima de funciones (como IntelliJ)
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

	-- Snacks (required by claudecode, must not be lazy-loaded)
	{
		"folke/snacks.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			notifier = { enabled = true },
			words = { enabled = true },
			scroll = { enabled = true },
			dim = { enabled = true },
			zen = { enabled = true },
			image = { enabled = true }, -- requiere magick, gs, mmdc + tmux allow-passthrough
		},
		keys = {
			{ "<leader>gy", function() Snacks.gitbrowse({ open = function(url) vim.fn.setreg("+", url); vim.notify("Permalink copiado al portapapeles") end }) end, desc = "Git — Copiar permalink de GitHub" },
			{ "<leader>tz", function() Snacks.zen() end, desc = "Snacks — Zen mode" },
		},
	},

	-- Claude
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
	-- ──────────────────────────────────────────────────────────────────────────────
	-- Productivity plugins
	-- ──────────────────────────────────────────────────────────────────────────────

	-- Which-key: muestra atajos disponibles
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			plugins = { spelling = true },
			spec = {
				mode = { "n", "v" },
				{ "g",          group = "goto" },
				{ "]",          group = "next" },
				{ "[",          group = "prev" },
				{ "<leader>a",  group = "ai/claude" },
				{ "<leader>b",  group = "buffer" },
				{ "<leader>c",  group = "code" },
				{ "<leader>d",  group = "debug" },
				{ "<leader>e",  group = "explorer" },
				{ "<leader>f",  group = "find/telescope" },
				{ "<leader>g",  group = "git" },
				{ "<leader>go", group = "golang" },
				{ "<leader>h",  group = "hunks" },
				{ "<leader>l",  group = "lsp" },
				{ "<leader>m",  group = "harpoon" },
				{ "<leader>O",  group = "octo/github" },
				{ "<leader>z",  group = "treewalker/AST" },
				{ "<leader>r",  group = "run/tasks" },
				{ "<leader>n",  group = "neotest" },
				{ "<leader>u",  group = "toggle" },
				{ "<leader>gm", group = "go-mod" },
				{ "<leader>L",  group = "loclist" },
				{ "<leader>q",  group = "quit/session" },
				{ "<leader>s",  group = "search/snippets" },
				{ "<leader>t",  group = "terminal/toggle" },
				{ "<leader>w",  group = "wrap" },
				{ "<leader>x",  group = "trouble/diagnostics" },
			},
		},
	},

	-- Auto-cierra paréntesis, llaves, comillas
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

	-- Guías de indentación
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

	-- Manipula delimitadores fácilmente
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({})
		end,
	},

	-- Split/join de bloques (args, structs, objetos) con treesitter
	{
		"Wansmer/treesj",
		keys = {
			{ "<leader>J", function() require("treesj").toggle() end, desc = "TreeSJ — Toggle split/join" },
		},
		opts = { use_default_keymaps = false },
	},

	-- Navegación ultra rápida por pantalla
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
	},

	-- Destaca TODO, FIXME, BUG, etc
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = { "BufReadPost", "BufNewFile" },
		opts = {},
	},

	-- Destaca palabra bajo cursor
	{
		"RRethy/vim-illuminate",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			delay = 200,
			large_file_cutoff = 2000,
			large_file_overrides = {
				providers = { "lsp" },
			},
		},
		config = function(_, opts)
			require("illuminate").configure(opts)
		end,
	},

	-- Mejora vim.ui.select y vim.input
	{
		"stevearc/dressing.nvim",
		event = "VeryLazy",
		opts = {},
	},

	-- Sesiones automáticas
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = {
			options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" }
		},
	},

	-- Go extras: test coverage, tags, etc
	{
		"ray-x/go.nvim",
		dependencies = {
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			-- Detectar GOPATH/GOBIN de GVM
			local gopath = vim.fn.trim(vim.fn.system('go env GOPATH'))
			local gobin = gopath .. '/bin'

			-- Configurar variables de entorno para Go
			vim.env.GOPATH = gopath
			vim.env.GOBIN = gobin

			-- Agregar GOBIN al PATH de nvim si no está
			local current_path = vim.env.PATH or ''
			if not string.find(current_path, gobin, 1, true) then
				vim.env.PATH = gobin .. ':' .. current_path
			end

			local lsp_setup = require("apascualco.plugins.lsp.setup")

			require("go").setup({
			lsp_cfg = false,  -- gopls gestionado en plugins/lsp/go.lua
				lsp_on_attach = false,
				lsp_keymaps = false,      -- Usamos keymaps de keybinding.lua
				lsp_inlay_hints = { enable = false },
				diagnostic = false,       -- Ya configurado en diagnostics.lua
				go = "go",
				gopath = gopath,
				gobin = gobin,
				lsp_gofumpt = true,
				luasnip = true,
			})
		end,
		event = { "CmdlineEnter" },
		ft = { "go", 'gomod' },
		build = ':lua require("go.install").update_all_sync()'
	},

	-- Terminal con pestañas
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {
			size = 10,
			open_mapping = [[<c-\>]],
			direction = "horizontal",
			shade_terminals = true,
			start_in_insert = true,
			persist_size = true,
			close_on_exit = true,
			float_opts = {
				border = "curved",
			},
		},
	},
	-- ── Plugins añadidos en la review ──────────────────────────────────────────

	-- Undo history como árbol navegable
	{
		"mbbill/undotree",
		cmd = { "UndotreeToggle", "UndotreeShow" },
		keys = {
			{ "<leader>U", "<cmd>UndotreeToggle<cr>", desc = "Undotree — Toggle undo tree" },
		},
		init = function()
			vim.g.undotree_SetFocusWhenToggle = 1
			vim.g.undotree_WindowLayout = 2
		end,
	},

	-- Diagnóstico inline bajo el cursor (virtual_text ya está en false)
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "LspAttach",
		priority = 1000,
		config = function()
			require("tiny-inline-diagnostic").setup()
		end,
	},

	-- Quickfix mejorado: highlight, contexto expandible y editable
	{
		"stevearc/quicker.nvim",
		ft = "qf",
		keys = {
			{ "<leader>cq", function() require("quicker").toggle() end, desc = "Quickfix — Toggle (quicker)" },
		},
		opts = {
			keys = {
				{ ">", function() require("quicker").expand({ before = 2, after = 2, add_to_existing = true }) end, desc = "Expand qf context" },
				{ "<", function() require("quicker").collapse() end, desc = "Collapse qf context" },
			},
		},
	},

	-- Render de Markdown in-buffer (reemplaza render-markdown.nvim, roto en 0.12)
	{
		"OXY2DEV/markview.nvim",
		lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
	},

	-- Yank ring / historial de portapapeles (no toca el paste visual "_dP)
	{
		"gbprod/yanky.nvim",
		event = "VeryLazy",
		keys = {
			{ "p", "<Plug>(YankyPutAfter)", mode = "n", desc = "Yanky — Put after" },
			{ "P", "<Plug>(YankyPutBefore)", mode = "n", desc = "Yanky — Put before" },
			{ "<C-n>", "<Plug>(YankyNextEntry)", desc = "Yanky — Cycle next (after put)" },
			{ "<C-p>", "<Plug>(YankyPreviousEntry)", desc = "Yanky — Cycle prev (after put)" },
			{ "<leader>fy", function() require("telescope").extensions.yank_history.yank_history() end, desc = "Yanky — Yank history" },
		},
		opts = { ring = { storage = "shada" } },
		config = function(_, opts)
			require("yanky").setup(opts)
			require("telescope").load_extension("yank_history")
		end,
	},

	-- Movimiento / swap de código por AST (Ctrl-hjkl evitado: es tu tmux-navigator)
	{
		"aaronik/treewalker.nvim",
		cmd = "Treewalker",
		opts = { highlight = true },
		keys = {
			{ "<leader>zj", "<cmd>Treewalker Down<cr>",  mode = { "n", "v" }, desc = "Treewalker — Move down (sibling)" },
			{ "<leader>zk", "<cmd>Treewalker Up<cr>",    mode = { "n", "v" }, desc = "Treewalker — Move up (sibling)" },
			{ "<leader>zh", "<cmd>Treewalker Left<cr>",  mode = { "n", "v" }, desc = "Treewalker — Move out (parent)" },
			{ "<leader>zl", "<cmd>Treewalker Right<cr>", mode = { "n", "v" }, desc = "Treewalker — Move in (child)" },
			{ "<leader>zJ", "<cmd>Treewalker SwapDown<cr>",  desc = "Treewalker — Swap down" },
			{ "<leader>zK", "<cmd>Treewalker SwapUp<cr>",    desc = "Treewalker — Swap up" },
			{ "<leader>zH", "<cmd>Treewalker SwapLeft<cr>",  desc = "Treewalker — Swap left" },
			{ "<leader>zL", "<cmd>Treewalker SwapRight<cr>", desc = "Treewalker — Swap right" },
		},
	},

	-- ── Set "según uso" (review) ────────────────────────────────────────────────

	-- Test runner unificado con árbol + resultados inline (Go vía neotest-golang)
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"fredrikaverpil/neotest-golang",
		},
		keys = {
			{ "<leader>nn", function() require("neotest").run.run() end, desc = "Neotest — Run nearest" },
			{ "<leader>nf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Neotest — Run file" },
			{ "<leader>nl", function() require("neotest").run.run_last() end, desc = "Neotest — Run last" },
			{ "<leader>ns", function() require("neotest").summary.toggle() end, desc = "Neotest — Toggle summary" },
			{ "<leader>no", function() require("neotest").output.open({ enter = true }) end, desc = "Neotest — Output" },
			{ "<leader>nw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Neotest — Toggle watch" },
			{ "<leader>nd", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Neotest — Debug nearest (dap)" },
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-golang")({ dap_mode = "dap-go" }),
				},
			})
		end,
	},

	-- Task runner (lee tasks.json de VS Code; build/lint para TS/Rust)
	{
		"stevearc/overseer.nvim",
		cmd = { "OverseerRun", "OverseerToggle", "OverseerQuickAction", "OverseerRunCmd" },
		keys = {
			{ "<leader>rr", "<cmd>OverseerRun<cr>", desc = "Overseer — Run task" },
			{ "<leader>rt", "<cmd>OverseerToggle<cr>", desc = "Overseer — Toggle task list" },
			{ "<leader>ra", "<cmd>OverseerQuickAction<cr>", desc = "Overseer — Quick action" },
			{ "<leader>rc", "<cmd>OverseerRunCmd<cr>", desc = "Overseer — Run shell cmd" },
		},
		opts = {},
	},

	-- Generador de docstrings (TSDoc/JSDoc/Rust/Lua); Go ya lo cubre go.nvim
	{
		"danymat/neogen",
		cmd = "Neogen",
		keys = {
			{ "<leader>cd", function() require("neogen").generate() end, desc = "Neogen — Generate docstring" },
		},
		opts = { snippet_engine = "luasnip" },
	},

	-- Búsqueda avanzada en historial git (pickaxe -G, por autor, diff vs commit)
	{
		"aaronhallaert/advanced-git-search.nvim",
		cmd = "AdvancedGitSearch",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"tpope/vim-fugitive",
		},
		keys = {
			{ "<leader>gA", "<cmd>AdvancedGitSearch<cr>", desc = "Git — Advanced git search" },
		},
		config = function()
			require("telescope").load_extension("advanced_git_search")
		end,
	},

	-- Diagnósticos de TODO el proyecto (on-demand para no martillear el LSP)
	{
		"artemave/workspace-diagnostics.nvim",
		keys = {
			{ "<leader>lw", function()
				local bufnr = vim.api.nvim_get_current_buf()
				for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
					require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
				end
			end, desc = "LSP — Populate workspace diagnostics" },
		},
	},

	-- Find & replace moderno con ripgrep (sucesor de spectre)
	{
		"MagicDuck/grug-far.nvim",
		cmd = "GrugFar",
		keys = {
			{ "<leader>sr", function() require("grug-far").open() end, desc = "Grug-far — Search & replace" },
			{ "<leader>sR", function() require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } }) end, desc = "Grug-far — Replace word under cursor" },
		},
		opts = {},
	},

	-- Detiene LSPs inactivos para liberar RAM (defaults conservadores)
	{
		"Zeioth/garbage-day.nvim",
		dependencies = { "neovim/nvim-lspconfig" },
		event = "VeryLazy",
		opts = {},
	},

	-- Breadcrumbs en winbar (estilo IntelliJ); excluye nvim-tree y buffers especiales
	{
		"Bekaboo/dropbar.nvim",
		dependencies = { "nvim-telescope/telescope-fzf-native.nvim" },
		event = { "BufReadPost", "BufNewFile" },
		keys = {
			{ "<leader>lb", function() require("dropbar.api").pick() end, desc = "Dropbar — Navigate breadcrumb" },
		},
		opts = {},
	},

}, {
	-- Configuración de lazy.nvim
	rocks = {
		enabled = false, -- No hay plugins que requieran luarocks
	},
})
