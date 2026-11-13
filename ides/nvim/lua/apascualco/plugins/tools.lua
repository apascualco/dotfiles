return {
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
					if not vim.b[ev.buf].dbui_db_key_name then
						return
					end
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
			{
				"<leader>cd",
				function()
					require("neogen").generate()
				end,
				desc = "Generate docstring",
			},
		},
		opts = { snippet_engine = "luasnip" },
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
			"MoltenInit",
			"MoltenEvaluateLine",
			"MoltenEvaluateVisual",
			"MoltenEvaluateOperator",
			"MoltenReevaluateCell",
			"MoltenDelete",
			"MoltenShowOutput",
			"MoltenHideOutput",
			"MoltenInterrupt",
			"MoltenRestart",
			"MoltenNext",
			"MoltenPrev",
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
		opts = { style = "hydrogen", output_extension = "auto", force_ft = nil },
	},
}
