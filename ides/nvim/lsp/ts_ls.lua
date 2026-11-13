local inlay_hints = {
	includeInlayParameterNameHints = "all",
	includeInlayVariableTypeHints = true,
	includeInlayFunctionLikeReturnTypeHints = true,
	includeInlayEnumMemberValueHints = true,
}

return {
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	init_options = {
		hostInfo = "neovim",
		tsserver = { maxTsServerMemory = 4096 },
		preferences = { includePackageJsonAutoImports = "on" },
	},
	on_attach = function(client)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
	settings = {
		typescript = {
			format = { enable = false },
			preferences = {
				preferGoToSourceDefinition = true,
				includeCompletionsForModuleExports = true,
				includeCompletionsWithInsertTextCompletions = true,
			},
			inlayHints = inlay_hints,
		},
		javascript = {
			format = { enable = false },
			preferences = { preferGoToSourceDefinition = true },
			inlayHints = inlay_hints,
		},
	},
}
