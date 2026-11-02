vim.lsp.config("ts_ls", {
	filetypes = {
		"javascript", "javascriptreact",
		"typescript", "typescriptreact",
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