local util = require("lspconfig.util")
local lsp_setup = require("apascualco.plugins.lsp.setup")

-- ts_ls
vim.lsp.config("ts_ls", {
	capabilities = lsp_setup.capabilities,
	single_file_support = true,
	filetypes = {
		"javascript","javascriptreact","javascript.jsx",
		"typescript","typescriptreact","typescript.tsx",
	},
	init_options = {
		hostInfo = "neovim",
		tsserver = { maxTsServerMemory = 4096 },
		preferences = {
			includePackageJsonAutoImports = "on",
		},
	},
	on_attach = function(client, bufnr)
		-- Disable formatting (use prettier via conform instead)
		if client.server_capabilities then
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
		end
		-- Call universal on_attach for inlay hints, etc.
		lsp_setup.on_attach(client, bufnr)
	end,
	settings = {
		typescript = {
			format = { enable = false },
			preferences = {
				preferGoToSourceDefinition = true,
				includeCompletionsForModuleExports = true,
				includeCompletionsWithInsertTextCompletions = true,
			},
			inlayHints = {
				includeInlayParameterNameHints = "all",
				includeInlayVariableTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			},
		},
		javascript = {
			format = { enable = false },
			preferences = { preferGoToSourceDefinition = true },
			inlayHints = {
				includeInlayParameterNameHints = "all",
				includeInlayVariableTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			},
		},
	},
})
vim.lsp.enable("ts_ls")