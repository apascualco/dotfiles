local lspconfig = require('lspconfig')
local util = require("lspconfig/util")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

lspconfig.kotlin_language_server.setup({
	cmd = {'/Users/apascualco/workdir/tools/kotlin-language-server/server/build/install/server/bin/kotlin-language-server'},
	filetypes = {"kotlin"},
	root_dir = util.root_pattern("settings.gradle.kts"),
	capabilities = capabilities,
})
