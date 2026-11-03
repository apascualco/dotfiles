return {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_markers = { "go.work", "go.mod", ".git" },
	on_init = function(client)
		local overrides = require("apascualco.lang.go.project").gopls_settings(client.root_dir)
		if overrides then
			client.settings = vim.tbl_deep_extend("force", client.settings, { gopls = overrides })
			client:notify("workspace/didChangeConfiguration", { settings = client.settings })
		end
	end,
	settings = {
		gopls = {
			buildFlags = { "-tags=eval,e2e" },
			completeUnimported = true,
			gofumpt = true,
			vulncheck = "Imports",
			usePlaceholders = true,
			completeFunctionCalls = true,
			experimentalPostfixCompletions = true,
			analyses = { unusedparams = true, shadow = true, unusedwrite = true, useany = true, ST1000 = false },
			staticcheck = true,
			codelenses = {
				generate = true,
				regenerate_cgo = true,
				tidy = true,
				upgrade_dependency = true,
				vendor = true,
			},
			importShortcut = "Both",
			semanticTokens = true,
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
		},
	},
}
