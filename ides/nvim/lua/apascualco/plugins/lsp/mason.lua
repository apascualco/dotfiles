require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗"
		}
	}
})

require("mason-lspconfig").setup {
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
}

require("apascualco.plugins.lsp.setup")

vim.lsp.config("eslint", {
	settings = {
		experimental = { useFlatConfig = false },
		format = true,
		run = "onType",
		workingDirectory = { mode = "auto" },
	},
})
vim.lsp.enable("eslint")

vim.lsp.config("html", {
	init_options = { provideFormatter = true },
	settings = {},
})
vim.lsp.enable("html")

vim.lsp.config("cssls", {
	settings = {
		css  = { validate = true },
		scss = { validate = true },
		less = { validate = true },
	},
})
vim.lsp.enable("cssls")

vim.lsp.config("jsonls", {
	init_options = { provideFormatter = true },
	settings = {
		json = {
			schemas = require("schemastore").json.schemas(),
			validate = { enable = true },
		},
	},
})
vim.lsp.enable("jsonls")

vim.lsp.config("yamlls", {
	settings = {
		yaml = {
			schemaStore = { enable = false, url = "" },
			schemas = require("schemastore").yaml.schemas(),
			validate = true,
			format = { enable = false },
			keyOrdering = false,
		},
		redhat = { telemetry = { enabled = false } },
	},
})
vim.lsp.enable("yamlls")

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = { globals = { "vim" } },
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
})
vim.lsp.enable("lua_ls")

