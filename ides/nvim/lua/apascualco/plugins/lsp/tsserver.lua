local util = require("lspconfig.util")

-- capacidades (nvim-cmp)
local capabilities = vim.lsp.protocol.make_client_capabilities()
pcall(function()
	capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
end)

-- ts_ls
vim.lsp.config("ts_ls", {
	capabilities = capabilities,
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
	on_attach = function(client)
		if client.server_capabilities then
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
		end
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