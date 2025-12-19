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
	{ 'catppuccin/nvim',                 name = 'catppuccin', priority = 1000 },

	-- Highlighting of code
	{ "nvim-treesitter/nvim-treesitter", branch = 'master',   lazy = false,   build = ":TSUpdate" },

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
			require('telescope').load_extension('mapper')
			require('telescope').load_extension('luasnip')
			require('telescope').load_extension('fzf')
		end
	},

	-- browse the tags
	{ 'preservim/tagbar' },

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

	-- Autocomplete
	{ "hrsh7th/nvim-cmp" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-nvim-lsp-signature-help" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-path" },

	-- Vscode-like pictograms
	{ 'onsails/lspkind.nvim' },

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
	-- Movement pluin
	{ "nvim-pack/nvim-spectre" },
	{ "ThePrimeagen/harpoon" },

	-- Claude
	{
		"coder/claudecode.nvim",
		dependencies = { "folke/snacks.nvim" },
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
		'MeanderingProgrammer/render-markdown.nvim',
		dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' }, -- if you use the mini.nvim suite
		opts = {
			latex = { enabled = false }
		},
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
				{ "<leader>q",  group = "session" },
				{ "<leader>s",  group = "search/snippets" },
				{ "<leader>t",  group = "terminal/toggle/test" },
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
			disable_filetype = { "TelescopePrompt", "spectre_panel" },
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

			require("go").setup({
				lsp_cfg = false,          -- Usa tu LSP config existente (go.lua)
				lsp_on_attach = false,
				lsp_keymaps = false,      -- Usamos keymaps de keybinding.lua
				lsp_inlay_hints = { enable = false }, -- Configurado en go.lua
				diagnostic = false,       -- Ya configurado en diagnostics.lua
				go = "go",                -- comando go
				gopath = gopath,          -- usar GOPATH detectado
				gobin = gobin,            -- usar GOBIN detectado
				lsp_gofumpt = false,      -- Ya configurado en go.lua
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
}, {
	-- Configuración de lazy.nvim
	rocks = {
		enabled = false, -- No hay plugins que requieran luarocks
	},
})
