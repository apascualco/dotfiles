vim.lsp.config("rust_analyzer", {
	cmd          = { "rust-analyzer" },
	filetypes    = { "rust" },
	root_markers = { "Cargo.toml", "rust-project.json", ".git" },

	settings     = {
		["rust-analyzer"] = {
			cargo = {
				features = "all",
				buildScripts = { enable = true },
			},

			procMacro = {
				enable = true,
			},

			check = {
				command = "clippy",
			},

			rustfmt = {
				extraArgs = { "+stable" },
			},

			diagnostics = {
				enable = true,
			},

			inlayHints = {
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

vim.lsp.enable("rust_analyzer")
