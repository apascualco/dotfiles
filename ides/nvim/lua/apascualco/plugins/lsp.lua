return {
	"neovim/nvim-lspconfig",

	{
		"mason-org/mason.nvim",
		opts = { ui = { icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" } } },
	},

	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
		opts = {
			ensure_installed = {
				"lua_ls",
				"ts_ls",
				"eslint",
				"html",
				"cssls",
				"jsonls",
				"yamlls",
				"rust_analyzer",
				"buf_ls",
				"basedpyright",
				"ruff",
				"jdtls",
			},
			automatic_enable = false,
		},
	},

	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = { library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } } },
	},

	{ "b0o/SchemaStore.nvim", lazy = true },

	{ "folke/trouble.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }, opts = {} },

	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			formatters_by_ft = {
				go = function(bufnr)
					return require("apascualco.lang.go.project").go_formatters(bufnr)
				end,
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
				if vim.tbl_contains({ "sql", "java" }, vim.bo[bufnr].filetype) then
					return
				end
				return { lsp_format = "fallback", timeout_ms = 2000 }
			end,
		},
	},
}
