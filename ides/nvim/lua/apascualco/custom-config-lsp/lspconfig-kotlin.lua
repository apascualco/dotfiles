local lspconfig = require('lspconfig')
local util = require("lspconfig/util")

lspconfig.kotlin_language_server.setup({
	cmd = {'/Users/apascualco/workdir/tools/kotlin-language-server/server/build/install/server/bin/kotlin-language-server'},
	filetypes = {"kotlin"},
	root_dir = util.root_pattern("settings.gradle.kts"),
	capabilities = capabilities,
	on_attach = on_attach,
})
