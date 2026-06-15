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
		"gopls",
		"lua_ls",
		"ts_ls",
		"eslint",
		"html",
		"cssls",
		"jsonls",
		"rust_analyzer",
	},
	-- We enable servers explicitly below (and in go/rust/tsserver.lua), so don't
	-- let mason-lspconfig auto-enable them too (would double-enable). 2.x defaults to true.
	automatic_enable = false,
}

-- Single source of truth for capabilities (cmp + foldingRange), built in setup.lua
local capabilities = require("apascualco.plugins.lsp.setup").capabilities

-- ESLint
vim.lsp.config("eslint", {
	capabilities = capabilities,
	settings = {
		experimental = { useFlatConfig = false },
		format = true,
		run = "onType",
		workingDirectory = { mode = "auto" },
	},
})
vim.lsp.enable("eslint")

-- HTML
vim.lsp.config("html", {
	capabilities = capabilities,
	init_options = { provideFormatter = true },
	settings = {},
})
vim.lsp.enable("html")

-- CSS (cssls)
vim.lsp.config("cssls", {
	capabilities = capabilities,
	settings = {
		css  = { validate = true },
		scss = { validate = true },
		less = { validate = true },
	},
})
vim.lsp.enable("cssls")

-- JSON (jsonls) — schemas vía SchemaStore.nvim
vim.lsp.config("jsonls", {
	capabilities = capabilities,
	init_options = { provideFormatter = true },
	settings = {
		json = {
			schemas = require("schemastore").json.schemas(),
			validate = { enable = true },
		},
	},
})
vim.lsp.enable("jsonls")

-- Lua (lua_ls) — capabilities + LuaJIT runtime; the Neovim/vim API + plugin
-- libraries are injected by lazydev.nvim. Must be enabled explicitly now that
-- automatic_enable = false.
vim.lsp.config("lua_ls", {
	capabilities = capabilities,
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

