vim.filetype.add({
	filename = {
		["buf.yaml"] = "buf-config",
		["buf.gen.yaml"] = "buf-config",
		["buf.work.yaml"] = "buf-config",
		["buf.lock"] = "buf-config",
	},
})
pcall(vim.treesitter.language.register, "yaml", "buf-config")

vim.lsp.config("buf_ls", {
	cmd          = { "buf", "lsp", "serve", "--log-format=text" },
	filetypes    = { "proto", "buf-config" },
	root_markers = { "buf.yaml", "buf.work.yaml", "buf.gen.yaml", ".git" },
})

vim.lsp.enable("buf_ls")
