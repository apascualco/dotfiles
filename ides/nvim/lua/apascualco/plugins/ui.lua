return {
	"nvim-tree/nvim-web-devicons",

	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		lazy = false,
		config = function()
			require("catppuccin").setup({
				flavour = nil,
				background = { light = "latte", dark = "macchiato" },
				transparent_background = false,
				show_end_of_buffer = false,
				term_colors = false,
				dim_inactive = { enabled = false, shade = "dark", percentage = 0.15 },
				styles = { comments = { "italic" }, conditionals = { "italic" } },
				integrations = {
					octo = true,
					cmp = true,
					gitsigns = true,
					nvimtree = true,
					telescope = true,
					notify = true,
					mini = false,
					lsp_trouble = true,
					treesitter = true,
					dap = { enabled = true, enable_ui = true },
					which_key = true,
					indent_blankline = { enabled = true, colored_indent_levels = true },
					native_lsp = {
						enabled = true,
						underlines = {
							errors = { "undercurl" },
							hints = { "undercurl" },
							warnings = { "undercurl" },
							information = { "undercurl" },
						},
					},
				},
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "arkav/lualine-lsp-progress", "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				icons_enabled = true,
				theme = "auto",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				always_divide_middle = true,
				globalstatus = true,
				refresh = { statusline = 1000, tabline = 1000, winbar = 1000 },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { "filename" },
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "lsp_progress", "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_c = { "filename" },
				lualine_x = { "location" },
			},
			extensions = { "nvim-tree", "fugitive", "nvim-dap-ui", "lazy" },
		},
	},

	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin/nvim" },
		config = function()
			local ok, cat = pcall(require, "catppuccin.special.bufferline")
			require("bufferline").setup({
				highlights = ok and cat.get_theme() or {},
				options = {
					mode = "buffers",
					diagnostics = "nvim_lsp",
					separator_style = "slope",
					show_buffer_close_icons = true,
					show_close_icon = true,
					always_show_bufferline = true,
					color_icons = true,
					offsets = {
						{ filetype = "NvimTree", text = "File Explorer", highlight = "Directory", separator = true },
					},
				},
			})
		end,
	},

	{
		"nvim-tree/nvim-tree.lua",
		opts = {
			sort_by = "case_sensitive",
			reload_on_bufenter = true,
			view = { width = 40 },
			renderer = { highlight_diagnostics = true, group_empty = true },
			filters = { git_ignored = false },
			diagnostics = { enable = true, show_on_dirs = false },
			update_focused_file = { enable = true, update_root = false },
			sync_root_with_cwd = true,
			respect_buf_cwd = true,
		},
	},

	{
		"Bekaboo/dropbar.nvim",
		dependencies = { "nvim-telescope/telescope-fzf-native.nvim" },
		event = { "BufReadPost", "BufNewFile" },
		keys = {
			{
				"<leader>lb",
				function()
					require("dropbar.api").pick()
				end,
				desc = "Breadcrumbs",
			},
		},
		opts = {},
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
			local row_to_barpos = util.row_to_barpos
			util.row_to_barpos = function(winid, row)
				local pos, f = row_to_barpos(winid, row)
				if pos ~= pos then
					return 0, 0
				end
				return pos, f
			end
			local height_to_virtual = util.height_to_virtual
			util.height_to_virtual = function(winid, row, row2)
				local h = height_to_virtual(winid, row, row2)
				if h ~= h then
					return 1
				end
				return h
			end
		end,
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPost", "BufNewFile" },
		main = "ibl",
		opts = {
			indent = { char = "│", tab_char = "│" },
			scope = { enabled = false },
			exclude = {
				filetypes = {
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"Trouble",
					"lazy",
					"mason",
					"notify",
					"toggleterm",
					"lazyterm",
					"NvimTree",
				},
			},
		},
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
	},

	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "LspAttach",
		priority = 1000,
		opts = {},
	},

	{
		"OXY2DEV/markview.nvim",
		lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
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
			{
				"<leader>gy",
				function()
					Snacks.gitbrowse({
						open = function(url)
							vim.fn.setreg("+", url)
							vim.notify("Permalink copiado al portapapeles")
						end,
					})
				end,
				desc = "Copy GitHub permalink",
			},
			{
				"<leader>tz",
				function()
					Snacks.zen()
				end,
				desc = "Zen mode",
			},
		},
	},

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			plugins = { spelling = true },
			spec = {
				mode = { "n", "v" },
				{ "g", group = "goto" },
				{ "]", group = "next" },
				{ "[", group = "previous" },
				{ "<leader>a", group = "claude: send, diffs, sessions" },
				{ "<leader>b", group = "buffers: close, move, pick, sort" },
				{ "<leader>bs", group = "sort buffers" },
				{ "<leader>c", group = "code: format, docstring, quickfix, codex" },
				{ "<leader>C", group = "crates: versions, update (Cargo.toml)" },
				{ "<leader>D", group = "database: drawer, connections, queries" },
				{ "<leader>d", group = "debug: breakpoints, step, UI, REPL" },
				{ "<leader>E", group = "explorer: focus, reveal, collapse" },
				{ "<leader>f", group = "find: files, grep, buffers, history" },
				{ "<leader>g", group = "git: status, diff, history, branches" },
				{ "<leader>gz", group = "diffbandit: diff, log, commit panel" },
				{ "<leader>h", group = "hunks: stage, reset, preview, blame" },
				{ "<leader>j", group = "jupyter: run, kernel, output" },
				{ "<leader>l", group = "lsp: goto, rename, symbols, format" },
				{ "<leader>L", group = "location list: open, close" },
				{ "<leader>m", group = "harpoon: marked files 1-5" },
				{ "<leader>n", group = "tests: nearest, file, all, last, debug, coverage" },
				{ "<leader>O", group = "github: PRs, issues, review" },
				{ "<leader>k", group = "language: run, debug, build, lint, imports" },
				{ "<leader>G", group = "generate / refactor" },
				{ "<leader>K", group = "packages: install, add, update, tidy, list" },
				{ "<leader>q", group = "quit, sessions" },
				{ "<leader>r", group = "run: tasks, shell, lazydocker" },
				{ "<leader>s", group = "splits, search & replace, snippets" },
				{ "<leader>t", group = "terminals 1-9, outline, inspect, zen" },
				{ "<leader>u", group = "toggle: numbers, spell, wrap, indent" },
				{ "<leader>w", group = "wrap width: 80, 100, 120" },
				{ "<leader>x", group = "trouble: diagnostics, refs, symbols" },
				{ "<leader>z", group = "syntax tree: move, swap" },
			},
		},
	},
}
