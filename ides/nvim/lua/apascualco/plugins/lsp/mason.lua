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
		"jsonls"
    },
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
pcall(function()
	capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
end)

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

-- JSON (jsonls)
vim.lsp.config("jsonls", {
	capabilities = capabilities,
	init_options = { provideFormatter = true },
	settings = {},
})
vim.lsp.enable("jsonls")