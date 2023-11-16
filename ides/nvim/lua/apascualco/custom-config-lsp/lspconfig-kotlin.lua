local lspconfig = require('lspconfig')
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local util = require("lspconfig/util")

lspconfig.kotlin_language_server.setup({
	cmd = {'kotlin-language-server'},
	filetypes = {"kotlin"},
	root_dir = util.root_pattern("settings.gradle"),
	capabilities = capabilities,
	on_attach = on_attach,
})
