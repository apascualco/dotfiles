local lsp_setup = require("apascualco.plugins.lsp.setup")

vim.lsp.config("rust_analyzer", {
	on_attach    = lsp_setup.on_attach,
	cmd          = { "rust-analyzer" },
	filetypes    = { "rust" },
	root_markers = { "Cargo.toml", "rust-project.json", ".git" },
	capabilities = lsp_setup.capabilities,

	settings     = {
		["rust-analyzer"] = {
			cargo = {
				allFeatures = true,
				loadOutDirsFromCheck = true,
			},

			procMacro = {
				enable = true,
			},

			checkOnSave = {
				command = "clippy",
			},

			rustfmt = {
				extraArgs = { "+stable" },
			},

			diagnostics = {
				enable = true,
			},

			inlayHints = {
				enable = true,
				chainingHints = { enable = true },
				parameterHints = { enable = true },
				typeHints = { enable = true },
			},

			completion = {
				autoimport = { enable = true },
			},

			imports = {
				granularity = { group = "module" },
				prefix = "self",
			},
		},
	},
})
