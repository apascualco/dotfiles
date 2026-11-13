return {
	{
		"numToStr/Comment.nvim",
		event = "VeryLazy",
		opts = { mappings = { basic = false, extra = false } },
	},

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {
			check_ts = true,
			ts_config = { lua = { "string", "source" }, javascript = { "string", "template_string" } },
			disable_filetype = { "TelescopePrompt" },
			fast_wrap = {
				map = "<M-e>",
				chars = { "{", "[", "(", '"', "'" },
				pattern = [=[[%'%"%>%]%)%}%,]]=],
				end_key = "$",
				keys = "qwertyuiopzxcvbnmasdfghjkl",
				check_comma = true,
				highlight = "Search",
				highlight_grey = "Comment",
			},
		},
		config = function(_, opts)
			require("nvim-autopairs").setup(opts)
			require("cmp").event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
		end,
	},

	{ "kylechui/nvim-surround", version = "*", event = "VeryLazy", opts = {} },

	{
		"Wansmer/treesj",
		keys = {
			{
				"<leader>J",
				function()
					require("treesj").toggle()
				end,
				desc = "Split / join block",
			},
		},
		opts = { use_default_keymaps = false },
	},

	{ "folke/flash.nvim", event = "VeryLazy", opts = {} },

	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = { "BufReadPost", "BufNewFile" },
		opts = {},
	},

	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" } },
	},

	{
		"gbprod/yanky.nvim",
		event = "VeryLazy",
		keys = {
			{ "p", "<Plug>(YankyPutAfter)", mode = "n", desc = "Put after" },
			{ "P", "<Plug>(YankyPutBefore)", mode = "n", desc = "Put before" },
			{ "<C-n>", "<Plug>(YankyNextEntry)", desc = "Next yank (after put)" },
			{ "<C-p>", "<Plug>(YankyPreviousEntry)", desc = "Previous yank (after put)" },
			{
				"<leader>fy",
				function()
					require("telescope").extensions.yank_history.yank_history()
				end,
				desc = "Yank history",
			},
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
			{ "<leader>zj", "<cmd>Treewalker Down<cr>", mode = { "n", "v" }, desc = "Next sibling" },
			{ "<leader>zk", "<cmd>Treewalker Up<cr>", mode = { "n", "v" }, desc = "Previous sibling" },
			{ "<leader>zh", "<cmd>Treewalker Left<cr>", mode = { "n", "v" }, desc = "Go to parent" },
			{ "<leader>zl", "<cmd>Treewalker Right<cr>", mode = { "n", "v" }, desc = "Go to child" },
			{ "<leader>zJ", "<cmd>Treewalker SwapDown<cr>", desc = "Swap down" },
			{ "<leader>zK", "<cmd>Treewalker SwapUp<cr>", desc = "Swap up" },
			{ "<leader>zH", "<cmd>Treewalker SwapLeft<cr>", desc = "Swap left" },
			{ "<leader>zL", "<cmd>Treewalker SwapRight<cr>", desc = "Swap right" },
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
		"stevearc/quicker.nvim",
		ft = "qf",
		keys = {
			{
				"<leader>cq",
				function()
					require("quicker").toggle()
				end,
				desc = "Toggle quickfix",
			},
		},
		opts = {
			keys = {
				{
					">",
					function()
						require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
					end,
					desc = "Expand qf context",
				},
				{
					"<",
					function()
						require("quicker").collapse()
					end,
					desc = "Collapse qf context",
				},
			},
		},
	},

	{
		"MagicDuck/grug-far.nvim",
		cmd = "GrugFar",
		keys = {
			{
				"<leader>sr",
				function()
					require("grug-far").open()
				end,
				mode = { "n", "x" },
				desc = "Search & replace",
			},
			{
				"<leader>S",
				function()
					require("grug-far").open()
				end,
				mode = { "n", "x" },
				desc = "Search & replace",
			},
			{
				"<leader>sf",
				function()
					require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
				end,
				desc = "Search & replace in file",
			},
			{
				"<leader>sR",
				function()
					require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
				end,
				desc = "Replace word under cursor",
			},
		},
		opts = {},
	},

	{ "ThePrimeagen/harpoon", branch = "harpoon2", dependencies = { "nvim-lua/plenary.nvim" } },
	{ "christoomey/vim-tmux-navigator", lazy = false },
	{ "Zeioth/garbage-day.nvim", dependencies = { "neovim/nvim-lspconfig" }, event = "VeryLazy", opts = {} },

	{
		"Wansmer/symbol-usage.nvim",
		event = "LspAttach",
		opts = {
			vt_position = "above",
			references = { enabled = true, include_declaration = false },
			definition = { enabled = false },
			implementation = { enabled = true },
		},
	},

	{
		"artemave/workspace-diagnostics.nvim",
		keys = {
			{
				"<leader>lw",
				function()
					local bufnr = vim.api.nvim_get_current_buf()
					for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
						require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
					end
				end,
				desc = "Load workspace diagnostics",
			},
		},
	},

	{
		"preservim/tagbar",
		init = function()
			vim.g.tagbar_type_go = {
				ctagstype = "go",
				kinds = {
					"p:package",
					"c:constants",
					"v:variables",
					"t:types",
					"s:structs",
					"i:interfaces",
					"m:struct members",
					"n:interface methods",
					"a:type aliases",
					"f:functions",
				},
				sro = ".",
				kind2scope = { s = "struct", i = "interface", t = "type" },
				scope2kind = { struct = "s", interface = "i", type = "t" },
			}
		end,
	},
}
